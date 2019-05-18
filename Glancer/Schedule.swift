//
//  Schedule.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/24/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
import RealmSwift
import Signals
import SwiftyUserDefaults

// Schedule-specific DefaultsKeys
extension DefaultsKeys {
	
	// Key is String: Any because Int indexes don't work with this version of SwiftyUD
	fileprivate static let firstLunches: DefaultsKey<[String: Any]> = DefaultsKey<[String: Any]>("firstLunches")
	
}

// Config variables
extension Schedule {
	
	fileprivate static let FIRST_LUNCH_DEFAULT_VALUE = true
	
}


// Structs needed to function
extension Schedule {
	
	struct FirstLunchChange {
		
		let dayOfWeek: DayOfWeek
		let firstLunch: Bool
		
	}
	
}

final class Schedule: BadgeTethered, Decodable, Refreshable {

	let onUpdate: Signal<Schedule> = Signal<Schedule>()
	
	let badge: String
//	private(set) var state: String!
	
	let date: Date
	private(set) var dayOfWeek: DayOfWeek!
	
	private(set) var timetables: [Timetable]!
	
	var prefs: BadgeTetheredPreferences { return BadgeTetheredPreferences.get(for: self) }
	
	required init(json: JSON) throws {

		// Load data from JSON
		self.badge = try Optionals.unwrap(json["badge"].string)
//		self.state = try Optionals.unwrap(json["state"].string)

		self.date = try Optionals.unwrap(json["date"].string?.dateFromInternetFormat)
		self.dayOfWeek = DayOfWeek(rawValue: json["day"].int ?? -1) ?? self.date.weekday
		
		self.timetables = try Optionals.unwrap(json["timetables"].array).map({
			var timetable = try Timetable(json: $0)
			timetable.setSchedule(schedule: self)
			
			return timetable
		})

		// Update content when a new Schedule of this date is fetched
		Schedule.onFetch.subscribe(with: self) {
			self.updateContent(from: $0)
		}.filter({ $0 == self })
		
		// Listen to changes in user's first lunch settings
		Schedule.onFirstLunchChange.subscribe(with: self) {
			self.onFirstLunchUpdate.fire($0.firstLunch)
		}.filter({ $0.dayOfWeek == self.dayOfWeek })
		
	}
	
	func updateContent(from: Schedule) {
//		self.state = from.state
		self.dayOfWeek = from.dayOfWeek
		self.timetables = from.timetables
		
		self.onUpdate.fire(self)
	}
	
	@discardableResult
	func refresh() -> CallbackSignal<Schedule> {
		// Get a new schedule instance through the Manager. This will, upon completion, update this object from the onFetch Signal.
		return Schedule.fetch(self.badge)
	}
	
	let onSelectedTimetableChange = Signal<Timetable?>()
	var selectedTimetable: Timetable? {
		get {
//			if let timetableBadge = self.prefs["selectedTimetable"] as? String {
//				// Find timetable by that badge
//				if let foundTimetable = self.timetables.filter({ $0.badge == timetableBadge }).first {
//					return foundTimetable
//				}
//			}
			
			// If there's none selected, we just return the default
			return self.defaultTimetable
		}
		
		set {
			guard let newValue = newValue else {
				self.prefs["selectedTimetable"] = nil
				self.onSelectedTimetableChange.fire(nil)
				
				return
			}
			
			self.prefs["selectedTimetable"] = newValue.badge
			self.onSelectedTimetableChange.fire(newValue)
		}
	}
	
	var defaultTimetable: Timetable? {
		if self.timetables.isEmpty {
			return nil
		}
		
		if let userGrade = Grade.userGrade {
			// Get the first timetable relevant to user's grade
			if let gradeTimetable = self.timetables.filter({ $0.gradeSpecific && $0.grades.contains(userGrade) }).first {
				return gradeTimetable
			}
		}
		
		// If no grade-specific timetables, get the first non grade specific timetable
		return self.timetables.filter({ !$0.gradeSpecific }).first
	}
	
	
	let onFirstLunchUpdate = Signal<Bool>()
	var hasFirstLunch: Bool {
		get {
			// Fetch schedule-specific setting first
//			if let badgePref = self.prefs["firstLunch"] as? Bool {
//				return badgePref
//			}
			
			return Schedule.firstLunches[self.dayOfWeek]!
		}
		
		set {
//			self.prefs["firstLunch"] = newValue
			self.onFirstLunchUpdate.fire(newValue)
		}
	}
	
