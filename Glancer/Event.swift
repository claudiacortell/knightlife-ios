//
//  Event.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/15/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

protocol Event {
	
	var description: String { get }
	var audience: [EventAudience] { get }
	
}

struct BlockEvent: Event {
	
	let block: Block.ID
	let description: String
	
	let audience: [EventAudience]

}

struct TimeEvent: Event {
	
	let startTime: Date
	let endTime: Date?
	
	let description: String
	
	let audience: [EventAudience]
	
}

extension Event {
	
	func getWholeSchoolAudience() -> EventAudience? {
		for audience in self.audience {
			if audience.grade == nil {
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
		let userGrade = Grade.userGrade
		
		if userGrade != nil, let gradeAudience = self.getAudienceFor(grade: userGrade!) {
			return gradeAudience
		}
		
		return self.getWholeSchoolAudience()
	}
	
	func isRelevantToUser() -> Bool {
		if Grade.userGrade == nil {
			return true
		}
		
		return self.getMostRelevantAudience() != nil
	}
	
	func completeDescription() -> String {
		let userGrade = Grade.userGrade
		
		let addDescriptionPunctuation = !(self.description.last == "." || self.description.last == "?" || self.description.last == "!")

		if userGrade == nil || !self.isRelevantToUser() { // Not set or not relevant to user
			let otherGrades: String = {
				var otherGradesString = ""
				for audience in self.audience { otherGradesString += "\((audience.mandatory ? "Mandatory" : "Optional")) for \(audience.grade == nil ? "All School" : audience.grade!.plural)." }
				return otherGradesString.trimmingCharacters(in: .whitespaces)
			}()
			
			return "\(self.description)\(addDescriptionPunctuation ? "." : "") \(otherGrades)"
		}
		
		let bestAudience = self.getMostRelevantAudience()!
		let otherGrades: String = {
			var string = ""
			for audience in self.audience {
				if audience === bestAudience { continue } // Ignore own grade
				string += "\(audience.mandatory ? "Mandatory" : "Optional") for \(audience.grade == nil ? "All School" : audience.grade!.plural). " // E.G. Optional for Sophomores.
			}
			return string.trimmingCharacters(in: .whitespaces)
		}()
		
		return "\(bestAudience.mandatory ? "MANDATORY" : "OPTIONAL") \(self.description)\(addDescriptionPunctuation ? "." : "") \(otherGrades)"
	}
	
}
