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
	var firstOpen = true
	
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
		
		if self.firstOpen
		{
			// Register as handler
			ScheduleManager.instance.addHandler(self)
			UserPrefsManager.instance.addHandler(self)
		}
		
		self.tabBarController?.tabBar.items![0].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
		self.tabBarController?.tabBar.items![1].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
		self.tabBarController?.tabBar.items![2].imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
		
		if self.scheduleUpdated || self.settingsUpdated || self.firstOpen
		{
			self.scheduleUpdated = false
			self.settingsUpdated = false
			self.firstOpen = false

			self.updateCurInfo(true)
		}
		
		self.setTimer() // Reinitialize timer
	}
	
    override func didReceiveMemoryWarning()
	{
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func setTimer()
	{
		if !timer.isValid
		{
			timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HomeTableViewController.timerCall), userInfo: nil, repeats: true)
		}
	}
	
	@objc func timerCall()
	{
		self.updateCurInfo(false)
	}
	
	func scheduleDidUpdate(didUpdateSuccessfully: Bool)
	{
		if self.isViewLoaded && didUpdateSuccessfully
		{
			self.updateCurInfo(true)
		} else
		{
			self.scheduleUpdated = true
		}
	}
	
	func prefsDidUpdate(_ type: UserPrefsManager.PrefsUpdateType)
	{
		if self.isViewLoaded
		{
			self.updateCurInfo(true)
		} else
		{
			self.settingsUpdated = true
		}
	}
	
	func updateCurInfo(_ updateBlocks: Bool)
	{
		if !ScheduleManager.instance.scheduleLoaded
		{
			return
		}
		
		self.dayId = ScheduleManager.instance.currentDayOfWeek() // Set the day ID
		
		if (ScheduleManager.instance.onVacation)
		{
			mainDayLabel.text = "Vacation"
			mainBlockLabel.text = "Enjoy"
			mainTimeLabel.text = ""
			mainNextBlockLabel.text = ""
		} else
		{
			//updates the main labels on home page
			mainDayLabel.text = getMainDayLabel()
			mainBlockLabel.text = getMainBlockLabel()
			mainTimeLabel.text = getMainTimeLabel()
			mainNextBlockLabel.text = getMainNextBlockLabel()
		}
		
		if updateBlocks
		{
			labels.removeAll()
			generateLabels()
			
			self.tableView.reloadData()
		}
	}
	
    // get Home Page labels
    func getMainDayLabel() -> String
	{
		return self.dayId.displayName
	}
    
    func getMainBlockLabel() -> String
	{
		if DayID.weekdays().contains(self.dayId) // Is a weekday
		{
			let dayInfo = getCurrentScheduleInfo()
			
			switch dayInfo.scheduleState
			{
			case .inClass:
				return dayInfo.curBlock!.analyst.getDisplayName()
			case .beforeSchool:
				return "School Starts"
			case .beforeSchoolGetToClass:
				return "School Starts"
			case .afterSchool:
				return "School Over"
			case .getToClass:
				return "Class Over"
			case .noClass:
				return "No Classes"
			case .error:
				return "Error Loading"
			}
		}
		return "No Classes"
    }
    
    func getMainTimeLabel() -> String
	{
		if DayID.weekdays().contains(self.dayId) // Is a weekday
		{
			let dayInfo = getCurrentScheduleInfo()
//			var formattedMinutes = "\(floor(Double(dayInfo.minutesRemaining / 60))):\(dayInfo.minutesRemaining % 60)" // Formatted time left in block. HH:MM
			
			switch dayInfo.scheduleState
			{
			case .inClass:
				return "\(dayInfo.minutesRemaining) left"
			case .beforeSchool:
				return "In \(dayInfo.minutesRemaining)"
			case .beforeSchoolGetToClass:
				return "In \(dayInfo.minutesRemaining) minutes"
			case .afterSchool:
				return ""
			case .getToClass:
				return "In \(dayInfo.minutesRemaining) minutes"
			case .noClass:
				return ""
			case .error:
				return "Error"
			}
		}
		return ""
    }
    
    func getMainNextBlockLabel() -> String
	{
		if DayID.weekdays().contains(self.dayId) // Is a weekday
		{
			let dayInfo = getCurrentScheduleInfo()
			
			if dayInfo.nextBlock != nil
			{
				return dayInfo.nextBlock!.analyst.getDisplayName()
			}
		}
		return ""
    }
	
	func generateLabels()
	{
		if let blocks = ScheduleManager.instance.blockList(id: self.dayId)
		{
			for block in blocks
			{
				let analyst = block.analyst
				
				let finalTime = "\(analyst.getStartTime().toFormattedString()) - \(analyst.getEndTime().toFormattedString())"
				
				let newLabel = Label(bL: analyst.getDisplayLetter(), cN: analyst.getDisplayName(), cT: finalTime, c: analyst.getColor())
				labels.append(newLabel)
			}
		}
	}
	
	enum ScheduleState
	{
		case beforeSchool, beforeSchoolGetToClass, noClass, getToClass, inClass, afterSchool, error
	}
	
	func getCurrentScheduleInfo() -> (minutesRemaining: Int, curBlock: Block?, nextBlock: Block?, scheduleState: ScheduleState)
	{
		let curBlock = ScheduleManager.instance.getCurrentBlock()
		if curBlock != nil // If we're currently in class
		{
			let analyst = curBlock!.analyst
			
			let nextBlock = analyst.getNextBlock()
			let minutesToEnd = TimeUtils.timeToDateInMinutes(to: analyst.getEndTime().asDate())
			
			return (minutesToEnd, curBlock!, nextBlock, .inClass) // Return the time until the end of the class
		} else
		{
			let curDate = Date()
			
			if let blocks = ScheduleManager.instance.blockList(id: self.dayId)
			{
				for block in blocks
				{
					let analyst = block.analyst
					
					if analyst.isFirstBlock() && curDate < analyst.getStartTime().asDate() // Before first block -> Before school
					{
						let timeToSchoolStart = TimeUtils.timeToDateInMinutes(to: analyst.getStartTime().asDate())
						return (timeToSchoolStart, nil, block, timeToSchoolStart <= 5 ? .beforeSchoolGetToClass : .beforeSchool) // If there's less than 5 minutes before the first block starts
					}
					
					if analyst.isLastBlock() && curDate >= analyst.getEndTime().asDate() // After school
					{
						return (-1, nil, nil, .afterSchool)
					}
					
					let nextBlock = analyst.getNextBlock()
					if nextBlock != nil // There SHOULD always be another block since it should've caught if it's the last block or we're in class so this check is mainly just a failsafe
					{
						let nextBlockAnalyst = nextBlock!.analyst
						if curDate >= analyst.getEndTime().asDate() && curDate < nextBlockAnalyst.getStartTime().asDate() // Inbetween classes
						{
							let timeToNextBlock = TimeUtils.timeToDateInMinutes(to: nextBlockAnalyst.getStartTime().asDate())
							return (timeToNextBlock, block, nextBlock, .getToClass) // Return the previous class as the current class if we're inbetween. This is just for convenience.
						}
					}
				}
			} else
			{
				return (-1, nil, nil, .error)
			}
			
			return (-1, nil, nil, .noClass) // Holiday or vacation or just no blocks were loaded into the system for some reason
		}
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
        return self.labels.count
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		if (ScheduleManager.instance.scheduleLoaded)
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BlockTableViewCell
			let label = labels[(indexPath as NSIndexPath).row]
			cell.label = label
			
			return cell
		} else
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BlockTableViewCell
			let label = Label(bL: "", cN: "", cT: "", c: "999999")
			cell.label = label
			
			return cell
		}
		
	}
}
