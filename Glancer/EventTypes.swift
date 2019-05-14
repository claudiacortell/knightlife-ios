//
//  EventTypes.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/20/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import SwiftyJSON

enum EventTypes: String {
	
	case generic = "Event"
	
	case arts = "ArtsEvent"
	
	case colorwars = "ColorWarsEvent"
	
	case allSchool = "AllSchoolEvent"
	case upperSchool = "UpperSchoolEvent"
	case schoolDay = "SchoolDayEvent"
	
	init?(json: JSON) throws {
		let kind = try Optionals.unwrap(json["kind"].string)
		let type = EventTypes(rawValue: kind)
		
		if let type = type {
			self = type
			return
		}
		
		return nil
	}
	
	static func instantiate(json: JSON) throws -> Event {
		let type = try Optionals.unwrap(try EventTypes(json: json))
		
		switch type {
		case .generic:
			return try Event(json: json)
		case .arts:
			return try ArtEvent(json: json)
		case .colorwars:
			return try ColorWarEvent(json: json)
		case .allSchool:
			return try AllSchoolEvent(json: json)
		case .upperSchool:
			return try UpperSchoolEvent(json: json)
		case .schoolDay:
			return try SchooldayEvent(json: json)
		}
	}
	
}