	var hasSchool: Bool {
		return self.selectedTimetable != nil && !self.selectedTimetable!.blocks.isEmpty
	}
	
}

extension Schedule: Equatable {
	
	static func ==(lhs: Schedule, rhs: Schedule) -> Bool {
		return lhs.badge == rhs.badge
	}
	
}



// Abstracted core logic
extension Schedule {
	
	// Fired when a Schedule instance is fetched
	static let onFetch = Signal<Schedule>()
	private static var activeFetches: [String: CallbackSignal<Schedule>] = [:]
	
	// Fired when a first lunch setting is changed
	static let onFirstLunchChange = Signal<FirstLunchChange>()
	
	static func fetch(_ badge: String) -> CallbackSignal<Schedule> {
		// If there's another active signal already happening, we tag onto it.
		if let activeSignal = Schedule.activeFetches[badge] {
			return activeSignal
		}
		
		let signal = CallbackSignal<Schedule>()
		
		Schedule.activeFetches[badge] = signal
		
		// Fetch Lunch object
		let provider = MoyaProvider<API>()
		provider.request(.getScheduleBy(badge: badge)) {
			switch $0 {
			case let .success(result):
				do {
					_ = try result.filterSuccessfulStatusCodes()
					
					let json = try JSON(data: result.data)
					let schedule = try Schedule(json: json)
					
					signal.fire(.success(schedule))
					
					// Notify listeners that a new Lunch object has been fetched
					Schedule.onFetch.fire(schedule)
				} catch {
					signal.fire(.failure(error))
				}
			case let .failure(error):
				signal.fire(.failure(error))
			}
		}
		
		// Remove the signal from the active list
		signal.subscribeOnce(with: self) { _ in
			Schedule.activeFetches.removeValue(forKey: badge)
		}
		
		return signal
	}
	
	static func fetch(for: Date) -> CallbackSignal<Schedule> {
		let signalId = `for`.webSafeDate
		
		// If there's another active signal already happening, we tag onto it.
		if let activeSignal = Schedule.activeFetches[signalId] {
			return activeSignal
		}
		
		let signal = CallbackSignal<Schedule>()
		
		Schedule.activeFetches[signalId] = signal
		
		// Fetch Lunch object
		let provider = MoyaProvider<API>()
		provider.request(.getScheduleFor(date: `for`)) {
			switch $0 {
			case let .success(result):
				do {
					_ = try result.filterSuccessfulStatusCodes()
					
					let json = try JSON(data: result.data)
					let schedule = try Schedule(json: json)
					
					signal.fire(.success(schedule))
					
					// Notify listeners that a new Lunch object has been fetched
					Schedule.onFetch.fire(schedule)
				} catch {
					signal.fire(.failure(error))
				}
			case let .failure(error):
				signal.fire(.failure(error))
			}
		}
		
		// Remove the signal from the active list
		signal.subscribeOnce(with: self) { _ in
			Schedule.activeFetches.removeValue(forKey: signalId)
		}
		
		return signal
	}
	
	// Handles user settings for first/second lunch
	static var firstLunches: [ DayOfWeek: Bool ] {
		
		get {
			let savedValues = Defaults[.firstLunches]
			
			// Get values based on savedValues, else default to true
			var values: [DayOfWeek: Bool] = [:]
			DayOfWeek.values.forEach({ values[$0] = (savedValues[$0.shortName] as? Bool) ?? Schedule.FIRST_LUNCH_DEFAULT_VALUE })
			
			return values
		}
		
		set {
			let newValue = newValue
			let oldValue = self.firstLunches
			
			// Fire Signal if any values changed
			for dayOfWeek in DayOfWeek.values {
				if newValue[dayOfWeek] != oldValue[dayOfWeek] {
					Schedule.onFirstLunchChange.fire(FirstLunchChange(dayOfWeek: dayOfWeek, firstLunch: newValue[dayOfWeek] ?? Schedule.FIRST_LUNCH_DEFAULT_VALUE))
				}
			}
			
			var newDictionary: [String: Any] = [:]
			newValue.forEach({
				newDictionary[$0.key.shortName] = $0.value
			})
			
			Defaults[.firstLunches] = newDictionary
		}
		
	}
	
}
