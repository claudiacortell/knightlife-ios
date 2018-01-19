//
//  WeekViewManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 9/23/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation
import UIKit

class WeekViewController: UIViewController, ScheduleUpdateHandler, PrefsUpdateHandler
{
	@IBOutlet weak var segControl: UISegmentedControl!
	@IBOutlet weak var tableView: WeekBlockTableController!
	@IBOutlet weak var dayLabel: UILabel!
	@IBOutlet weak var noSchoolLabel: UILabel!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.tableView.delegate = self.tableView!
		self.tableView.dataSource = self.tableView!
		
		ScheduleManager.instance.addHandler(self)
		UserPrefsManager.instance.addHandler(self)
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		
		self.updateLabel()
		self.tableView.setWeekData()
	}
	
	@IBAction func segControlChanged(_ sender: AnyObject)
	{
		self.updateLabel()
		self.tableView.dayIndexChanged(new: segControl.selectedSegmentIndex)
	}
	
	func scheduleDidUpdate(didUpdateSuccessfully: Bool)
	{
		self.tableView.setWeekData()
	}
	
	func prefsDidUpdate(_ type: UserPrefsManager.PrefsUpdateType)
	{
		self.tableView.setWeekData()
	}
	
	func updateLabel()
	{
		let day = DayID.fromId(segControl.selectedSegmentIndex)!
		
		self.dayLabel.text = day.displayName
		
		if !ScheduleManager.instance.dayLoaded(id: day) && ScheduleManager.instance.attemptedLoad
		{
			self.noSchoolLabel.isHidden = false
		} else
		{
			self.noSchoolLabel.isHidden = true
		}
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
	
	@IBOutlet weak var timeRoomSeparator: UILabel!
	
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
				
				self.timeRoomSeparator.alpha = (label.roomNumber == "") ? 0.0 : 1.0
				
				let RGBvalues = Utils.getRGBFromHex(label.color)
				
				self.bodyView.backgroundColor = UIColor(red: (RGBvalues[0] / 255.0), green: (RGBvalues[1] / 255.0), blue: (RGBvalues[2] / 255.0), alpha: 1)
			}
		}
	}
}
