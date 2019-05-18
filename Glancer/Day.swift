//
//  Day.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/28/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import Moya
import Timepiece
import SwiftyJSON
import Signals

final class Day: Decodable, Refreshable {
	
	let onUpdate: Signal<Day> = Signal<Day>()
	
	let date: Date
	
	private(set) var schedule: Schedule!
	private(set) var lunch: Lunch!
	private(set) var events: DayEventList!
	
	required init(json: JSON) throws {
				
		self.date = try Optionals.unwrap(json["date"].string?.dateFromInternetFormat)
		
		self.schedule = try Schedule(json: json["schedule"])
		self.lunch = try Lunch(json: json["lunch"])
		
		let events: [Event] = try Optionals.unwrap(json["events"].array).compactMap({
			try Event.instantiate(json: $0)
		})
		
		self.events = DayEventList(date: self.date, events: events)
		
		Day.onFetch.subscribe(with: self) {
			self.updateContent(from: $0)
		}.filter({ $0 == self })
		
	}
	
	func updateContent(from: Day) {
		
//		// We only need to change the list of events. We can assume that the Schedule and Event objects will update themselves.
//		self.events = from.events
//
	}
	
	@discardableResult
	func refresh() -> CallbackSignal<Day> {
		return Day.fetch(for: self.date)
	}
	
	// If any of the children update, relay that to Bundle listeners
	private func listenToChildren() {
		self.schedule.onUpdate.subscribe(with: self) { _ in
			self.onUpdate.fire(self)
		}
		
		self.lunch.onUpdate.subscribe(with: self) { _ in
			self.onUpdate.fire(self)
		}
		
		self.events.onUpdate.subscribe(with: self) { _ in
			self.onUpdate.fire(self)
		}
	}
	
}

extension Day {
	
	// Returns whether we have events that use time
	var hasAfterSchoolEvents: Bool {
		return !self.events.timeEvents.isEmpty
	}
	
}

extension Day: Equatable {
	
	static func ==(lhs: Day, rhs: Day) -> Bool {
		return lhs.date == rhs.date
	}
	
}

/*
Enable Fetching mechanisms for Bundle
*/
extension Day {
	
	static let onFetch = Signal<Day>()
	private static var activeFetches: [String: CallbackSignal<Day>] = [:]
	
	static func fetch(for: Date) -> CallbackSignal<Day> {
		let signalId = `for`.webSafeDate
		
		// If there's another active signal already happening, we tag onto it.
		if let activeSignal = Day.activeFetches[signalId] {
			return activeSignal
		}
		
		let signal = CallbackSignal<Day>()
		
		Day.activeFetches[signalId] = signal
		
		// Fetch Lunch object
		let provider = MoyaProvider<API>()
		provider.request(.getBundle(date: `for`)) {
			switch $0 {
			case let .success(result):
				do {
					_ = try result.filterSuccessfulStatusCodes()
					
					let json = try JSON(data: result.data)
					let bundle = try Day(json: json)
					
					signal.fire(.success(bundle))
					
					// Notify listeners that a new Lunch object has been fetched
					Day.onFetch.fire(bundle)
					
					Schedule.onFetch.fire(bundle.schedule)
					Lunch.onFetch.fire(bundle.lunch)
					DayEventList.onFetch.fire(bundle.events)
				} catch {
					signal.fire(.failure(error))
				}
			case let .failure(error):
				signal.fire(.failure(error))
			}
		}
		
		// Remove the signal from the active list
		signal.subscribeOnce(with: self) { _ in
			Day.activeFetches.removeValue(forKey: signalId)
		}
		
		return signal
	}
	
}
