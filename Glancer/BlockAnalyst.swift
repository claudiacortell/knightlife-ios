//
//  BlockAnalyst.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/6/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class BlockAnalyst {
	
	let schedule: DateSchedule
	let block: Block
	
	init(schedule: DateSchedule, block: Block) {
		self.schedule = schedule
		self.block = block
	}
	
	func getCourses() -> BlockCourseList {
		return CourseManager.instance.getCourses(schedule: self.schedule, block: block.id)
	}
	
	func getDisplayName() -> String {
		if self.block.id == .custom {
			if let custom = self.block.custom {
				return custom.name
			} else {
				return block.id.displayName
			}
		}
		
		let courses = self.getCourses()
		if !courses.isEmpty {
			return courses.courses.first!.name
		} else {
			guard self.block.id == .lab, let previous = self.schedule.getBlockBefore(self.block) else {
				return self.block.id.displayName
			}
			
//			Logic for if the block is a Lab.
			let previousAnalyst = BlockAnalyst(schedule: self.schedule, block: previous)
			if previousAnalyst.getCourses().isEmpty {
				return self.block.id.displayName
			} else {
				return "\(previousAnalyst.getDisplayName()) \(self.block.id.displayName)"
			}
		}
	}
	
	func getColor() -> UIColor {
		if self.block.id == .custom, let custom = self.block.custom {
			return custom.color
		}
		
		let courses = self.getCourses()
		if courses.isEmpty {
			if self.block.id == .lab, let previous = self.schedule.getBlockBefore(self.block) {
				let previousAnalyst = BlockAnalyst(schedule: self.schedule, block: previous)
				return previousAnalyst.getColor()
			}
			
//			return self.getColor
//			TODO: IMPLEMENT BLOCK COLORS

			return UIColor(hex: "999999")!
		}
		
		return courses.courses.first!.color ?? UIColor(hex: "999999")!
	}
}
