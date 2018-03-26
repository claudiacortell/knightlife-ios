//
//  BlockAnalyst.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/6/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

class BlockAnalyst
{
	let block: ScheduleBlock
	let schedule: DateSchedule
	
	init(_ block: ScheduleBlock, schedule: DateSchedule)
	{
		self.block = block
		self.schedule = schedule
	}
	
	func getCourses() -> BlockCourseList
	{
		return CourseManager.instance.getCourses(schedule: self.schedule, block: block.blockId)
	}
	
	func getDisplayName() -> String
	{
		if self.block.blockId == .custom
		{
			return self.block.customName ?? self.block.blockId.displayName
		}
		
		let courses = self.getCourses()
		if courses.isEmpty
		{
			if self.block.blockId == .lab, let previous = self.schedule.getBlockBefore(self.block) // If it's a lab and there's a previous block
			{
				let previousAnalyst = BlockAnalyst(previous, schedule: self.schedule)
				if previousAnalyst.getCourses().isEmpty
				{
					return "\(previousAnalyst.block.blockId.displayLetter) \(self.block.blockId.displayName)" // E.G. X Lab
				} else
				{
					return "\(previousAnalyst.getDisplayName()) \(self.block.blockId.displayName)" // E.G. Chemistry Lab
				}
			}
			
			return self.block.blockId.displayName
		} else
		{
			return courses.courses.first!.name // Get name of first available course
		}
	}
	
	func getDisplayLetter() -> String
	{
		if self.block.blockId == .custom
		{
			return "!!"
		}
		
		if self.block.blockId == .lab, let previous = self.schedule.getBlockBefore(self.block) // If it's a lab and there's a previous block
		{
			return "\(previous.blockId.displayLetter.first!)L" // E.G. AL
		} else if let variation = self.block.variation, self.block.blockId != .lunch
		{
			return "\(block.blockId.displayLetter.first!)\(variation + 1)" // E.G. A1
		} else
		{
			return self.block.blockId.displayLetter
		}
	}
	
	func getColor() -> String
	{
		if self.block.blockId == .custom, let color = self.block.color
		{
			return color
		}
		
		let courses = self.getCourses()
		if courses.isEmpty
		{
			if self.block.blockId == .lab, let previous = self.schedule.getBlockBefore(self.block)
			{
				let analyst = BlockAnalyst(previous, schedule: self.schedule)
				if !analyst.getCourses().isEmpty
				{
					return analyst.getColor()
				}
			}
			
//			return self.getColor
//			TODO: IMPLEMENT BLOCK COLORS

			return "999999"
		}
		
		return courses.courses.first!.color ?? "999999"
	}
}
