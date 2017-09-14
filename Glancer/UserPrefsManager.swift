//
//  UserPrefs.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/13/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation

class UserPrefsManager
{
	static let instance = UserPrefsManager()

	struct BlockMeta
	{
		init(_ blockId: ScheduleManager.BlockId, _ customColor: String) { self.blockId = blockId; self.customName = blockId.rawValue; self.customColor = customColor }
		var blockId: ScheduleManager.BlockId! // E.G. A, B, C, D, E (Corresponds to Class ID)
		var customName: String!
		var customColor: String!
	}
	
	var blockMeta: [ScheduleManager.BlockId: BlockMeta] =
	[
		.a: BlockMeta(.a, "E74C3C"),
		.b: BlockMeta(.b, "E67E22"),
		.c: BlockMeta(.c, "F1C40F"),
		.d: BlockMeta(.d, "2ECC71"),
		.e: BlockMeta(.e, "3498DB"),
		.f: BlockMeta(.f, "9B59B6"),
		.g: BlockMeta(.g, "DE59B6"),
		.x: BlockMeta(.x, "999999")
	]
	
	var lunchSwitches: [ScheduleManager.DayId: Bool] = [:] // Day Id: On/Off
	
	init()
	{
		
	}
	
	func reloadPrefs()
	{
		let currentDateTime = TimeUtils.currentDateAsString()
		let dayNum = TimeUtils.getDayOfWeekFromString(currentDateTime)
		
		var dayMultiplier : Double = 0;
		dayMultiplier = -Double(dayNum);
		
		/*
		M  T  W  TH  F  SA  SU
		0  1  2  3   4  5   6
		*/
		
		// get/set values for class names
		if Storage.storageMethodUpdated // Account for old storage method to keep legacy data
		{
			
		} else
		{
			
		}
		
		var classNames = [String]()
		if (defaults.object(forKey: "ButtonTexts") != nil) {
			classNames = defaults.object(forKey: "ButtonTexts") as! Array<String>
		} else {
			var count = 0
			while count < 7 {
				classNames.append("")
				count += 1
			}
			defaults.set(classNames, forKey: "ButtonTexts")
		}
		
		// get/set values for lunch boolean settings
		var firstLunches = [Bool]()
		if (defaults.object(forKey: "SwitchValues") != nil) {
			firstLunches = defaults.object(forKey: "SwitchValues") as! Array<Bool>
		} else {
			var count = 0
			while count < 5 {
				firstLunches.append(true)
				count += 1
			}
			defaults.set(firstLunches, forKey: "SwitchValues")
		}
		
		// get/set values for class color selection
		var classColors = [String]()
		if (defaults.object(forKey: "ColorIDs") != nil)
		{
			classColors = defaults.object(forKey: "ColorIDs") as! Array<String>
		} else
		{
			//			Default color values
			classColors.append("E74C3C-A")
			classColors.append("E67E22-B")
			classColors.append("F1C40F-C")
			classColors.append("2ECC71-D")
			classColors.append("3498DB-E")
			classColors.append("9B59B6-F")
			classColors.append("DE59B6-G")
			classColors.append("999999-X")
			
			defaults.set(classColors, forKey: "ColorIDs")
		}
		
		// get/set values for class notes
		var classNotes = [String]()
		if (defaults.object(forKey: "NoteTexts") != nil) {
			classNotes = defaults.object(forKey: "NoteTexts") as! Array<String>
		} else {
			var count = 0
			while count < 8 {
				classNotes.append("")
				count += 1
			}
			defaults.set(classNotes, forKey: "NoteTexts")
		}
		
		var dayCounter = 0;
		for day in self.Days {
			
			print("DAY")
			
			print(dayCounter)
			
			let firstLunch = firstLunches[dayCounter]
			
			for (date, block) in day.timeToBlock {
				
				// stored as mutable b/c of 2nd lunch
				var mutable_date = date;
				
				// block
				var block_copy = block;
				// name of block
				var message = block;
				
				if (block_copy.characters.count == 2) { // E.G. B1 or B2 (Is a lunch block)
					
					if (firstLunch && block_copy.hasSuffix("1")) {
						// first lunch
						message = "Lunch"
					} else if (!firstLunch && block_copy.hasSuffix("2")) {
						// second lunch
						message = "Lunch"
						
						// fire at a different date than the one parse orginally stores
						let time_of_secondLunch = self.Second_Lunch_Start[dayCounter];
						mutable_date = Days[0].timeToNSDate(time_of_secondLunch);
					} else {
						// regular block
						
						// get block letter
						var counterDigit = 0;
						for i in block_copy.characters{
							if (counterDigit == 0) {
								block_copy = String(i)
							}
							counterDigit += 1;
						}
					}
				}
				
				if (self.BlockOrder.index(of: block_copy) != nil) {
					// set block name to user value
					let indexOfUserInfo = self.BlockOrder.index(of: block_copy)!
					
					if (classNames[indexOfUserInfo] != "")
					{
						message = classNames[indexOfUserInfo]
					}
				}
				
				// set up notifications
				if (message == "Lunch") {
					var RegularDate = mutable_date;
					let localNotification:UILocalNotification = UILocalNotification()
					localNotification.alertAction = "Knight Life"
					localNotification.alertBody = message;
					
					day.messagesForBlock[block] = message;
					
					RegularDate = RegularDate.addingTimeInterval(60 * 60 * 24 * dayMultiplier);
					
					print("REGULAR");
					print(RegularDate as Date);
					
					
					if(!self.Vacation){ //only set notifications if it's not vacation
						
						let DateScheduled = day.NSDateToString(RegularDate)
						localNotification.fireDate = RegularDate as Date
						localNotification.soundName = UILocalNotificationDefaultSoundName;
						localNotification.repeatInterval = NSCalendar.Unit.weekOfYear
						UIApplication.shared.scheduleLocalNotification(localNotification)
						
					}
					
					
					
					
				} else {
					var Earlydate = mutable_date.addingTimeInterval(-60*5)
					
					let localNotification:UILocalNotification = UILocalNotification()
					localNotification.alertAction = "Knight Life"
					localNotification.alertBody = "5 minutes until " + message;
					
					day.messagesForBlock[block] = message;
					
					Earlydate = Earlydate.addingTimeInterval(60 * 60 * 24 * dayMultiplier)
					
					print("EARLY");
					print(Earlydate as Date);
					
					if(!self.Vacation){ //only set notifications if it's not vacation
						
						let DateScheduled = day.NSDateToString(Earlydate)
						localNotification.fireDate = Earlydate as Date
						localNotification.repeatInterval = NSCalendar.Unit.weekOfYear
						localNotification.soundName = UILocalNotificationDefaultSoundName;
						UIApplication.shared.scheduleLocalNotification(localNotification)
						
					}
				}
			}
			dayCounter += 1;
			dayMultiplier += 1;
		}
	}
}
