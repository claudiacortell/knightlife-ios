//
//  HomeTableViewController.swift
//  Glancer
//
//  Created by Cassandra Kane on 11/29/15.
//  Copyright (c) 2015 Vishnu Murale. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController, ScheduleUpdateHandler, PrefsUpdateHandler
{
    var timer = Timer()
	
    @IBOutlet weak var mainDayLabel: UILabel!
    @IBOutlet weak var mainBlockLabel: UILabel!
    @IBOutlet weak var mainTimeLabel: UILabel!
    @IBOutlet weak var mainNextBlockLabel: UILabel!

	var dayId: DayID = .monday
	
    var row: Int = 0
    var minutesUntilNextBlock: Int = 0
	
	var labels: [Label] = []
	
	var scheduleUpdated = false
	var settingsUpdated = false
	
    override func viewDidLoad()
	{
        super.viewDidLoad()
		
		self.tabBarController?.tabBar.items![0].isEnabled = false
		self.tabBarController?.tabBar.items![0].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
		self.tabBarController?.tabBar.items![1].isEnabled = false
		self.tabBarController?.tabBar.items![1].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
		self.tabBarController?.tabBar.items![2].isEnabled = false
		self.tabBarController?.tabBar.items![2].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
		
		ScheduleManager.instance.loadBlocksIfNotLoaded()
		
		if self.scheduleUpdated || self.settingsUpdated
		{
			self.scheduleUpdated = false
			self.settingsUpdated = false
			
			self.generateWeekData()
		}
	}
	
    override func didReceiveMemoryWarning()
	{
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func scheduleDidUpdate(didUpdateSuccessfully: Bool, newSchedule: inout [DayID: Weekday])
	{
		if self.isViewLoaded && didUpdateSuccessfully
		{
			self.generateWeekData()
		} else
		{
			self.scheduleUpdated = didUpdateSuccessfully
		}
	}
	
	func prefsDidUpdate(manager: UserPrefsManager, change: UserPrefsManager.PrefsChange)
	{
		if self.isViewLoaded
		{
			self.generateWeekData()
		} else
		{
			self.settingsUpdated = true
		}
	}
	
    func generateHomeScreenData()
	{
		if self.timer.isValid
		{
			self.timer.invalidate()
		}
		
        if (ScheduleManager.instance.onVacation)
		{
            mainDayLabel.text = "Vacation"
            mainBlockLabel.text = "Enjoy"
            mainTimeLabel.text = ""
            mainNextBlockLabel.text = ""
		} else
		{
            updateMainHomePage()
        }
		
		labels.removeAll()
		generateLabels()
		
		self.tableView.reloadData()
		self.tabBarController?.tabBar.items![0].isEnabled = true
		self.tabBarController?.tabBar.items![1].isEnabled = true
		self.tabBarController?.tabBar.items![2].isEnabled = true
    }
	
    func updateMainHomePage()
	{
        //updates the main labels on home page
		self.dayId = ScheduleManager.instance.currentDayOfWeek() // Set the day ID
		
        mainDayLabel.text = getMainDayLabel()
        mainBlockLabel.text = getMainBlockLabel()
        mainTimeLabel.text = getMainTimeLabel()
        mainNextBlockLabel.text = getMainNextBlockLabel()
    }
    
    
    // get Home Page labels
    func getMainDayLabel() -> String
	{
		return self.dayId.displayName
	}
    
    func getMainBlockLabel() -> String
	{
		if DayID.weekdays().contains(self.dayId)
		{
			var dayInfo = getCurrentDayInformation()
			
			let currentClass = appDelegate.Days[dayNum].messagesForBlock[currentBlock]
			if currentClass != nil {
				if currentBlock == "X" {
					return "\(currentBlock) Block"
				} else if currentBlock == "Activities" || currentBlock == "Lab" {
					return "\(currentBlock)"
				} else {
					return "\(currentBlock) Block (\(currentClass!))"
				}
			} else if currentBlock == "GetToClass" {
				return "Class Over"
			}
			else if currentBlock == "BeforeSchoolGetToClass"{
				return "School Begins"
			}
			else {
				return ""
			}
		}
		
		return nil
		
//        if dayNum < 5 {
//            let currentValues = getCurrentDayInformation()
//            let currentBlock = currentValues.currentBlock
//            let currentClass = appDelegate.Days[dayNum].messagesForBlock[currentBlock]
//            if currentClass != nil {
//                if currentBlock == "X" {
//                    return "\(currentBlock) Block"
//                } else if currentBlock == "Activities" || currentBlock == "Lab" {
//                    return "\(currentBlock)"
//                } else {
//                    return "\(currentBlock) Block (\(currentClass!))"
//                }
//            } else if currentBlock == "GetToClass" {
//                return "Class Over"
//            }
//            else if currentBlock == "BeforeSchoolGetToClass"{
//                return "School Begins"
//            }
//            else {
//                return ""
//            }
//        } else {
//            return ""
//        }
//        
    }
    
    func getMainTimeLabel() -> String {
        let currentDateTime = appDelegate.Days[0].getDateAsString()
        let dayNum = appDelegate.Days[0].getDayOfWeekFromString(currentDateTime)
        
        if dayNum < 5 {
            let currentValues = getCurrentDayInformation()
            let currentBlock = currentValues.currentBlock
            let currentClass = appDelegate.Days[dayNum].messagesForBlock[currentBlock]
            if currentClass != nil {
                let minutesRemaining = currentValues.minutesRemaining
                return "\(minutesRemaining) mins remaining"
            } else if currentBlock == "GetToClass" ||  currentBlock == "BeforeSchoolGetToClass"{
                let minutesRemaining = currentValues.minutesRemaining
                let minutesUntil = 5 - (-minutesRemaining)
                return "\(minutesUntil) mins until"
            } else if currentBlock == "BeforeSchool"{
                return "Before School"
            }else{
                return "School Over"
            }
        } else {
            return "No School"
        }
    }
    
    func getMainNextBlockLabel() -> String {
        let currentDateTime = appDelegate.Days[0].getDateAsString()
        let dayNum = appDelegate.Days[0].getDayOfWeekFromString(currentDateTime)
        
        if dayNum < 5 {
            let currentValues = getCurrentDayInformation()
            let currentBlock = currentValues.currentBlock
            let nextBlock = currentValues.nextBlock
            let nextClass = appDelegate.Days[dayNum].messagesForBlock[nextBlock]
            if nextClass != nil {
                if nextClass == "X" {
                    return "Next: \(nextClass!) Block"
                } else if nextClass == "Activities" || nextClass == "Lab" {
                    return "Next: \(nextClass!)"
                } else {
                    return "Next: \(nextBlock) Block (\(nextClass!))"
                }
            } else if currentBlock == "GetToClass" {
                //return "Next Block"
            } else {
                return ""
            }
        } else {
            return ""
        }
        return ""
    }
    
	func generateWeekData()
	{
		if (ScheduleManager.instance.scheduleLoaded())
		{
			setWeekData()
		}
		else if !timer.isValid
		{
			timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(WeekTableViewController.setWeekData), userInfo: nil, repeats: true)
		}
	}
	
	func setWeekData()
	{
		if self.timer.isValid
		{
			self.timer.invalidate()
		}
		
		labels.removeAll()
		generateLabels()
		
		self.tableView.reloadData()
	}
	
	func generateLabels()
	{
		if self.dayId != nil
		{
			let day = ScheduleManager.instance.weekSchedule[self.dayId!]!
			for block in day.blocks
			{
				let analyst = BlockAnalyst(block: block)
				
				let finalTime = "\(analyst.getStartTime().toFormattedString()) - \(analyst.getEndTime().toFormattedString())"
				
				let newLabel = Label(bL: analyst.getDisplayLetter(), cN: analyst.getDisplayName(), cT: finalTime, c: analyst.getColor())
				labels.append(newLabel)
			}
		}
	}
	
    func findMinutes(_ hourBefore : Int, hourAfter : Int)->Int{
        let numHoursLess = Int(hourBefore/100)
        let numHoursMore = Int(hourAfter/100)
        
        let diffHours = numHoursMore - numHoursLess
        let diffMinutes = hourAfter%100 - hourBefore%100
        
        return diffHours*60 + diffMinutes
    }
    
    func getCurrentDayInformation() -> (currentBlock : String, nextBlock : String, minutesRemaining : Int)
	{
        let currentDateTime = appDelegate.Days[0].getDateAsString()
        let dayNum = appDelegate.Days[0].getDayOfWeekFromString(currentDateTime)
        var widgetBlock = appDelegate.Widget_Block
        var timeBlock = appDelegate.Time_Block
        var endTimes = appDelegate.End_Times
        var endTimesBlock = appDelegate.End_Time_Block
        
        var currentBlock = ""
        var nextBlock = ""
        
        var minutesUntilNextBlock = 0
        
        let defaults = UserDefaults.standard
        
        var firstLunchTemp = true
        
        if(defaults.object(forKey: "SwitchValues") != nil){
            let UserSwitch: [Bool] = defaults.object(forKey: "SwitchValues") as! Array<Bool>
            firstLunchTemp = UserSwitch[dayNum]
        }
        
        if(!firstLunchTemp){
            
            let secondLunchTime = appDelegate.Second_Lunch_Start[dayNum]
            var counter = 0
            
            for x in widgetBlock[dayNum]{
                if(x.hasSuffix("2")){
                    timeBlock[dayNum][counter] = secondLunchTime
                    endTimesBlock[dayNum][counter-1] = secondLunchTime
                }

                counter += 1
            }
        }
        
        for i in Array((0...widgetBlock[dayNum].count-1).reversed())
		{
            
            let dateAfter = timeBlock[dayNum][i]
            let CurrTime = appDelegate.Days[0].NSDateToStringWidget(Date())
            
            let endTimeString = endTimesBlock[dayNum][i]
            
            var hour4 = self.substring(dateAfter,StartIndex: 1,EndIndex: 3)
            hour4 = hour4 + self.substring(dateAfter,StartIndex: 4,EndIndex: 6)
            
            var hour2 = self.substring(CurrTime,StartIndex: 1,EndIndex: 3)
            hour2 = hour2 + self.substring(CurrTime,StartIndex: 4,EndIndex: 6)
            var end_time = self.substring(endTimeString,StartIndex: 1,EndIndex: 3)
            end_time = end_time + self.substring(endTimeString,StartIndex: 4,EndIndex: 6)
            
            
            let hourOne = Int(hour4)
            let hourTwo = Int(hour2)
            let hourAfter = Int(end_time)
        
            if(i==0 && hourTwo < hourOne ){ // if before school
                currentBlock = "BeforeSchool"
                nextBlock = widgetBlock[dayNum][i]

                minutesUntilNextBlock = self.findMinutes(hourTwo!, hourAfter: (hourOne!))
 
                if(minutesUntilNextBlock <= 5){
                    
                    minutesUntilNextBlock = -5+minutesUntilNextBlock
                    currentBlock = "BeforeSchoolGetToClass"
                    nextBlock = widgetBlock[dayNum][i]
 
                }
            }
            
            //last block
            if(i == widgetBlock[dayNum].count-1 && hourTwo >= hourOne){
                
                let EndTime = endTimes[dayNum]
                if(hourTwo! - EndTime < 0) {

                    minutesUntilNextBlock = self.findMinutes(hourTwo!, hourAfter: (EndTime))
                    
                    if(minutesUntilNextBlock > 0){
                        currentBlock = widgetBlock[dayNum][i]
                        nextBlock = "No Class"
                    }
                    else {
                        currentBlock = "GetToClass"
                        nextBlock = widgetBlock[dayNum][i]
                    }
                }
                else {
                    currentBlock = "NOCLASSNOW"
                    nextBlock = "No Class"
                    
                }
                break
            }
            
            
            if(hourTwo >= hourOne){
                minutesUntilNextBlock = self.findMinutes(hourTwo!, hourAfter: (hourAfter!))
                
                if(minutesUntilNextBlock > 0){
                    currentBlock = widgetBlock[dayNum][i]
                    nextBlock = widgetBlock[dayNum][i + 1]
                }
                else{
                    currentBlock = "GetToClass"
                    nextBlock = widgetBlock[dayNum][i + 1]
                }
                break
            }
            
        }
        return (currentBlock, nextBlock, minutesUntilNextBlock)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
        // Return the number of rows in the section.
        return self.labels.count
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		if (ScheduleManager.instance.scheduleLoaded())
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeekTableViewCell
			let label = labels[(indexPath as NSIndexPath).row]
			cell.label = label
			
			return cell
		} else
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeekTableViewCell
			let label = Label(bL: "", cN: "", cT: "", c: "999999")
			cell.label = label
			
			return cell
		}
		
	}
}
