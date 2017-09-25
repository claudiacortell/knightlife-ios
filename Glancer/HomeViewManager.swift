//
//  HomeViewManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/25/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation

class HomeViewManager: UIViewController, ScheduleUpdateHandler, PrefsUpdateHandler
{
	private var dayId: DayID = .monday
	private var timer: Timer = Timer()
	
	@IBOutlet weak var tableView: HomeBlockTableController!
	
	@IBOutlet weak var headerBlockLabel: UILabel!
	@IBOutlet weak var headerMinutesLabel: UILabel!
	
	@IBOutlet weak var dayLabel: UILabel!
	@IBOutlet weak var blockLabel: UILabel!
	@IBOutlet weak var nextBlockLabel: UILabel!
	
	private var firstOpen = true
	
	var scheduleUpdated = false
	var settingsUpdated = false
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		if self.firstOpen
		{
			self.tableView.delegate = self.tableView!
			self.tableView.dataSource = self.tableView!
			
			// Register as handler
			ScheduleManager.instance.addHandler(self)
			UserPrefsManager.instance.addHandler(self)
		}
		
		if self.scheduleUpdated || self.settingsUpdated || self.firstOpen
		{
			self.scheduleUpdated = false
			self.settingsUpdated = false
			
			self.tableView.generateWeekData()
		}
		
		self.updateTime()
		if !self.timer.isValid
		{
			timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HomeViewManager.updateTime), userInfo: nil, repeats: true)
		}
		
		self.firstOpen = false
	}
	
	@objc func updateTime()
	{
		let oldDay = self.dayId
		
		self.dayId = DayID.fromId(TimeUtils.getDayOfWeek(date: Date()))!
		if self.dayId != oldDay
		{
			self.tableView.dayIndexChanged(new: self.dayId)
		}
		
		self.updateLabels()
	}
	
	func scheduleDidUpdate(didUpdateSuccessfully: Bool)
	{
		if self.isViewLoaded && didUpdateSuccessfully
		{
			self.updateLabels()
			self.tableView.generateWeekData()
		} else
		{
			self.scheduleUpdated = didUpdateSuccessfully
		}
	}
	
	func prefsDidUpdate(_ type: UserPrefsManager.PrefsUpdateType)
	{
		if self.isViewLoaded
		{
			self.updateLabels()
			self.tableView.generateWeekData()
		} else
		{
			self.settingsUpdated = true
		}
	}
	
	func updateLabels()
	{
		self.dayLabel.text = self.dayId.displayName
		
		let state = getCurrentScheduleInfo()
		
		if state.scheduleState == .inClass
		{
			self.headerBlockLabel.text = state.curBlock!.analyst.getDisplayName()
			self.headerMinutesLabel.text = "for \(state.minutesRemaining) min"
			
			self.blockLabel.text = state.curBlock!.analyst.getDisplayName()
			if state.nextBlock != nil
			{
				self.nextBlockLabel.text = state.nextBlock!.analyst.getDisplayName()
			} else
			{
				self.nextBlockLabel.text = "School Over"
			}
		} else if state.scheduleState == .getToClass
		{
			self.headerBlockLabel.text = state.nextBlock!.analyst.getDisplayName()
			self.headerMinutesLabel.text = "in \(state.minutesRemaining) min"
			
			self.blockLabel.text = "Get to Class"
			self.nextBlockLabel.text = state.nextBlock!.analyst.getDisplayName()
		} else if state.scheduleState == .beforeSchool
		{
			self.headerBlockLabel.text = "School Start"
			self.headerMinutesLabel.text = "in \(state.minutesRemaining) min"
			
			self.blockLabel.text = "Before School"
			self.nextBlockLabel.text = state.nextBlock!.analyst.getDisplayName()
		} else if state.scheduleState == .beforeSchoolGetToClass
		{
			self.headerBlockLabel.text = state.nextBlock!.analyst.getDisplayName()
			self.headerMinutesLabel.text = "in \(state.minutesRemaining) min"
			
			self.blockLabel.text = "Get to Class"
			self.nextBlockLabel.text = state.nextBlock!.analyst.getDisplayName()
		} else if state.scheduleState == .noClass
		{
			self.headerBlockLabel.text = "No Class"
			self.headerMinutesLabel.text = "Enjoy"
			
			self.blockLabel.text = "No Class"
			self.nextBlockLabel.text = "-"
		} else if state.scheduleState == .afterSchool
		{
			self.headerBlockLabel.text = "School Over"
			self.headerMinutesLabel.text = ""
			
			self.blockLabel.text = "School Over"
			self.blockLabel.text = "-"
		} else
		{
			self.headerBlockLabel.text = "ERROR"
			self.headerMinutesLabel.text = "ERROR"
			self.blockLabel.text = "ERROR"
			self.nextBlockLabel.text = "ERROR"
		}
	}
	
	private enum ScheduleState
	{
		case beforeSchool, beforeSchoolGetToClass, noClass, getToClass, inClass, afterSchool, error
	}
	
	private func getCurrentScheduleInfo() -> (minutesRemaining: Int, curBlock: Block?, nextBlock: Block?, scheduleState: ScheduleState)
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
}

class HomeBlockTableController: UITableView, UITableViewDataSource, UITableViewDelegate
{
	var dayId = DayID.monday
	
	var timer = Timer()
	var labels: [Label] = []
	
	func generateWeekData()
	{
		if (ScheduleManager.instance.scheduleLoaded)
		{
			setWeekData()
		}
		else if !timer.isValid
		{
			timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(WeekBlockTableController.setWeekData), userInfo: nil, repeats: true)
		}
	}
	
	@objc func setWeekData()
	{
		if !ScheduleManager.instance.scheduleLoaded
		{
			return
		}
		
		if self.timer.isValid
		{
			self.timer.invalidate()
		}
		
		labels.removeAll()
		generateLabels()
		
		self.reloadData()
	}
	
	func dayIndexChanged(new: DayID)
	{
		self.dayId = new
		self.generateWeekData()
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
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return self.labels.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		if (ScheduleManager.instance.scheduleLoaded)
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeBlockCell
			let label = labels[(indexPath as NSIndexPath).row]
			cell.label = label
			
			return cell
		} else
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeBlockCell
			let label = Label(bL: "", cN: "", cT: "", c: "999999")
			cell.label = label
			
			return cell
		}
	}
}

class HomeBlockCell: UITableViewCell
{
	@IBOutlet weak var blockLetter: UILabel!
	@IBOutlet weak var className: UILabel!
	@IBOutlet weak var classTimes: UILabel!
	@IBOutlet weak var bodyView: UIView!
	
	var label: Label?
	{
		didSet
		{
			if let label = label
			{
				//sets up note table cell
				self.blockLetter.text = label.blockLetter
				self.className.text = label.className
				self.classTimes.text = label.classTimes
				let RGBvalues = Utils.getRGBFromHex(label.color)
				
				self.bodyView.backgroundColor = UIColor(red: (RGBvalues[0] / 255.0), green: (RGBvalues[1] / 255.0), blue: (RGBvalues[2] / 255.0), alpha: 1)
			}
		}
	}
}

