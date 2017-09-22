//
//  WeekTableViewController.swift
//  Glancer
//
//  Created by Cassandra Kane on 12/30/15.
//  Copyright © 2015 Vishnu Murale. All rights reserved.
//

import UIKit

class WeekTableViewController: UITableViewController, ScheduleUpdateHandler, PrefsUpdateHandler
{
	var firstOpen = true
	
    var timer = Timer()
    
    @IBOutlet weak var segControl: UISegmentedControl!
	
	private var _dayId: DayID = .monday
	var dayId: DayID
	{
		get
		{
			return self._dayId
		}
		set
		{
			self._dayId = newValue
			self.generateWeekData()
		}
	}

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
			
			self.generateWeekData()
		}
		
		self.firstOpen = false
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    
    @IBAction func segControlChanged(_ sender: AnyObject)
	{
		self.dayId = DayID.fromId(segControl.selectedSegmentIndex)!
    }
    
    func generateWeekData()
	{
        if (ScheduleManager.instance.scheduleLoaded)
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
		
		self.tableView.reloadData()
	}
	
    func generateLabels()
	{
		if let blocks = ScheduleManager.instance.blockList(id: self.dayId)
		{
			for block in blocks
			{
				let analyst = block.analyst
				
				let finalTime = "\(analyst.getStartTime().toFormattedString()) - \(analyst.getEndTime().toFormattedString())"
				
				let newLabel = Label(bL: analyst.getDisplayLetter(), cN: analyst.getDisplayNameWithBlock(), cT: finalTime, c: analyst.getColor())
				labels.append(newLabel)
			}
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
