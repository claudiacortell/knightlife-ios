//
//  Grade.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/24/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

enum Grade: Int {
	
	case freshmen = 0
	case sophomores = 1
	case juniors = 2
	case seniors = 3

	var singular: String {
		switch self {
		case .freshmen:
			return "Freshman"
		case .sophomores:
			return "Sophomore"
		case .juniors:
			return "Junior"
		case .seniors:
			return "Senior"
		}
	}
	
	var plural: String {
		switch self {
		case .freshmen:
			return "Freshmen"
		case .sophomores:
			return "Sophomores"
		case .juniors:
			return "Juniors"
		case .seniors:
			return "Seniors"
		}
	}
	
}

extension Grade {
	
	static var userGrade: Grade? {
		get {
			return Grade(rawValue: Defaults[.userGrade] ?? -1)
		}
		
		set {
			Defaults[.userGrade] = newValue == nil ? nil : newValue!.rawValue
		}
	}
	
}
