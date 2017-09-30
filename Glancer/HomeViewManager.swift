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
	private var tableOverrideId: DayID? = nil
	
	private var previousState: ScheduleState?
	
	private var timer: Timer = Timer()
	
	@IBOutlet weak var tableView: HomeBlockTableController!
	
	@IBOutlet weak var headerBlockLabel: UILabel!
	@IBOutlet weak var headerMinutesLabel: UILabel!
	
	@IBOutlet weak var dayLabel: UILabel!
	@IBOutlet weak var blockLabel: UILabel!
	@IBOutlet weak var nextBlockLabel: UILabel!
	
	@IBOutlet weak var nextLabel: UILabel!
	
	private var firstOpen = true
	
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
		
		self.firstOpen = false
	}
	
	override func viewDidAppear(_ animated: Bool)
	{
		self.timer.invalidate() // Create a new timer.
		self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HomeViewManager.updateTime), userInfo: nil, repeats: true)
		
		self.tableOverrideId = nil
		
		self.updateTime()
	}
	
	override func viewDidDisappear(_ animated: Bool)
	{
		self.timer.invalidate()
	}
	
	@objc func updateTime()
	{
		if !ScheduleManager.instance.scheduleLoaded
		{
			return
		}
		
		self.dayId = DayID.fromId(TimeUtils.getDayOfWeek(date: Date()))!
		self.updateViews()
	}
	
	func scheduleDidUpdate(didUpdateSuccessfully: Bool)
	{
		if self.isViewLoaded && didUpdateSuccessfully
		{
			self.updateViews()
		}
	}
	
	func prefsDidUpdate(_ type: UserPrefsManager.PrefsUpdateType)
	{
		if self.isViewLoaded
		{
			self.updateViews()
		}
	}
	
	func updateViews()
	{
		self.dayLabel.text = self.dayId.displayName
		self.nextLabel.text = "Next"
		
		let state = getCurrentScheduleInfo()

		self.tableOverrideId = nil // Reset it. It'll get changed below if we really want it overriden.
		self.tableView.showExpiredBlocks = true
		
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
			self.headerBlockLabel.text = ""
			self.headerMinutesLabel.text = ""
			
			self.nextLabel.text = "Next Schoolday"
			
			self.blockLabel.text = "No Class"

			if let nextDay = ScheduleManager.instance.getNextSchoolday()
			{
				self.nextBlockLabel.text = nextDay.displayName
			} else
			{
				self.nextBlockLabel.text = "-"
			}
		} else if state.scheduleState == .afterSchool
		{
			self.tableOverrideId = self.dayId.nextDay
			
			self.headerBlockLabel.text = "School Over"
			self.headerMinutesLabel.text = ""
			self.blockLabel.text = "School Over"
			self.nextLabel.text = ScheduleManager.instance.dayLoaded(id: self.tableOverrideId!) ? "Tomorrow's Schedule" : "Tomorrow (No School)"
			self.nextBlockLabel.text = self.tableOverrideId!.displayName

			self.tableView.showExpiredBlocks = false
		} else
		{
			self.headerBlockLabel.text = "ERROR"
			self.headerMinutesLabel.text = "ERROR"
			self.blockLabel.text = "ERROR"
			self.nextBlockLabel.text = "ERROR"
		}
		
		if !self.tableView.dayIndexChanged(new: self.tableOverrideId ?? self.dayId) // Update the table view to the new day. This will do nothing if the table is already set to the right day.
		{
			self.tableView.updateExpiredBlocks(animate: true) // Only manually update the expired blocks if the table view wasn't updated.
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
			}
			else
			{
				return (-1, nil, nil, .noClass) // Holiday or vacation or just no blocks were loaded into the system for some reason

			}
		}
		return (-1, nil, nil, .error) // Final failsafe error catch.
	}
}

class HomeBlockTableController: UITableView, UITableViewDataSource, UITableViewDelegate
{
	var dayId = DayID.monday
	
	var labels: [Label] = []
	
	var showExpiredBlocks = true

	private func setWeekData()
	{
		if !ScheduleManager.instance.scheduleLoaded
		{
			return
		}
		
		labels.removeAll()
		generateLabels()
		
		self.reloadData()
	}
	
	@discardableResult
	func dayIndexChanged(new: DayID) -> Bool // Whether or not the schedule was updated.
	{
		if self.dayId != new
		{
			self.dayId = new
			self.setWeekData()
			return true
		}
		return false
	}
	
	private func generateLabels()
	{
		if let blocks = ScheduleManager.instance.blockList(id: self.dayId)
		{
			for block in blocks
			{
				let analyst = block.analyst
				
				let finalTime = "\(analyst.getStartTime().toFormattedString()) - \(analyst.getEndTime().toFormattedString())"
				
				let newLabel = Label(bL: analyst.getDisplayLetter(), cN: analyst.getDisplayName(), cT: finalTime, c: analyst.getColor(), block: block)
				labels.append(newLabel)
			}
		}
	}
	
	func updateExpiredBlocks(animate: Bool = false)
	{
		for cell in self.visibleCells
		{
			if cell is HomeBlockCell
			{
				let newCell = cell as! HomeBlockCell
				self.updateExpiredBlock(cell: newCell)
			}
		}
	}
	
	private func updateExpiredBlock(cell: HomeBlockCell)
	{
		if self.showExpiredBlocks
		{
			if cell.block != nil
			{
				cell.setExpired(expired: cell.block!.analyst.hasPassed())
			}
		} else
		{
			cell.setExpired(expired: false)
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
			let label = labels[(indexPath as NSIndexPath).row]
			let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeBlockCell
			cell.label = label
			
			updateExpiredBlock(cell: cell)
			
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
	
	@IBOutlet weak var viewMask: UIView!

	var expired: Bool = false
	var block: Block?
	
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
				self.block = label.block

				let RGBvalues = Utils.getRGBFromHex(label.color)
				self.bodyView.backgroundColor = UIColor(red: (RGBvalues[0] / 255.0), green: (RGBvalues[1] / 255.0), blue: (RGBvalues[2] / 255.0), alpha: 1)
			}
		}
	}
	
	
	func setExpired(expired: Bool)
	{
		if self.block != nil
		{
//			Debug.out("\(self.block!.blockId.rawValue): \(expired)")
			
			if self.expired == expired { return }
			
			self.expired = expired
			self.viewMask.alpha = self.expired ? 0.6 : 0.0
		}
	}
}
