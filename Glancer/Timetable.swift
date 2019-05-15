//
//  Timetable.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import UserNotifications
import Timepiece

struct Timetable: Decodable {
	
	let badge: String
	let grades: [Grade]
	
	let title: String?
	private(set) var blocks: [Block]!
	
	private(set) var schedule: Schedule!
	
	init(json: JSON) throws {
		
		self.badge = try Optionals.unwrap(json["badge"].string)
		self.grades = try Optionals.unwrap(json["grades"].arrayObject).compactMap({
			return Grade(rawValue: ($0 as? Int) ?? -1)
		})
		
		self.title = try Optionals.unwrap(json["title"].string)
		
		self.blocks = try Optionals.unwrap(json["blocks"].array).map({
			var block = try Block(json: $0)
			block.setTimetable(timetable: self)
			
			return block
		})
		
	}
	
	mutating func setSchedule(schedule: Schedule) {
		self.schedule = schedule
	}
	
	// Empty grades array means the schedule is global
	var gradeSpecific: Bool {
		return !self.grades.isEmpty
	}
	
	func select() {
		self.schedule.selectedTimetable = self
	}
	
	func deselect() {
		if self.schedule.selectedTimetable == self {
			self.schedule.selectedTimetable = nil
		}
	}
	
}

extension Timetable {
	
	var firstBlock: Block? {
		return self.filterBlocksByLunch(firstLunch: nil).first
	}
	
	var lastBlock: Block? {
		return self.filterBlocksByLunch(firstLunch: nil).last
	}
	
	func filterBlocksByLunch(firstLunch: Bool? = nil) -> [Block] {
		let firstLunch = firstLunch ?? self.schedule.hasFirstLunch
		
		// Filter the blocks which have the same firstLunch value.
		return self.blocks.filter({
			// No setting for firstLunch means it's in all variations of the schedule.
			guard let first = $0.firstLunch else {
				return true
			}
			
			return first == firstLunch
		})
	}
	
	func hasBlock(block: Block, firstLunch: Bool? = nil) -> Bool {
		let blocks = self.filterBlocksByLunch(firstLunch: firstLunch)
		return blocks.contains(block)
	}
	
	func getBlockOffsetFrom(block: Block, by: Int, firstLunch: Bool? = nil) -> Block? {
		let blocks = self.filterBlocksByLunch(firstLunch: firstLunch)
		
		if let index = blocks.firstIndex(of: block) {
			let offsetIndex = index + by
			
			if blocks.indices.contains(offsetIndex) {
				return blocks[offsetIndex]
			}
		}
		
		return nil
	}
	
	func getBlockBefore(block: Block, firstLunch: Bool? = nil) -> Block? {
		return self.getBlockOffsetFrom(block: block, by: -1, firstLunch: firstLunch)
	}
	
	func getBlockAfter(block: Block, firstLunch: Bool? = nil) -> Block? {
		return self.getBlockOffsetFrom(block: block, by: 1, firstLunch: firstLunch)
	}
	
	func getBlocksBefore(block: Block, firstLunch: Bool? = nil) -> [Block] {
		if !self.hasBlock(block: block, firstLunch: firstLunch) {
			return []
		}
		
		let blocks = self.filterBlocksByLunch(firstLunch: firstLunch)
		return Array(blocks[0 ..< blocks.firstIndex(of: block)!])
	}
	
	func getBlocksAfter(block: Block, firstLunch: Bool? = nil) -> [Block] {
		if !self.hasBlock(block: block, firstLunch: firstLunch) {
			return []
		}
		
		let blocks = self.filterBlocksByLunch(firstLunch: firstLunch)
		return Array(blocks[blocks.firstIndex(of: block)! + 1 ..< blocks.count])
	}
	
}

extension Timetable: Equatable {
	
	static func == (lhs: Timetable, rhs: Timetable) -> Bool {
		return lhs.badge == rhs.badge
	}
	
}

