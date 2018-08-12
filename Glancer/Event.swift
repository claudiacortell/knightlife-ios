//
//  Event.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

struct Event {
	
	let block: BlockID
	let description: String
	
	let audience: [EventAudience]

}

extension Event {
	
	func getWholeSchoolAudience() -> EventAudience? {
		for audience in self.audience {
			if audience.grade == .allSchool {
				return audience
			}
		}
		return nil
	}
	
	func isForWholeSchool() -> Bool {
		return self.getWholeSchoolAudience() != nil
	}
	
	func getAudienceFor(grade: Grade) -> EventAudience? {
		for audience in self.audience {
			if audience.grade == grade {
				return audience
			}
		}
		return nil
	}
	
	func getMostRelevantAudience() -> EventAudience? {
		let userGrade = EventManager.instance.userGrade!
		
		if let gradeAudience = self.getAudienceFor(grade: userGrade) {
			return gradeAudience
		}
		
		return self.getWholeSchoolAudience()
	}
	
	func isRelevantToUser() -> Bool {
		if EventManager.instance.userGrade! == .allSchool {
			return true
		}
		
		return self.getMostRelevantAudience() != nil
	}
	
	func completeDescription() -> String {
		let userGrade = EventManager.instance.userGrade!
		
		let addDescriptionPunctuation = !(self.description.last == "." || self.description.last == "?" || self.description.last == "!")

		if userGrade == .allSchool || !self.isRelevantToUser() { // Not set or not relevant to user
			let otherGrades: String = {
				var otherGradesString = ""
				for audience in self.audience { otherGradesString += "\(audience.mandatory ? "Mandatory" : "Optional") for \(audience.grade.displayName)." }
				return otherGradesString.trimmingCharacters(in: .whitespaces)
			}()
			
			return "\(self.description)\(addDescriptionPunctuation ? "." : "") \(otherGrades)"
		}
		
		let bestAudience = self.getMostRelevantAudience()!
		let otherGrades: String = {
			var string = ""
			for audience in self.audience {
				if audience === bestAudience { continue } // Ignore own grade
				string += "\(audience.mandatory ? "Mandatory" : "Optional") for \(audience.grade.displayName). " // E.G. Optional for Sophomores.
			}
			return string.trimmingCharacters(in: .whitespaces)
		}()
		
		return "\(bestAudience.mandatory ? "MANDATORY" : "OPTIONAL") \(self.description)\(addDescriptionPunctuation ? "." : "") \(otherGrades)"
	}
	
}
