//
//  SchoolEvent.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/19/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import SwiftyJSON

class SchoolEvent: Event {
	
	struct Audience: Decodable {
		
		let grade: Grade
		let mandatory: Bool
		
		init(json: JSON) throws {
			
			self.grade = try Optionals.unwrap(Grade(rawValue: Optionals.unwrap(json["grade"].int)))
			self.mandatory = try Optionals.unwrap(json["mandatory"].bool)
			
		}
		
	}
	
	private(set) var audiences: [Audience]?
	
	required init(json: JSON) throws {
		try super.init(json: json)
		
		if json["audience"].exists() {
			self.audiences = try (json["audience"].array ?? []).map({ try Audience(json: $0) })
		}
	}
	
	override func updateContent(from: Event) {
		super.updateContent(from: from)
		
		if let schoolEvent = from as? SchoolEvent {
			self.audiences = schoolEvent.audiences
		}
	}
	
}

class AllSchoolEvent: SchoolEvent {
	
	override var eventType: EventTypes {
		return .allSchool
	}
	
}

class UpperSchoolEvent: SchoolEvent {
	
	override var eventType: EventTypes {
		return .upperSchool
	}
	
}

class SchooldayEvent: SchoolEvent {
	
	override var eventType: EventTypes {
		return .schoolDay
	}
	
}
