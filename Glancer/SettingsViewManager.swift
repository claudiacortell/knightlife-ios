//
//  SettingsViewManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/2/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation

class SettingsMenuViewController: UITableViewController
{
	@IBOutlet weak var mondaySwitch: UISwitch!
	@IBOutlet weak var tuesdaySwitch: UISwitch!
	@IBOutlet weak var wednesdaySwitch: UISwitch!
	@IBOutlet weak var thursdaySwitch: UISwitch!
	@IBOutlet weak var fridaySwitch: UISwitch!
	
	@IBOutlet weak var aDot: UIView!
	@IBOutlet weak var bDot: UIView!
	@IBOutlet weak var cDot: UIView!
	@IBOutlet weak var dDot: UIView!
	@IBOutlet weak var eDot: UIView!
	@IBOutlet weak var fDot: UIView!
	@IBOutlet weak var gDot: UIView!
	
	var ArrayOfSwitch = [UISwitch]()

	var daySwitches: [DayID: UISwitch] = [:] // First lunch toggle
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.daySwitches[DayID.monday] = self.mondaySwitch
		self.daySwitches[DayID.tuesday] = self.tuesdaySwitch
		self.daySwitches[DayID.wednesday] = self.wednesdaySwitch
		self.daySwitches[DayID.thursday] = self.thursdaySwitch
		self.daySwitches[DayID.friday] = self.fridaySwitch
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(true)
		
		for (day, flip) in self.daySwitches
		{
			if let flop = UserPrefsManager.instance.getSwitch(id: day)
			{
				flip.isOn = flop
			}
		}
	}
	
	@IBAction func switchValChanged(_ send: UISwitch)
	{
		for (dayId, switchButton) in self.daySwitches
		{
			if switchButton === send
			{
				UserPrefsManager.instance.setSwitch(id: dayId, val: send.isOn)
			}
		}
	}
	
	override func viewWillDisappear(_ animated: Bool)
	{
		// If settings changed then reload user prefs.
	}
	
	// transition to color menu
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if let destination = segue.destination as? BlockDetailViewController
		{
			if segue.identifier != nil
			{
				let id = BlockID.fromRaw(raw: segue.identifier!)
				if id != nil
				{
					destination.blockId = id
				}
			}
		}
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

//class BlockDetailViewController: UIViewController
//{
//	@IBOutlet weak var nameField: UITextField!
//
//	var blockId: BlockID!
//
//	func textFieldShouldReturn(_ textField: UITextField) -> Bool
//	{
//		self.view.endEditing(true)
//		return false
//	}
//}

