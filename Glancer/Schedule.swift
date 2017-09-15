//
//  ClassMetaManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/13/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation

class ScheduleManager
{
	static let instance: ScheduleManager = ScheduleManager()
	
	class CallKeys // This is a support class just for like utils and stuff idk
	{
		static let PUSH = "push"
		
		static let START_TIME = "ST"
		static let END_TIME = "ET"
		static let BLOCK = "B"
		
		static let SCHOOL_END = "School" + END_TIME
		static let SECONDLUNCH_START = "SecondLunch" + START_TIME
	}
	
	static let CURRENT_SCHOOL_YEAR = "2017-2018" // THIS MUST BE CHANGED EVERY YEAR. I THINK. IT MIGHT WORK IF YOU DON'T BUT LIKE DON'T TAKE CHANCES BRUH
	private(set) var onVacation = false

	private(set) var weekSchedule: [DayID: Weekday] = [:]
	private var updateHandlers: [ScheduleUpdateHandler] = []
	
	init()
	{
		//TODO I'm sure there's something htat needs to be initialized and I haven't done it yet
	}
	
	func addHandler(_ handler: ScheduleUpdateHandler)
	{
		updateHandlers.append(handler)
	}
	
	func scheduleLoaded() -> Bool
	{
		return self.weekSchedule.count > 0
	}
	
	@discardableResult
	func loadBlocks() -> Bool
	{
		var success = true
		
		let call = WebCall(app: "scheduleObject/OG")
		let response = call.runSync()
		
		if response.token.connected
		{
			let data = response.result!
			
			if data[CallKeys.PUSH] != nil
			{
				self.onVacation = !(data[CallKeys.PUSH] as! Bool)
				
				print(data) // Debugging
				
				var newSchedule: [DayID: Weekday] = [:]
				
				var endTimes: [String]! = data[CallKeys.SCHOOL_END] != nil ? data[CallKeys.SCHOOL_END] as! [String] : []
				var secondLunchStarts: [String]! = data[CallKeys.SECONDLUNCH_START] != nil ? data[CallKeys.SECONDLUNCH_START] as! [String] : []
				
				var i = -1
				for dayId in DayID.weekdays() // Only retrieve schedules for weekdays
				{
					i+=1
					
					let endTime: String? = endTimes.count > i ? endTimes[i] : nil // Required
					let secondLunch: String? = secondLunchStarts.count > i ? secondLunchStarts[i] : nil // Not required.
					
					var blocks: [String]? = data[dayId.rawValue + CallKeys.BLOCK] != nil ? data[dayId.rawValue + CallKeys.BLOCK] as? [String] : nil
					var startTimes: [String]? = data[dayId.rawValue + CallKeys.START_TIME] != nil ? data[dayId.rawValue + CallKeys.START_TIME] as? [String] : nil
					var endTimes: [String]? = data[dayId.rawValue + CallKeys.END_TIME] != nil ? data[dayId.rawValue + CallKeys.END_TIME] as? [String] : []
					
					if endTime != nil && blocks != nil && blocks != nil && startTimes != nil && endTimes != nil
					{
						if blocks!.count != startTimes!.count || startTimes!.count != endTimes!.count || endTimes!.count != blocks!.count
						{
							print("Loaded an inconsistent amount of StartTimes, EndTimes, and Blocks")
							continue
						}
						
						var blockLibrary: [BlockID: Block] = [:]
						for y in 0..<blocks!.count
						{
							var block = Block()
							
							let blockId = BlockID.fromRaw(raw: String(blocks![y].characters.first!)) // Get block value even if it's a lunch block
							if blockId == nil
							{
								print("A false block ID was passed. Error")
								continue
							}
							
//							-----------------------------------------------
//							Below: a very hacky chunk of code that sets a block as a lunch block if the recieved block contains a 1 or 2 at the end.
							let lunchId = blocks![y].characters.last
							block.lunchBlockNumber = Int(String(describing: lunchId))
							if block.lunchBlockNumber != 1 && block.lunchBlockNumber != 2 { block.lunchBlockNumber = nil } // If it isn't a 1 or a 2 then it isn't valid.
//							-----------------------------------------------
							
							block.blockId = blockId!
							block.endTime = TimeContainer(endTimes![y])
							block.startTime = TimeContainer(startTimes![y])
							
							blockLibrary[block.blockId] = block
						}
						
						var weekday: Weekday = Weekday()
						weekday.dayId = dayId
						weekday.secondLunchStart = secondLunch == nil ? nil : TimeContainer(secondLunch!)
						weekday.blocks = blockLibrary
						
						newSchedule[weekday.dayId] = weekday
					} else
					{
						success = false
						
						print("One of the loaded values for the schedule was null.")
						print("EndTime: \(String(describing: endTime)) Blocks: \(String(describing: blocks)) StartTimes: \(String(describing: startTimes)) EndTimes: \(String(describing: endTimes))")
					}
				}
				
				self.weekSchedule.removeAll()
				self.weekSchedule = newSchedule

//				TODO: Update user preferences.
//				self.setUserValues()
			} else
			{
				success = false
				print("WebCall failed: Check internet connection")
			}
		} else
		{
			success = false
			print("WebCall failed: \(response.token.error!)")
		}
		
		for handler in self.updateHandlers
		{
			handler.scheduleDidUpdate(didUpdateSuccessfully: success, newSchedule: &self.weekSchedule)
		}
		
		return success
	}
}

