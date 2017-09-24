//
//  ClassMetaManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/13/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation

class ScheduleManager: PrefsUpdateHandler
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

	private var weekSchedule: [DayID: Weekday] = [:]
	private var updateHandlers: [ScheduleUpdateHandler] = []
	var scheduleLoaded = false
	
	func dayLoaded(id: DayID) -> Bool
	{
		return self.weekSchedule[id] != nil
	}
	
	func blockList(id: DayID) -> [Block]?
	{
		if let day = self.weekSchedule[id]
		{
			return day.blocks
		}
		return nil
	}
	
	init()
	{
		UserPrefsManager.instance.addHandler(self)
	}
	
	func addHandler(_ handler: ScheduleUpdateHandler)
	{
		updateHandlers.append(handler)
	}
	
	func updateHandlers(_ success: Bool)
	{
		for handler in self.updateHandlers
		{
			handler.scheduleDidUpdate(didUpdateSuccessfully: success)
		}
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
				
				var newSchedule: [DayID: Weekday] = [:]
				
//				var endTimes: [String]! = data[CallKeys.SCHOOL_END] != nil ? data[CallKeys.SCHOOL_END] as! [String] : []
				var secondLunchStarts: [String]! = data[CallKeys.SECONDLUNCH_START] != nil ? data[CallKeys.SECONDLUNCH_START] as! [String] : []
				
//				Debug.out("About to go through days")
				
				var i = -1
				for dayId in DayID.weekdays() // Only retrieve schedules for weekdays
				{
					i+=1
					
//					Debug.out("In DayID: \(dayId)")
					
//					let endTime: String? = endTimes.count > i ? endTimes[i] : nil // Required
					let secondLunch: String? = secondLunchStarts.count > i ? secondLunchStarts[i] : nil // Not required.
					
					var blocks: [String]? = data[dayId.rawValue + CallKeys.BLOCK] != nil ? data[dayId.rawValue + CallKeys.BLOCK] as? [String] : nil
					var startTimes: [String]? = data[dayId.rawValue + CallKeys.START_TIME] != nil ? data[dayId.rawValue + CallKeys.START_TIME] as? [String] : nil
					var endTimes: [String]? = data[dayId.rawValue + CallKeys.END_TIME] != nil ? data[dayId.rawValue + CallKeys.END_TIME] as? [String] : []
					
					if /*endTime != nil &&*/ blocks != nil && blocks != nil && startTimes != nil && endTimes != nil
					{
						if blocks!.count != startTimes!.count || startTimes!.count != endTimes!.count || endTimes!.count != blocks!.count
						{
							print("Loaded an inconsistent amount of StartTimes, EndTimes, and Blocks")
							continue
						}
						
//						Debug.out("Got the right number of everything.")
						
						var blockLibrary: [Block] = []
						for y in 0..<blocks!.count
						{
							var block = Block()
							
							let rawId = blocks![y]
							
//							Debug.out("rawId A: \(rawId)")
							
							let trimmedRawId = Utils.substring(rawId, StartIndex: 0, EndIndex: rawId.characters.count - (rawId.characters.count == 2 ? 1 : 0))
							
//							Debug.out("trimmedRawId B: \(trimmedRawId)")
							
							var blockId = BlockID.fromRaw(raw: trimmedRawId) // Get block value even if it's a lunch block
							if blockId == nil
							{
								blockId = BlockID.custom
								block.overrideDisplayName = rawId
							}
							
//							-----------------------------------------------
//							Below: a very hacky chunk of code that sets a block as a lunch block if the recieved block contains a 1 or 2 at the end.
							let lunchId = rawId.last
							if lunchId != nil
							{
								if let lunchBlockNumber = Int(String(describing: lunchId!))
								{
									block.lunchBlockNumber = lunchBlockNumber
									if block.lunchBlockNumber != 1 && block.lunchBlockNumber != 2 { block.lunchBlockNumber = nil } // If it isn't a 1 or a 2 then it isn't valid.
								}
							}
//							-----------------------------------------------
							
							block.blockId = blockId!
							block.weekday = dayId
							block.endTime = TimeContainer(endTimes![y])
							block.startTime = TimeContainer(startTimes![y])
							
//							Debug.out("Block: \(block)")
							
							blockLibrary.append(block)
						}
						
						// Set last block
						if blockLibrary.last != nil
						{
							blockLibrary[blockLibrary.endIndex - 1].isLastBlock = true
						}
						
						if blockLibrary.first != nil
						{
							blockLibrary[blockLibrary.startIndex].isFirstBlock = true
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
						print("Blocks: \(String(describing: blocks)) StartTimes: \(String(describing: startTimes)) EndTimes: \(String(describing: endTimes))")
					}
				}
				
				Debug.out("Done with loading schedule")
				
				self.weekSchedule.removeAll()
				self.weekSchedule = newSchedule
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
		
		self.updateLunch(false)
		self.updateHandlers(success)
		
		if success
		{
			self.scheduleLoaded = true
		}
		
		return success
	}
	
	func prefsDidUpdate(_ type: UserPrefsManager.PrefsUpdateType)
	{
		if type == .load || type == .lunch
		{
			self.updateLunch(true)
		}
	}
	
	func updateLunch(_ updateHandlers: Bool?)
	{
		for dayId in self.weekSchedule.keys
		{
			let day = self.weekSchedule[dayId]!
			
			if let flip = UserPrefsManager.instance.getSwitch(id: dayId)
			{
				var blockList = self.blockList(id: dayId)!
				for i in 0..<blockList.count // Use this iterator so we can modify block
				{
					var block = blockList[i]
					
					if !block.hasLunchBlockNumber { continue }
					
					// Reset custom flags
					block.overrideEndTime = nil
					block.overrideStartTime = nil
					block.overrideDisplayName = nil
					block.isLunchBlock = false
					
					if flip // User has first lunch
					{
						if block.lunchBlockNumber! == 1 // First lunch block - B1
						{
							// Lunch
							block.overrideDisplayName = "Lunch"
							block.isLunchBlock = true
						}
					} else // User has second lunch
					{
						if block.lunchBlockNumber! == 1 // First lunch block - B1
						{
							// Class
							block.overrideEndTime = day.secondLunchStart ?? nil // SEt its end time to the start of lunch
						} else // Second lunch block - B2
						{
							block.overrideDisplayName = "Lunch"
							block.overrideStartTime = day.secondLunchStart ?? nil // Set its start time to the start of lunch
							block.isLunchBlock = true
						}
					}
					
					self.weekSchedule[dayId]!.blocks[i] = block
				}
			}
		}
		
		if updateHandlers != nil && updateHandlers!
		{
			self.updateHandlers(true)
		}
	}
	
	func currentDayOfWeek() -> DayID
	{
		let today = TimeUtils.getDayOfWeekFromString(TimeUtils.currentDateAsString()) // 0 to 6 for Monday - Sunday
		return DayID.fromId(today)!
	}
	
	func getCurrentBlock() -> Block?
	{
		let currentDate = Date()
		if let blocks = self.blockList(id: self.currentDayOfWeek())
		{
			for block in blocks
			{
				let analyst = block.analyst
				
				let start = analyst.getStartTime().asDate()
				let end = analyst.getEndTime().asDate()
				
				if currentDate >= start && currentDate < end
				{
					return block
				}
			}
		}
		
		return nil
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
	x = "X",
	activities = "Activities",
	lab = "Lab",
	custom = "Custom"
	
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
	
	static func values() -> [BlockID] { return [.a, .b, .c, .d, .e, .f, .g, .x, .custom, .activities, .lab] }
	static func regularBlocks() -> [BlockID] { return [.a, .b, .c, .d, .e, .f, .g, .x] }
	static func academicBlocks() -> [BlockID] { return [.a, .b, .c, .d, .e, .f, .g] }
}

struct Weekday
{
	var dayId: DayID! // M, T, W, Th, F
	var blocks: [Block]! // Class ID to Block MAJOR ISSUE THIS WON'T PRESERVE ORDER.
	var secondLunchStart: TimeContainer? // I hate having this here but I can't really think of a better way to do it rn
}

struct Block
{
	var analyst: BlockAnalyst // A middle man that interprets all the data in Block and makes it easier to get what you want it's pretty cool really
	{
		get
		{
			return BlockAnalyst(self)
		}
	}
	
	var blockId: BlockID! // E.G. A, B, C, D, E
	var weekday: DayID!
	
	var overrideDisplayName: String? // Only used for overriding the default meta's name
	
	var startTime: TimeContainer!
	var overrideStartTime: TimeContainer?

	var endTime: TimeContainer!
	var overrideEndTime: TimeContainer?
	
	var lunchBlockNumber: Int? // 1 or 2 for first or second lunch
	var isLunchBlock: Bool = false
	
	var isFirstBlock: Bool = false
	var isLastBlock: Bool = false
}

extension Block
{
	var hasOverridenDisplayName: Bool { get { return self.overrideDisplayName != nil } }
	var hasOverridenStartTime: Bool { get { return self.overrideStartTime != nil } }
	var hasOverridenEndTime: Bool { get { return self.overrideEndTime != nil } }
	var hasLunchBlockNumber: Bool { get { return self.lunchBlockNumber != nil } }
	
	public static func ==(lhs: Block, rhs: Block) -> Bool
	{
//		Debug.out("Equal?????")
		return
			lhs.blockId == rhs.blockId &&
			lhs.weekday == rhs.weekday &&
			lhs.startTime == rhs.startTime &&
			lhs.endTime == rhs.endTime &&
			lhs.isFirstBlock == rhs.isFirstBlock &&
			lhs.isLastBlock == rhs.isLastBlock &&
			(lhs.hasOverridenDisplayName ? lhs.overrideDisplayName! == rhs.overrideDisplayName! : true) &&
			(lhs.hasOverridenStartTime ? lhs.overrideStartTime! == rhs.overrideStartTime! : true) &&
			(lhs.hasOverridenEndTime ? lhs.overrideEndTime! == rhs.overrideEndTime! : true) // Checks if all values are equal
	}
}

class BlockAnalyst
{
	fileprivate var block: Block!
	
	var meta: UserPrefsManager.BlockMeta?
	{
		get
		{
			if let meta = UserPrefsManager.instance.getMeta(id: self.block.blockId)
			{
				return meta
			}
			return nil
		}
	}
	
	fileprivate init(_ block: Block)
	{
		self.block = block
	}
	
	func getStartTime() -> TimeContainer
	{
		return self.block.overrideStartTime ?? self.block.startTime
	}
	
	func getEndTime() -> TimeContainer
	{
		return self.block.overrideEndTime ?? self.block.endTime
	}
	
	func getDisplayLetter() -> String
	{
		if block.blockId == .lab
		{
			if let previous = block.analyst.getPreviousBlock() // If it's a lab return the previous block letter + L
			{
				return Utils.substring(previous.analyst.getDisplayLetter(), StartIndex: 0, EndIndex: 1) + "L" // Return the first two letters. This should only return the first letter if it's a 1 letter string.
			}
		}
		
		if block.hasOverridenDisplayName
		{
			let displayName = block.overrideDisplayName!
			if displayName.contains(" ") // 2+ words then make the block letter the first letter of each
			{
				let split = displayName.split(separator: " ")
				var built = ""
				var count = 0
				
				let acceptableCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".characters
				for word in split
				{
					if count >= 2 { break }
					if word.first != nil && acceptableCharacters.contains(word.first!)
					{
						built += String(describing: word.first!)
					}
					count+=1
				}
				
				if built.count >= 2
				{
					return built
				}
			}
			
			return Utils.substring(displayName, StartIndex: 0, EndIndex: 2)
		}
		
		let id = self.block.blockId.rawValue // Return the first two letters. This should only return the first letter if it's a 1 letter string.
		if self.block.hasLunchBlockNumber
		{
			return "\(id)\(self.block.lunchBlockNumber!)"
		}
		return id
	}
	
	func getDisplayName(_ appendBlock: Bool = true) -> String // E.G. X Block
	{
		if self.block.blockId == .lab
		{
			let previous = getPreviousBlock()
			if previous != nil
			{
				return "\(previous!.analyst.getDisplayName(false)) Lab" // Return a new block analyst to get the display name if this is a lab block
			}
		}
		
		if block.hasOverridenDisplayName
		{
			return block.overrideDisplayName!
		}
		
		if let meta = self.meta
		{
			if let name = meta.customName
			{
				return name
			}
		}
		
		if self.block.blockId == .activities || self.block.blockId == .custom
		{
			return block.blockId.rawValue
		}
		
		return block.blockId.rawValue + (appendBlock ? " Block" : "")
	}
	
	func getColor() -> String
	{
		if self.block.blockId == .lab
		{
			let previous = getPreviousBlock()
			if previous != nil
			{
				return previous!.analyst.getColor() // Return a new block analyst to get the color if this is a lab block
			}
		}
		
		if let meta = self.meta
		{
			return meta.customColor
		}
		return "999999"
	}
	
	func isLastBlock() -> Bool
	{
		return self.block.isLastBlock
	}
	
	func isFirstBlock() -> Bool
	{
		return self.block.isFirstBlock
	}
	
	func getNextBlock() -> Block?
	{
		if isLastBlock() { return nil }
		
		if let blocks = ScheduleManager.instance.blockList(id: self.block.weekday)
		{
			var found = false // If the block has been found return the next one in series
			for block in blocks
			{
				if found { return block }
				if block == self.block { found = true } // Identify the current iterator block as this one.
			}
			return nil
		} else
		{
			return nil
		}
	}
	
	func getPreviousBlock() -> Block?
	{
//		Debug.out("Checking previous block")
		if isFirstBlock() { return nil }
		
//		Debug.out("Not previous block")
		
		if let blocks = ScheduleManager.instance.blockList(id: self.block.weekday)
		{
//			Debug.out("Block list")

			var found = false // If the block has been found return the next one in series
			for block in blocks.reversed()
			{
				if found { return block  }
				if block == self.block { found = true } // Identify the current iterator block as this one.
			}
			return nil
		} else
		{
			return nil
		}
	}
}

struct TimeContainer
{
	var timeString: String!
	
	init(_ timeString: String) { self.timeString = timeString }
}

extension TimeContainer
{
	func asDate() -> Date
	{
		return TimeUtils.timeToNSDate(self.timeString)
	}
	
	func toFormattedString() -> String
	{
		var hourInt = Int(Utils.substring(timeString, StartIndex: 1, EndIndex: 3))!
		hourInt = hourInt % 12 == 0 ? hourInt : hourInt % 12 // If the hour is 12 let it be, otherwise change to the remainder E.G. 1:30
		let hour = String(hourInt)
		
		let minute = Utils.substring(timeString, StartIndex: 4, EndIndex: 6)
		
		return "\(hour):\(minute)"
	}
	
	public static func ==(lhs: TimeContainer, rhs: TimeContainer) -> Bool
	{
		return lhs.timeString == rhs.timeString
	}
}

protocol ScheduleUpdateHandler
{
	func scheduleDidUpdate(didUpdateSuccessfully: Bool)
}
