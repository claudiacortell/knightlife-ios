//
//  DayEventList.swift
//  Glancer
//
//  Created by Dylan Hanson on 5/12/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import Signals
import SwiftyJSON
import Moya

final class DayEventList: Decodable, Refreshable {
	
	let onUpdate: Signal<DayEventList> = Signal<DayEventList>()
	
	let date: Date
	private(set) var events: [Event]
	
	required init(json: JSON) throws {
		
		self.date = try Optionals.unwrap(json["date"].string?.dateFromInternetFormat)
		self.events = (try Optionals.unwrap(json["events"].array)).compactMap({ try? Event.instantiate(json: $0) })
		
		self.listenToEventUpdates()
		
		// Register self for updates
		DayEventList.onFetch.subscribe(with: self) {
			// Update this event with the newest version
			self.updateContent(from: $0)
		}.filter({ $0.date.webSafeDate == self.date.webSafeDate })
		
		
	}
	
	init(date: Date, events: [Event]) {
		
		self.date = date
		self.events = events
		
		self.listenToEventUpdates()
		
	}
	
	func refresh() -> CallbackSignal<DayEventList>{
		let relaySignal = CallbackSignal<DayEventList>()
		
		// Relay the array Callback to a single Event
		DayEventList.fetch(for: self.date).subscribeOnce(with: self) {
			switch $0 {
			case .success(let eventList):
				self.updateContent(from: eventList)
				relaySignal.fire(.success(eventList))
			case .failure(let error):
				relaySignal.fire(.failure(error))
			}
			
			// I'm concerned that every Event will update, thereby communicating our 'onUpdate' Signal many, many times. I'm not sure that can be helped, though.
		}
		
		return relaySignal
	}
	
	func updateContent(from: DayEventList) {
		
		self.stopListeningToEventUpdates()
		
		self.events = from.events
		
		self.listenToEventUpdates()
		
	}
	
	private func listenToEventUpdates() {
		
		// When an Event updates, we communicate that update to our Signal
		self.events.forEach({
			$0.onUpdate.subscribe(with: self) { _ in
				self.onUpdate.fire(self)
			}
		})
		
	}
	
	private func stopListeningToEventUpdates() {
		
		self.events.forEach({
			$0.onUpdate.cancelSubscription(for: self)
		})
		
	}
	
}

extension DayEventList {
	
	var blockEvents: [Event] {
		return self.events.filter({ $0.schedule.usesBlocks })
	}
	
	var timeEvents: [Event] {
		return self.events.filter({ $0.schedule.usesTime })
	}
	
	func eventsFor(block: Block.ID) -> [Event] {
		return self.blockEvents.filter({ $0.schedule.blocks!.contains(block) })
	}
	
}

extension DayEventList {
	
	static let onFetch = Signal<DayEventList>()
	private static var activeFetches: [String: CallbackSignal<DayEventList>] = [:]
	
	// Fetches
	static func fetch(for: Date) -> CallbackSignal<DayEventList> {
		let signalId = `for`.webSafeDate
		
		// If there's another active signal already happening, we tag onto it.
		if let activeSignal = DayEventList.activeFetches[signalId] {
			return activeSignal
		}
		
		let signal = CallbackSignal<DayEventList>()
		
		DayEventList.activeFetches[signalId] = signal
		
		// Fetch Lunch object
		let provider = MoyaProvider<API>()
		provider.request(.getEventsFor(date: `for`)) {
			switch $0 {
			case let .success(result):
				do {
					_ = try result.filterSuccessfulStatusCodes()
					
					let json = try JSON(data: result.data)
					let eventList = try DayEventList(json: json)
					
					signal.fire(.success(eventList))
					
					// Notify listeners that a new Event object has been fetched
					DayEventList.onFetch.fire(eventList)
					
					eventList.events.forEach({ Event.onFetch.fire($0) })
				} catch {
					signal.fire(.failure(error))
				}
			case let .failure(error):
				signal.fire(.failure(error))
			}
		}
		
		// Remove the signal from the active list
		signal.subscribeOnce(with: self) { _ in
			DayEventList.activeFetches.removeValue(forKey: signalId)
		}
		
		return signal
	}
	
}
