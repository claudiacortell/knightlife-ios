//
//  WeekViewManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/23/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation

class WeekViewController: UIViewController, ScheduleUpdateHandler, PrefsUpdateHandler
{
	@IBOutlet weak var segControl: UISegmentedControl!
	@IBOutlet weak var tableView: WeekBlockTableController!
	@IBOutlet weak var dayLabel: UILabel!
	
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
			
			self.scheduleUpdated = false
			self.settingsUpdated = false
			
			self.updateLabel()
			self.tableView.setWeekData()
		}
		
		self.firstOpen = false
	}
	
	override func viewDidAppear(_ animated: Bool)
	{
		if self.scheduleUpdated || self.settingsUpdated
		{
			self.scheduleUpdated = false
			self.settingsUpdated = false
			
			self.updateLabel()
			self.tableView.setWeekData()
		}
	}
	
	@IBAction func segControlChanged(_ sender: AnyObject)
	{
		self.updateLabel()
		self.tableView.dayIndexChanged(new: segControl.selectedSegmentIndex)
	}
	
	func scheduleDidUpdate(didUpdateSuccessfully: Bool)
	{
		if self.isViewLoaded && didUpdateSuccessfully
		{
			self.tableView.setWeekData()
		} else
		{
			self.scheduleUpdated = didUpdateSuccessfully
		}
	}
	
	func prefsDidUpdate(_ type: UserPrefsManager.PrefsUpdateType)
	{
		if self.isViewLoaded
		{
			self.tableView.setWeekData()
		} else
		{
			self.settingsUpdated = true
		}
	}
	
	func updateLabel()
	{
		self.dayLabel.text = DayID.fromId(segControl.selectedSegmentIndex)!.displayName
	}
}

class WeekBlockTableController: UITableView, UITableViewDataSource, UITableViewDelegate
{
	var labels: [Label] = []

	private var dayId: DayID = .monday
	
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
	
	func dayIndexChanged(new: Int)
	{		
		self.dayId = DayID.fromId(new)!
		self.setWeekData()
	}
	
	func generateLabels()
	{
		if let blocks = ScheduleManager.instance.blockList(id: self.dayId)
		{
			for block in blocks
			{
				let analyst = block.analyst
				
				let finalTime = "\(analyst.getStartTime().toFormattedString()) - \(analyst.getEndTime().toFormattedString())"
				
				let newLabel = Label(bL: analyst.getDisplayLetter(), cN: analyst.getDisplayName(), cT: finalTime, c: analyst.getColor(), rN: analyst.getRoom())
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
			let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeekBlockCell
			let label = labels[(indexPath as NSIndexPath).row]
			cell.label = label
			
			return cell
		} else
		{
			let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeekBlockCell
			let label = Label(bL: "", cN: "", cT: "", c: "999999", rN: "")
			cell.label = label
			
			return cell
		}
	}
}

class WeekBlockCell: UITableViewCell
{
	@IBOutlet weak var blockLetter: UILabel!
	@IBOutlet weak var className: UILabel!
	@IBOutlet weak var classTimes: UILabel!
	@IBOutlet weak var bodyView: UIView!
	@IBOutlet weak var roomName: UILabel!
	
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
				self.roomName.text = label.roomNumber
				let RGBvalues = Utils.getRGBFromHex(label.color)
				
				self.bodyView.backgroundColor = UIColor(red: (RGBvalues[0] / 255.0), green: (RGBvalues[1] / 255.0), blue: (RGBvalues[2] / 255.0), alpha: 1)
			}
		}
	}
}