enum DayID: String // DO NOT EVER CHANGE ANYTHING IN THIS CLASS I SWEAR TO GOD IT'LL KILL YOU AND YOUR FAMILY AND YOU DON'T WANT THAT
{
	case
	monday = "M",
	tuesday = "T",
	wednesday = "W",
	thursday = "Th",
	friday = "F",
	saturday = "Sat",
	sunday = "Sun"
	
	var displayName: String
	{
		switch self
		{
		case .monday:
			return "Monday"
		case .tuesday:
			return "Tuesday"
		case .wednesday:
			return "Wednesday"
		case .thursday:
			return "Thursday"
		case .friday:
			return "Friday"
		case .saturday:
			return "Saturday"
		case .sunday:
			return "Sunday"
		}
	}
	
	var id: Int
	{
		return DayID.values().index(of: self)!
	}
	
	static func weekdays() -> [DayID] { return [.monday, .tuesday, .wednesday, .thursday, .friday] }
	static func weekends() -> [DayID] { return [.saturday, .sunday] }
	static func values() -> [DayID] { return [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday] }
	
	static func fromRaw(raw: String) -> DayID?
	{
		for day in DayID.values()
		{
			if day.rawValue == raw
			{
				return day
			}
		}
		return nil
	}
	
	static func fromId(_ id: Int) -> DayID?
	{
		for day in DayID.values()
		{
			if day.id == id
			{
				return day
			}
		}
		return nil
	}
}

enum BlockID: String // Don't touch this either for good measure unless like we add more blocks or something
{
	case
	a = "A",
	b = "B",
	c = "C",
	d = "D",
	e = "E",
	f = "F",
	g = "G",
	x = "X"
	
	var id: Int
	{
		return BlockID.values().index(of: self)!
	}
	
	static func fromRaw(raw: String) -> BlockID?
	{
		for block in BlockID.values()
		{
			if block.rawValue == raw
			{
				return block
			}
		}
		return nil
	}
	
	static func fromId(_ id: Int) -> BlockID?
	{
		for block in BlockID.values()
		{
			if block.id == id
			{
				return block
			}
		}
		return nil
	}
	
	static func values() -> [BlockID] { return [.a, .b, .c, .d, .e, .f, .g, .x] }
	static func academicBlocks() -> [BlockID] { return [.a, .b, .c, .d, .e, .f, .g] }
}

struct Weekday
{
	var dayId: DayID! // M, T, W, Th, F
	var blocks: [BlockID: Block]! // Class ID to Block
	var secondLunchStart: TimeContainer? // I hate having this here but I can't really think of a better way to do it rn
}

struct Block
{
	var blockId: BlockID! // E.G. A, B, C, D, E
	
	var overrideDisplayName: String? // Only used for overriding the default meta's name
	var hasOverridenDisplayName: Bool { get { return self.overrideDisplayName != nil } }
	
	var startTime: TimeContainer!
	var overrideStartTime: TimeContainer? // used in extreme circumstances idk
	var endTime: TimeContainer!
	
	var lunchBlockNumber: Int? // 1 or 2 for first or second lunch
	var isLunchBlock: Bool { get { return self.lunchBlockNumber != nil } }
}

struct TimeContainer
{
	var timeString: String!
	
	init(_ timeString: String) { self.timeString = timeString }
	
	func asDate() -> Date
	{
		return TimeUtils.timeToNSDate(self.timeString)
	}
}

protocol ScheduleUpdateHandler
{
	func scheduleDidUpdate(didUpdateSuccessfully: Bool, newSchedule: inout [DayID: Weekday])
}
