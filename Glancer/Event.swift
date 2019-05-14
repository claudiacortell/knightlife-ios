//
//  Event.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/19/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import SwiftyJSON
import Timepiece
import Moya
import UserNotifications
import Signals

class Event: BadgeTethered, Decodable {
	
	static func instantiate(json: JSON) throws -> Event {
		return try EventTypes.instantiate(json: json)
	}
	
	var eventType: EventTypes {
		return .generic
	}
	
	let onUpdate: Signal<Event> = Signal<Event>()
	
	let badge: String
	private(set) var state: String = ""
	
	let kind: String
	private(set) var categories: [ String ]

	let date: Date
	private(set) var schedule: EventSchedule
	
	private(set) var title: String
	private(set) var description: String?
	
	private(set) var location: String?
	
	private(set) var changed: Bool
	private(set) var cancelled: Bool
	private(set) var postponed: Bool
	
	var prefs: BadgeTetheredPreferences { return BadgeTetheredPreferences.get(for: self) }
	
	required init(json: JSON) throws {

		self.badge = try Optionals.unwrap(json["badge"].string)
//		self.state = try Optionals.unwrap(json["state"].string)
		self.state = ""

		self.kind = json["kind"].string ?? "Event"
		self.categories = try Optionals.unwrap(json["categories"].arrayObject).map({ $0 as! String })

		self.date = try Optionals.unwrap(try Optionals.unwrap(json["date"].string).dateFromInternetFormat)
		self.schedule = try EventSchedule(json: json["schedule"])
		
		self.title = try Optionals.unwrap(json["title"].string)
		self.description = json["description"].string
		
		self.location = json["location"].string
		
		self.changed = try Optionals.unwrap(json["flags"]["changed"].bool)
		self.cancelled = try Optionals.unwrap(json["flags"]["cancelled"].bool)
		self.postponed = try Optionals.unwrap(json["flags"]["postponed"].bool)
		
		// Register self for updates
		Event.onFetch.subscribe(with: self) {
			// Update this event with the newest version
			self.updateContent(from: $0)
		}.filter({ $0.badge == self.badge })
		
	}
	
	func updateContent(from: Event) {
		
		self.state = from.state
		
		self.categories = from.categories
		
		self.schedule = from.schedule
		
		self.title = from.title
		self.description = from.description
		
		self.location = from.location
		
		self.changed = from.changed
		self.cancelled = from.cancelled
		
		self.postponed = from.postponed
		
		self.onUpdate.fire(self)
		
	}
	
	func refresh() -> CallbackSignal<Event> {
		let relaySignal = CallbackSignal<Event>()
		
		// Relay the array Callback to a single Event
		Event.fetch(self.badge).subscribeOnce(with: self) {
			switch $0 {
			case .success(let events):
				relaySignal.fire(.success(events))
			case .failure(let error):
				relaySignal.fire(.failure(error))
			}
		}
		
		return relaySignal
	}
	
}

extension Event {
	
	var mostRelevantAudienceToUser: SchoolEvent.Audience? {
		guard let audiences = (self as? SchoolEvent)?.audiences else {
			return nil
		}
		
		if let userGrade = Grade.userGrade {
			for audience in audiences {
				if audience.grade == userGrade {
					return audience
				}
			}
		}
		return nil
	}
	
	// Check if the Event is relevant to the user's grade
	var gradeRelevant: Bool {
		// If user grade isn't set, then it is relevant
		guard let userGrade = Grade.userGrade else {
			return true
		}
		
		// If the Event has Grade screening enabled
		if let schoolEvent = self as? SchoolEvent {
			if let audiences = schoolEvent.audiences {
				// Return if the Audiences contains the user's grade
				return audiences.contains(where: { $0.grade == userGrade })
			}
		}
		return true
	}
	
