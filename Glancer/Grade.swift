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

extension DefaultsKeys {
	
	static let gradeMigratedToRealm = DefaultsKey<Bool>("migrated.grade")
	static let gradeLegacy = DefaultsKey<Int>("events.grade")
	
}

extension Grade {
	
	static var userGrade: Grade? {
		get {
			// Not yet migrated so fetch via legacy
			if !Defaults[.gradeMigratedToRealm] {
				Defaults[.gradeMigratedToRealm] = true
				
				let legacyGrade = Defaults[.gradeLegacy]
				
				if let grade = Grade(rawValue: legacyGrade - 1) {
					// Save legacy in new value
					Defaults[.userGrade] = grade.rawValue
					
					print("Loaded user legacy grade \( grade.singular )")
					
					return grade
				}
			}
			
			return Grade(rawValue: Defaults[.userGrade] ?? -1)
		}
		
		set {
			// Set migrated to true so we don't accidentally overwrite new settings
			Defaults[.gradeMigratedToRealm] = true
			
			Defaults[.userGrade] = newValue == nil ? nil : newValue!.rawValue
		}
	}
	
}
