//
//  Lunch.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/24/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import SwiftyJSON
import Timepiece
import Moya
import Signals

final class Lunch: Refreshable, Decodable {
	
	struct Food: Decodable {
		
		let name: String
		let allergy: String?
		
		init(json: JSON) throws {

			self.name = try Optionals.unwrap(json["name"].string)
			self.allergy = json["allergy"].string

		}
		
	}
	
	let onUpdate: Signal<Lunch> = Signal<Lunch>()
	
	let badge: String
	let date: Date
	
	private(set) var title: String?
	private(set) var items: [Food]!
	
	required init(json: JSON) throws {
				
		// Load data from JSON
		self.badge = try Optionals.unwrap(json["badge"].string)
		
		self.date = try Optionals.unwrap(try Optionals.unwrap((json["date"].string)).dateInISO8601Format(with: [ .withFullDate ]))
		self.title = json["title"].string

		self.items = try (json["items"].array ?? []).map({
			return try Food(json: $0)
		})
		
		// Receive updates on Lunch from the same day
		Lunch.onFetch.subscribe(with: self) {
			self.updateContent(from: $0)
		}.filter({ $0.date == self.date })
		
	}
	
	func updateContent(from: Lunch) {
		self.title = from.title
		self.items = from.items
		
		self.onUpdate.fire(self)
	}
	
	var hasItems: Bool {
		return !self.items.isEmpty
	}
	
	@discardableResult
	func refresh() -> CallbackSignal<Lunch> {
		// Fetches a new Lunch object which then updates this one
		return Lunch.fetch(self.badge)
	}
	
}


extension Lunch {
	
	static let onFetch = Signal<Lunch>()
	private static var activeFetches: [String: CallbackSignal<Lunch>] = [:]
	
	static func fetch(_ badge: String) -> CallbackSignal<Lunch> {
		// If there's another active signal already happening, we tag onto it.
		if let activeSignal = Lunch.activeFetches[badge] {
			return activeSignal
		}
		
		let signal = CallbackSignal<Lunch>()
		
		Lunch.activeFetches[badge] = signal
		
		// Fetch Lunch object
		let provider = MoyaProvider<API>()
		provider.request(.getLunchBy(badge: badge)) {
			switch $0 {
			case let .success(result):
				do {
					_ = try result.filterSuccessfulStatusCodes()
					
					let json = try JSON(data: result.data)
					let lunch = try Lunch(json: json)
					
					signal.fire(.success(lunch))
					
					// Notify listeners that a new Lunch object has been fetched
					Lunch.onFetch.fire(lunch)
				} catch {
					signal.fire(.failure(error))
				}
			case let .failure(error):
				signal.fire(.failure(error))
			}
		}
		
		// Remove the signal from the active list
		signal.subscribeOnce(with: self) { _ in
			Lunch.activeFetches.removeValue(forKey: badge)
		}
		
		// Print errors
		signal.subscribeOnce(with: self) {
			switch $0 {
			case .failure(let error): print(error.localizedDescription)
			default: break
			}
		}
		
		return signal
	}
	
	static func fetch(for: Date) -> CallbackSignal<Lunch> {
		let signalId = `for`.webSafeDate
		
		// If there's another active signal already happening, we tag onto it.
		if let activeSignal = Lunch.activeFetches[signalId] {
			return activeSignal
		}
		
		let signal = CallbackSignal<Lunch>()
		
		Lunch.activeFetches[signalId] = signal
		
		// Fetch Lunch object
		let provider = MoyaProvider<API>()
		provider.request(.getLunchFor(date: `for`)) {
			switch $0 {
			case let .success(result):
				do {
					_ = try result.filterSuccessfulStatusCodes()
					
					let json = try JSON(data: result.data)
					let lunch = try Lunch(json: json)
					
					signal.fire(.success(lunch))
					
					// Notify listeners that a new Lunch object has been fetched
					Lunch.onFetch.fire(lunch)
				} catch {
					signal.fire(.failure(error))
				}
			case let .failure(error):
				signal.fire(.failure(error))
			}
		}
		
		// Remove the signal from the active list
		signal.subscribeOnce(with: self) { _ in
			Lunch.activeFetches.removeValue(forKey: signalId)
		}
		
		return signal
	}
	
}
