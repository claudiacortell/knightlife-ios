//
//  Block.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/22/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import SwiftyJSON
import UserNotifications

struct Block: Decodable {
	
	private(set) var timetable: Timetable!
	
	let badge: String
	let id: ID
	
	let state: String
	
	let firstLunch: Bool?
	
	private(set) var time: TimeDuration
	
	let annotations: [Annotation]
	var relevantAnnotations: [Annotation] {
		return self.annotations.filter({
			if !$0.gradeSpecific {
				return true
			}
			
			if let userGrade = Grade.userGrade {
				// Don't include this Annotation if it doesn't match the user's grade
				if !$0.grades.contains(userGrade) {
					return false
				}
			}
			
			return true
		})
	}
	
	var foremostAnnotation: Annotation? {
		if self.annotations.isEmpty {
			return nil
		}
		
		if let userGrade = Grade.userGrade {
			// Get the first timetable relevant to user's grade
			if let gradeAnnotation = self.annotations.filter({ $0.gradeSpecific && $0.grades.contains(userGrade) }).first {
				return gradeAnnotation
			}
		}
		
		// If no grade-specific timetables, get the first non grade specific timetable
		return self.annotations.filter({ !$0.gradeSpecific }).first
	}
	
	var categories: [String] {
		return []
	}
	
	// Return new Analyst initialized with the Block itself
	var analyst: Block.Analyst { return Block.Analyst(block: self) }
	
	init(json: JSON) throws {
		
		self.badge = try Optionals.unwrap(json["badge"].string)
		self.id = try Optionals.unwrap(ID(rawValue: json["id"].string ?? ""))
		
		self.state = try Optionals.unwrap(json["state"].string)
		
		self.firstLunch = json["firstLunch"].bool
		
		self.time = try TimeDuration(json: json["time"])
		
		self.annotations = (try Optionals.unwrap(json["annotations"].array)).compactMap({
			try? Annotation(json: $0)
		})
		
		self.time.startNotifiable.delegate = self
		self.time.endNotifiable.delegate = self
	}
	
	mutating func setTimetable(timetable: Timetable) {
		self.timetable = timetable
	}
	
}

extension Block {
	
	enum ID: String {
		
		case a = "a"
		case b = "b"
		case c = "c"
		case d = "d"
		case e = "e"
		case f = "f"
		case g = "g"
		case x = "x"
		case lunch = "lunch"
		case activities = "activities"
		case lab = "lab"
		case custom = "custom"
		case advisory = "advisory"
		case classMeeting = "class_meeting"
		case assembly = "assembly"
		
		var shortName: String {
			switch self {
			case .a:
				return "A"
			case .b:
				return "B"
			case .c:
				return "C"
			case .d:
				return "D"
			case .e:
				return "E"
			case .f:
				return "F"
			case .g:
				return "G"
			case .x:
				return "X"
			case .lunch:
				return "Lunch"
			case .activities:
				return "Activities"
			case .lab:
				return "Lab"
			case .custom:
				return "Special"
			case .advisory:
				return "Advisory"
			case .classMeeting:
				return "Class Meeting"
			case .assembly:
				return "Assembly"
			}
		}
		
		var displayName: String {
			if ID.letterBlocks.contains(self) {
				return "\(self.shortName) Block"
			}
			return self.shortName
		}
		
		static var letterBlocks: [ID] { return [.a, .b, .c, .d, .e, .f, .g, .x] }
		static var academicBlocks: [ID] { return [.a, .b, .c, .d, .e, .f, .g] }
		
	}
	
}

extension Block {
	
	struct Annotation: Decodable {
		
		let badge: String
		let grades: [Grade]

		let title: String
		let message: String?
		
		let location: String?
		let _color: String?
		
		init(json: JSON) throws {
			
			self.badge = try Optionals.unwrap(json["badge"].string)
			self.grades = try Optionals.unwrap(json["grades"].arrayObject).compactMap({
				return Grade(rawValue: ($0 as? Int) ?? -1)
			})
			
			self.title = try Optionals.unwrap(json["message"].string)
			self.message = json["message"].string
			
			self.location = json["location"].string
			self._color = json["color"].string
			
		}
		
		var gradeSpecific: Bool {
			return !self.grades.isEmpty
		}
		
	}
	
}

extension Block.Annotation {
	
	var color: UIColor? {
		return UIColor(hex: self._color ?? "")
	}
	
}

extension Block: StartNotifiableDelegate {
	
	var startState: String { return self.state }
	
	var startBadge: String { return self.badge + ".start" }
	
	var startCategories: [String] { return self.categories }
	
	func startIsNotifiable(duration: TimeDuration) -> Bool {
		return self.analyst.shouldShowBeforeClassNotifications
	}
	
	func startGetNotificationContent(duration: TimeDuration) -> UNMutableNotificationContent {
		let analyst = self.analyst
		let content = UNMutableNotificationContent()
		
		if analyst.courses.isEmpty {
			content.title = "Next Block"
		} else {
			content.title = "Get to Class"
		}
		
		content.sound = UNNotificationSound.default()
		content.body = "5 min until \(analyst.displayName)"
		
		content.threadIdentifier = "schedule"
		
		if analyst.location != nil {
			content.body = content.body + ". \(analyst.location!)"
		}
		
		return content
	}
	
	func startGetNotificationTrigger(duration: TimeDuration) -> UNCalendarNotificationTrigger {
		return UNCalendarNotificationTrigger(dateMatching: Calendar.normalizedCalendar.dateComponents([.year, .month, .day, .hour, .minute, .calendar, .timeZone], from: duration.start), repeats: false)
	}
	
}

extension Block: EndNotifiableDelegate {
	
	var endState: String { return self.state }
	
	var endBadge: String { return self.badge + ".end" }
	
	var endCategories: [String] { return self.categories }
	
	func endIsNotifiable(duration: TimeDuration) -> Bool {
		return self.analyst.shouldShowAfterClassNotifications
	}
	
	func endGetNotificationContent(duration: TimeDuration) -> UNMutableNotificationContent {
		let analyst = self.analyst
		let content = UNMutableNotificationContent()
		
		if analyst.bestCourse == nil {
			content.title = "End of Block"
		} else {
			content.title = "End of Class"
		}
		
		content.sound = UNNotificationSound.default()
		content.body = "\(analyst.displayName) ends in 2 min"
		
		content.threadIdentifier = "schedule"
		
		return content
	}
	
	func endGetNotificationTrigger(duration: TimeDuration) -> UNCalendarNotificationTrigger {
		return UNCalendarNotificationTrigger(dateMatching: Calendar.normalizedCalendar.dateComponents([.year, .month, .day, .hour, .minute, .calendar, .timeZone], from: duration.end), repeats: false)
	}
	
}

extension Block: Equatable {
	
	static func == (lhs: Block, rhs: Block) -> Bool {
		return lhs.badge == rhs.badge
	}
	
}
