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
	
	func getCourse() -> Course? {
		return self.getCourses().first
	}
	
	func getCourses() -> [Course] {
		return CourseM.getCourses(schedule: self.schedule, block: block.id)
	}
	
	func getLabAssociatedBlock() -> Block? {
		guard self.block.id == .lab, let previous = self.schedule.getBlockBefore(self.block) else {
			return nil
		}
		
		return previous
	}
	
	func getDisplayName() -> String {
		if self.block.id == .custom {
			if let custom = self.block.custom {
				return custom.name
			} else {
				return block.id.displayName
			}
		}
		
		if let course = self.getCourse() {
			return course.name
		} else {
			guard let previous = self.getLabAssociatedBlock() else {
				if let blockMeta = BlockMetaM.getBlockMeta(block: self.block.id), blockMeta.id == .free {
					return blockMeta.customName ?? self.block.id.displayName
				}
				
				return self.block.id.displayName
			}
			
//			Logic for if the block is a Lab.
			let previousAnalyst = BlockAnalyst(schedule: self.schedule, block: previous)
			if previousAnalyst.getCourses().isEmpty {
				let previousNameBase: String = {
					if let previousMeta = BlockMetaM.getBlockMeta(block: previous.id), previousMeta.id == .free {
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
		
		if let course = self.getCourse() {
			return course.color
		}
		
		if let previous = self.getLabAssociatedBlock() {
			let previousAnalyst = BlockAnalyst(schedule: self.schedule, block: previous)
			return previousAnalyst.getColor()
		}
		
		if let blockMeta = BlockMetaM.getBlockMeta(block: self.block.id) {
			return blockMeta.color
		}
		
		return Scheme.nullColor.color
	}
	
	func getLocation() -> String? {
		if self.block.id == .custom, let custom = self.block.custom {
			return custom.location
		}
		
		if let course = self.getCourse() {
			return course.location
		}
		
		return nil
	}
	
	func shouldShowBeforeClassNotifications() -> Bool {
		if let course = self.getCourse() {
			return course.beforeClassNotifications
		}
		
		if let blockMeta = BlockMetaM.getBlockMeta(block: self.block.id) {
			return blockMeta.beforeClassNotifications
		}
		
		if let labPrevious = self.getLabAssociatedBlock() {
			let previousAnalyst = BlockAnalyst(schedule: self.schedule, block: labPrevious)
			return previousAnalyst.shouldShowBeforeClassNotifications()
		}
		
		return true
	}
	
	func shouldShowAfterClassNotifications() -> Bool {
		if let course = self.getCourse() {
			return course.afterClassNotifications
		}
		
		if let blockMeta = BlockMetaM.getBlockMeta(block: self.block.id) {
			return blockMeta.afterClassNotifications
		}
		
		if let labPrevious = self.getLabAssociatedBlock() {
			let previousAnalyst = BlockAnalyst(schedule: self.schedule, block: labPrevious)
			return previousAnalyst.shouldShowAfterClassNotifications()
		}
		
		return false
	}
	
}
