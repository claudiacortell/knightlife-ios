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
				if let blockMeta = BlockMetaManager.instance.getBlockMeta(id: self.block.id), blockMeta.block == .free {
					return blockMeta.customName ?? self.block.id.displayName
				}
				
				return self.block.id.displayName
			}
			
//			Logic for if the block is a Lab.
			let previousAnalyst = BlockAnalyst(schedule: self.schedule, block: previous)
			if previousAnalyst.getCourses().isEmpty {
				let previousNameBase: String = {
					if let previousMeta = BlockMetaManager.instance.getBlockMeta(id: previous.id), previousMeta.block == .free {
						return previousMeta.customName ?? previous.id.shortName
					}
					return previous.id.shortName
				}()
				
				return "\(previousNameBase) \(self.block.id.displayName)"
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
			
			if let blockMeta = BlockMetaManager.instance.getBlockMeta(id: self.block.id) {
				return blockMeta.color
			}
			
			return Scheme.nullColor.color
		}
		
		return courses.courses.first!.color
	}
}