	var oldCompleteTitle: String {
		let userGrade = Grade.userGrade
		
		let addDescriptionPunctuation = !(self.title.last == "." || self.title.last == "?" || self.title.last == "!")
		
		if !self.gradeRelevant { // Not set or not relevant to user
			let otherGrades: String = {
				var otherGradesString = ""
				for audience in (self as! SchoolEvent).audiences! { otherGradesString += "\((audience.mandatory ? "Mandatory" : "Optional")) for \(audience.grade == nil ? "All School" : audience.grade.plural)." }
				return otherGradesString.trimmingCharacters(in: .whitespaces)
			}()
			
			return "\(self.description)\(addDescriptionPunctuation ? "." : "") \(otherGrades)"
		}
		
//		let bestAudience = self.getMostRelevantAudience()!
//		let otherGrades: String = {
//			var string = ""
//			for audience in self.audience {
//				if audience === bestAudience { continue } // Ignore own grade
//				string += "\(audience.mandatory ? "Mandatory" : "Optional") for \(audience.grade == nil ? "All School" : audience.grade!.plural). " // E.G. Optional for Sophomores.
//
//			}
//			return string.trimmingCharacters(in: .whitespaces)
//		}()
		
		return "\( self.mostRelevantAudienceToUser == nil ? "" : (self.mostRelevantAudienceToUser!.mandatory ? "MANDATORY" : "OPTIONAL") ) \(self.title)\(addDescriptionPunctuation ? "." : "")"
	}
	
}

struct EventSchedule: Decodable {
	
	let start: Date?
	let end: Date?
	
	var duration: TimeDuration? {
		return (start != nil && end != nil) ? TimeDuration(start: self.start!, end: self.end!) : nil
	}
	
	let blocks: [Block.ID]?
	
	var valid: Bool {
		return start != nil || blocks != nil
	}
	
	var usesTime: Bool {
		return start != nil
	}
	
	var usesBlocks: Bool {
		return blocks != nil
	}
	
	init(json: JSON) throws {
		if json["start"].exists(), let startString = json["start"].string {
			self.start = startString.dateFromInternetFormat
		} else {
			self.start = nil
		}
		
		if (json["end"].exists()) {
			self.end = json["end"].string?.dateFromInternetFormat
		} else {
			self.end = nil
		}
		
		if (json["blocks"].exists()) {
			self.blocks = json["blocks"].arrayObject!.map({ $0 as! String }).compactMap({ Block.ID(rawValue: $0) })
		} else {
			self.blocks = nil
		}
	}
	
}

extension Event {
	
	static let onFetch = Signal<Event>()
	private static var activeBadgeFetches: [String: CallbackSignal<Event>] = [:]
	private static var activeListFetches: [String: CallbackSignal<[Event]>] = [:]
	
	static func fetch(_ badge: String) -> CallbackSignal<Event> {
		if let activeSignal = Event.activeBadgeFetches[badge] {
			return activeSignal
		}
		
		let signal = CallbackSignal<Event>()
		
		Event.activeBadgeFetches[badge] = signal
		
		let provider = MoyaProvider<API>()
		provider.request(.getEventBy(badge: badge)) {
			switch $0 {
			case let .success(result):
				do {
					_ = try result.filterSuccessfulStatusCodes()
					
					let json = try JSON(data: result.data)
					let event = try Event.instantiate(json: json)
					
					signal.fire(.success(event))
					
					// Notify listeners that a new Lunch object has been fetched
					Event.onFetch.fire(event)
				} catch {
					signal.fire(.failure(error))
				}
			case let .failure(error):
				signal.fire(.failure(error))
			}
		}
		
		// Remove the signal from the active list
		signal.subscribeOnce(with: self) { _ in
			Event.activeBadgeFetches.removeValue(forKey: badge)
		}
		
		return signal
	}
	
	// Fetches
	static func fetch(categories: [String]? = nil, filters: [String: String]? = nil) -> CallbackSignal<[Event]> {
		let signalId: String = (categories ?? []).joined() + (filters ?? [:]).map({ "\($0):\($1)" }).joined()
		
		// If there's another active signal already happening, we tag onto it.
		if let activeSignal = Event.activeListFetches[signalId] {
			return activeSignal
		}
		
		let signal = CallbackSignal<[Event]>()
		
		Event.activeListFetches[signalId] = signal
		
		// Fetch Lunch object
		let provider = MoyaProvider<API>()
		provider.request(.getEvents(categories: categories, filters: filters ?? [:])) {
			switch $0 {
			case let .success(result):
				do {
					_ = try result.filterSuccessfulStatusCodes()
					
					let json = try JSON(data: result.data)
					let events = try Optionals.unwrap(json.array).map({
						try Event.instantiate(json: $0)
					})
					
					signal.fire(.success(events))
					
					// Notify listeners that new Events have been fetched
					events.forEach({ Event.onFetch.fire($0) })
				} catch {
					signal.fire(.failure(error))
				}
			case let .failure(error):
				signal.fire(.failure(error))
			}
		}
		
		// Remove the signal from the active list
		signal.subscribeOnce(with: self) { _ in
			Event.activeListFetches.removeValue(forKey: signalId)
		}
		
		return signal
	}
	
}
