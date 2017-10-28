//
//  HomeViewManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/25/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation
import UIKit

class HomeViewManager: UIViewController, ScheduleUpdateHandler, PrefsUpdateHandler
{
	private var dayId: DayID = .monday
	private var tableOverrideId: DayID? = nil
	
	private var previousState: ScheduleManager.ScheduleState?
	
	private var timer: Timer = Timer()
	
	@IBOutlet weak var tableView: HomeBlockTableController!
	
	@IBOutlet weak var headerBlockLabel: UILabel!
	@IBOutlet weak var headerMinutesLabel: UILabel!
	
	@IBOutlet weak var dayLabel: UILabel!
	@IBOutlet weak var blockLabel: UILabel!
	@IBOutlet weak var nextBlockLabel: UILabel!
	
	@IBOutlet weak var nextLabel: UILabel!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.tableView.delegate = self.tableView!
		self.tableView.dataSource = self.tableView!
		
		ScheduleManager.instance.addHandler(self)
		UserPrefsManager.instance.addHandler(self)
	}
	
	override func 
		viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)
		
		self.timer.invalidate() // Create a new timer.
		self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HomeViewManager.updateTime), userInfo: nil, repeats: true)
		
		self.updateTime()
	}
	
	override func viewDidDisappear(_ animated: Bool)
	{
		super.viewDidDisappear(animated)
		
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
		self.updateViews()
	}
	
	func prefsDidUpdate(_ type: UserPrefsManager.PrefsUpdateType)
	{
		self.updateViews()
		self.tableView.setWeekData()
	}
	
	func updateViews()
	{
		self.dayLabel.text = self.dayId.displayName
		self.nextLabel.text = "Next"
		
		let state = ScheduleManager.instance.getCurrentScheduleInfo()

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
			
			self.nextLabel.text = "Next School Day"
			
			self.blockLabel.text = "No Class"

			if let nextDay = ScheduleManager.instance.getNextSchoolday()
			{
				self.nextBlockLabel.text = nextDay.displayName
				
				self.tableOverrideId = nextDay
				self.tableView.showExpiredBlocks = false
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
			self.tableView.updateExpiredBlocks() // Only manually update the expired blocks if the table view wasn't updated.
		}
	}
}

class HomeBlockTableController: UITableView, UITableViewDataSource, UITableViewDelegate
{
	var dayId: DayID?
	
	var labels: [Label] = []
	
	var showExpiredBlocks = true

	func setWeekData()
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
		if let day = self.dayId
		{
			if let blocks = ScheduleManager.instance.blockList(id: day)
			{
				for block in blocks
				{
					let analyst = block.analyst
					
					let finalTime = "\(analyst.getStartTime().toFormattedString()) - \(analyst.getEndTime().toFormattedString())"
					
					let newLabel = Label(bL: analyst.getDisplayLetter(), cN: analyst.getDisplayName(), cT: finalTime, c: analyst.getColor(), rN: analyst.getRoom(), block: block)
					labels.append(newLabel)
				}
			}
		}
	}
	
	func updateExpiredBlocks()
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
			let label = Label(bL: "", cN: "", cT: "", c: "999999", rN: "")
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
	@IBOutlet weak var roomNumber: UILabel!
	
	@IBOutlet weak var viewMask: UIView!
	
	@IBOutlet weak var timeRoomSeparator: UILabel!
	
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
				self.roomNumber.text = label.roomNumber
				self.block = label.block
				
				self.timeRoomSeparator.alpha = (label.roomNumber == "") ? 0.0 : 1.0

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
