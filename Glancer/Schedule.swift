//
//  ClassMetaManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/13/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation
import AddictiveLib

class ScheduleMan: Manager
{
//    static let instance: ScheduleMan = ScheduleMan()
//
//    class CallKeys // This is a support class just for like utils and stuff idk
//    {
//        static let PUSH = "push"
//
//        static let START_TIME = "ST"
//        static let END_TIME = "ET"
//        static let BLOCK = "B"
//
//        static let SCHOOL_END = "School" + END_TIME
//        static let SECONDLUNCH_START = "SecondLunch" + START_TIME
//    }
//
//    enum ScheduleState
//    {
//        case beforeSchool, beforeSchoolGetToClass, noClass, getToClass, inClass, afterSchool, error
//    }
//
//    private(set) var onVacation = false
//
//    private var weekSchedule: [Day: Weekday] = [:]
//    var scheduleLoaded = false
//    var attemptedLoad = false
//
//    func dayLoaded(id: Day) -> Bool
//    {
//        return self.weekSchedule[id] != nil
//    }
//
//    func blockList(id: Day) -> [Block]?
//    {
//        if let day = self.weekSchedule[id]
//        {
//            return day.blocks
//        }
//        return nil
//    }
//
//    init()
//    {
//        super.init(name: "Schedule Manager")
//    }
//
//    override func eventHandlerTriggers() -> [String]
//    {
//        return ["userprefs.update"]
//    }
//
//    override func eventHandler(event: Event)
//    {
//        if let prefsUpdate = event as? UserPrefsUpdateEvent
//        {
//            if prefsUpdate.type == .load || prefsUpdate.type == .lunch
//            {
//                self.updateLunch(true)
//            }
//        }
//    }
//
//    @discardableResult
//    func loadBlocks() -> Bool
//    {
//        var success = true
//
//        self.attemptedLoad = true
//
//        let call = WebCall(app: "scheduleObject/OG")
//        let response = call.runSync()
//
//        if response.token.connected
//        {
//            let data = response.result!
//
//            if data[CallKeys.PUSH] != nil
//            {
//                self.onVacation = !(data[CallKeys.PUSH] as! Bool)
//
//                var newSchedule: [Day: Weekday] = [:]
//
////                var endTimes: [String]! = data[CallKeys.SCHOOL_END] != nil ? data[CallKeys.SCHOOL_END] as! [String] : []
//                var secondLunchStarts: [String]! = data[CallKeys.SECONDLUNCH_START] != nil ? data[CallKeys.SECONDLUNCH_START] as! [String] : []
//
////                Debug.out("About to go through days")
//
//                var i = -1
//                for dayId in Day.weekdays() // Only retrieve schedules for weekdays
//                {
//                    i+=1
//
////                    Debug.out("In Day: \(dayId)")
//
////                    let endTime: String? = endTimes.count > i ? endTimes[i] : nil // Required
//                    let secondLunch: String? = secondLunchStarts.count > i ? secondLunchStarts[i] : nil // Not required.
//
//                    var blocks: [String]? = data[dayId.rawValue + CallKeys.BLOCK] != nil ? data[dayId.rawValue + CallKeys.BLOCK] as? [String] : nil
//                    var startTimes: [String]? = data[dayId.rawValue + CallKeys.START_TIME] != nil ? data[dayId.rawValue + CallKeys.START_TIME] as? [String] : nil
//                    var endTimes: [String]? = data[dayId.rawValue + CallKeys.END_TIME] != nil ? data[dayId.rawValue + CallKeys.END_TIME] as? [String] : []
//
//                    if /*endTime != nil &&*/ blocks != nil && blocks != nil && startTimes != nil && endTimes != nil
//                    {
//                        if blocks!.count != startTimes!.count || startTimes!.count != endTimes!.count || endTimes!.count != blocks!.count
//                        {
//                            Debug.out("Loaded an inconsistent amount of StartTimes, EndTimes, and Blocks")
//                            continue
//                        }
//
////                        Debug.out("Got the right number of everything.")
//
//                        var blockLibrary: [Block] = []
//                        for y in 0..<blocks!.count
//                        {
//                            var block = Block()
//
//                            let rawId = blocks![y]
//
////                            Debug.out("rawId A: \(rawId)")
//
//                            let trimmedRawId = Utils.substring(rawId, start: 0, distance: rawId.characters.count - (rawId.characters.count == 2 ? 1 : 0))
//
////                            Debug.out("trimmedRawId B: \(trimmedRawId)")
//
//                            var blockId = BlockID.fromRaw(raw: trimmedRawId) // Get block value even if it's a lunch block
//                            if blockId == nil
//                            {
//                                blockId = BlockID.custom
//                                block.overrideDisplayName = rawId
//                            }
//
////                            -----------------------------------------------
////                            Below: a very hacky chunk of code that sets a block as a lunch block if the recieved block contains a 1 or 2 at the end.
//                            let lunchId = rawId.last
//                            if lunchId != nil
//                            {
//                                if let lunchBlockNumber = Int(String(describing: lunchId!))
//                                {
//                                    block.lunchBlockNumber = lunchBlockNumber
//                                    if block.lunchBlockNumber != 1 && block.lunchBlockNumber != 2 { block.lunchBlockNumber = nil } // If it isn't a 1 or a 2 then it isn't valid.
//                                }
//                            }
////                            -----------------------------------------------
//
//                            block.blockId = blockId!
//                            block.weekday = dayId
//                            block.endTime = TimeContainer(endTimes![y])
//                            block.startTime = TimeContainer(startTimes![y])
//
////                            Debug.out("Block: \(block)")
//
//                            blockLibrary.append(block)
//                        }
//
//                        // Set last block
//                        if blockLibrary.last != nil
//                        {
//                            blockLibrary[blockLibrary.endIndex - 1].isLastBlock = true
//                        }
//
//                        if blockLibrary.first != nil
//                        {
//                            blockLibrary[blockLibrary.startIndex].isFirstBlock = true
//                        }
//
//                        var weekday: Weekday = Weekday()
//                        weekday.dayId = dayId
//                        weekday.secondLunchStart = secondLunch == nil ? nil : TimeContainer(secondLunch!)
//                        weekday.blocks = blockLibrary
//
//                        newSchedule[weekday.dayId] = weekday
//                    } else
//                    {
//                        success = false
//
//                        Debug.out("One of the loaded values for the schedule was null.")
//                        Debug.out("Blocks: \(String(describing: blocks)) StartTimes: \(String(describing: startTimes)) EndTimes: \(String(describing: endTimes))")
//                    }
//                }
//
//                Debug.out("Done with loading schedule")
//
//                self.weekSchedule.removeAll()
//                self.weekSchedule = newSchedule
//            } else
//            {
//                success = false
//                Debug.out("WebCall failed: Check internet connection")
//            }
//        } else
//        {
//            success = false
//            Debug.out("WebCall failed: \(response.token.error!)")
//        }
//
//        if success
//        {
//            self.scheduleLoaded = true
//        }
//
//        self.updateLunch(false)
//
//        let event = ScheduleAttemptedLoadEvent(success: success)
//        self.callEvent(event)
//
//        return success
//    }
//
//    func updateLunch(_ updateHandlers: Bool = false)
//    {
//        for dayId in self.weekSchedule.keys
//        {
//            let day = self.weekSchedule[dayId]!
//
//            if let flip = UserPrefsManager.instance.getSwitch(id: dayId)
//            {
//                var blockList = self.blockList(id: dayId)!
//                for i in 0..<blockList.count // Use this iterator so we can modify block
//                {
//                    var block = blockList[i]
//
//                    if !block.hasLunchBlockNumber { continue }
//
//                    // Reset custom flags
//                    block.overrideEndTime = nil
//                    block.overrideStartTime = nil
//                    block.overrideDisplayName = nil
//                    block.isLunchBlock = false
//
//                    if flip // User has first lunch
//                    {
//                        if block.lunchBlockNumber! == 1 // First lunch block - B1
//                        {
//                            // Lunch
//                            block.overrideDisplayName = "Lunch"
//                            block.isLunchBlock = true
//                        }
//                    } else // User has second lunch
//                    {
//                        if block.lunchBlockNumber! == 1 // First lunch block - B1
//                        {
//                            // Class
//                            block.overrideEndTime = day.secondLunchStart ?? nil // SEt its end time to the start of lunch
//                        } else // Second lunch block - B2
//                        {
//                            block.overrideDisplayName = "Lunch"
//                            block.overrideStartTime = day.secondLunchStart ?? nil // Set its start time to the start of lunch
//                            block.isLunchBlock = true
//                        }
//                    }
//
//                    self.weekSchedule[dayId]!.blocks[i] = block
//                }
//            }
//        }
//
//        if updateHandlers
//        {
//            let event = ScheduleUpdatedEvent()
//            self.callEvent(event)
//        }
//    }
//
//    func currentDayOfWeek() -> Day
//    {
//        let today = TimeUtils.getDayOfWeekFromString(TimeUtils.currentDateAsString()) // 0 to 6 for Monday - Sunday
//        return Day.fromId(today)!
//    }
//
//    func getNextSchoolday() -> Day?
//    {
//        for i in 0..<Day.values().count
//        {
//            let day = (i+self.currentDayOfWeek().id + 1) % Day.values().count
//
//            let nextDay = Day.fromId(day)
//            if let schedule = self.blockList(id: nextDay!)
//            {
//                if schedule.count > 0
//                {
//                    return nextDay!
//                }
//            }
//        }
//        return nil
//    }
//
//    func getCurrentBlock() -> Block?
//    {
//        let currentDate = Date()
//        if let blocks = self.blockList(id: self.currentDayOfWeek())
//        {
//            for block in blocks
//            {
//                let analyst = block.analyst
//
//                let start = analyst.getStartTime().asDate()
//                let end = analyst.getEndTime().asDate()
//
//                if currentDate >= start && currentDate < end
//                {
//                    return block
//                }
//            }
//        }
//
//        return nil
//    }
//
//    func getCurrentScheduleInfo() -> (minutesRemaining: Int, curBlock: Block?, nextBlock: Block?, scheduleState: ScheduleState)
//    {
//        let curBlock = ScheduleManager.instance.getCurrentBlock()
//        if curBlock != nil // If we're currently in class
//        {
//            let analyst = curBlock!.analyst
//
//            let nextBlock = analyst.getNextBlock()
//            let minutesToEnd = TimeUtils.timeToDateInMinutes(to: analyst.getEndTime().asDate())
//
//            return (minutesToEnd, curBlock!, nextBlock, .inClass) // Return the time until the end of the class
//        } else
//        {
//            let curDate = Date()
//
//            if let blocks = ScheduleManager.instance.blockList(id: self.currentDayOfWeek())
//            {
//                for block in blocks
//                {
//                    let analyst = block.analyst
//
//                    if analyst.isFirstBlock() && curDate < analyst.getStartTime().asDate() // Before first block -> Before school
//                    {
//                        let timeToSchoolStart = TimeUtils.timeToDateInMinutes(to: analyst.getStartTime().asDate())
//                        return (timeToSchoolStart, nil, block, timeToSchoolStart <= 5 ? .beforeSchoolGetToClass : .beforeSchool) // If there's less than 5 minutes before the first block starts
//                    }
//
//                    if analyst.isLastBlock() && curDate >= analyst.getEndTime().asDate() // After school
//                    {
//                        return (-1, nil, nil, .afterSchool)
//                    }
//
//                    let nextBlock = analyst.getNextBlock()
//                    if nextBlock != nil // There SHOULD always be another block since it should've caught if it's the last block or we're in class so this check is mainly just a failsafe
//                    {
//                        let nextBlockAnalyst = nextBlock!.analyst
//                        if curDate >= analyst.getEndTime().asDate() && curDate < nextBlockAnalyst.getStartTime().asDate() // Inbetween classes
//                        {
//                            let timeToNextBlock = TimeUtils.timeToDateInMinutes(to: nextBlockAnalyst.getStartTime().asDate())
//                            return (timeToNextBlock, block, nextBlock, .getToClass) // Return the previous class as the current class if we're inbetween. This is just for convenience.
//                        }
//                    }
//                }
//            }
//
//            return (-1, nil, nil, .noClass) // Holiday or vacation or just no blocks were loaded into the system for some reason
//        }
//        //        return (-1, nil, nil, .error) // Final failsafe error catch.
//    }
}

//struct Weekday
//{
//	var dayId: Day! // M, T, W, Th, F
//	var blocks: [Block]! // Class ID to Block MAJOR ISSUE THIS WON'T PRESERVE ORDER.
//	var secondLunchStart: TimeContainer? // I hate having this here but I can't really think of a better way to do it rn
//}

