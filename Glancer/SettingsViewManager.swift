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
	
	var daySwitches: [DayID: UISwitch] = [:] // First lunch toggle
	var blockDots: [BlockID: UIView] = [:] // First lunch toggle
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.daySwitches[DayID.monday] = self.mondaySwitch
		self.daySwitches[DayID.tuesday] = self.tuesdaySwitch
		self.daySwitches[DayID.wednesday] = self.wednesdaySwitch
		self.daySwitches[DayID.thursday] = self.thursdaySwitch
		self.daySwitches[DayID.friday] = self.fridaySwitch
		
		self.blockDots[BlockID.a] = self.aDot
		self.blockDots[BlockID.b] = self.bDot
		self.blockDots[BlockID.c] = self.cDot
		self.blockDots[BlockID.d] = self.dDot
		self.blockDots[BlockID.e] = self.eDot
		self.blockDots[BlockID.f] = self.fDot
		self.blockDots[BlockID.g] = self.gDot
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		
		super.viewWillAppear(true)
		
		for (day, flip) in self.daySwitches
		{
			if let flop = UserPrefsManager.instance.getSwitch(id: day)
			{
				flip.isOn = flop
			}
		}
		
		for (block, view) in self.blockDots
		{
			if let meta = UserPrefsManager.instance.getMeta(id: block)
			{
				view.layer.backgroundColor = Utils.getUIColorFromHex(meta.customColor).cgColor
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
		super.viewWillDisappear(animated)
		// If settings changed then reload user prefs.
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if let destination = segue.destination as? SettingsDetailPageViewController
		{
			if segue.identifier != nil
			{
				Debug.out("Segue identifier: \(segue.identifier!)")
				let id = BlockID.fromRaw(raw: segue.identifier!)
				if id != nil
				{
					destination.blockId = id
				}
			} else
			{
				Debug.out("No identifier found for segue.")
			}
		} else
		{
			Debug.out("No destination found.")
		}
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

class SettingsDetailPageViewController: UIViewController
{
	var blockId: BlockID!
	
	@IBOutlet weak var navBar: UINavigationBar!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		if let tableView = self.getTableView()
		{
			tableView.blockId = self.blockId
		}
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		
		self.navBar.topItem?.title = "\(self.blockId.rawValue) Block"
	}
	
	func getTableView() -> BlockDetailMenuViewController?
	{
		for controller in self.childViewControllers
		{
			if let blockController = controller as? BlockDetailMenuViewController
			{
				return blockController
			}
		}
		return nil
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if segue.identifier == "home"
		{
			if let tabBar = segue.destination as? UITabBarController
			{
				tabBar.selectedIndex = 3
			}
		}
	}
}

class BlockDetailMenuViewController: UITableViewController, UITextFieldDelegate, UIGestureRecognizerDelegate
{
	var blockId: BlockID!
	var colorBlocks: [ColorBlockView] = []
	
	@IBOutlet weak var classNameField: UITextField!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
	
		self.classNameField.delegate = self
	}
	
    @IBAction func blockTapped(_ sender: Any)
    {
        if let button = sender as? UIButton
        {
            if let view = button.superview as? ColorBlockView
            {
                let color = view.getColorHex()
                if var meta = UserPrefsManager.instance.getMeta(id: self.blockId)
                {
                    if meta.customColor != color
                    {
                        meta.customColor = color
                        UserPrefsManager.instance.setMeta(id: self.blockId, meta: &meta)
                        
                        self.updateVisuals()
                    }
                }
            }
        }
    }
    
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		
		if self.colorBlocks.isEmpty
		{
			for cell in self.tableView.visibleCells
			{
				if let colorCell = cell as? BlockDetailMenuColorCell
				{
					colorCell.blockId = self.blockId
					for block in colorCell.getColorBlocks()
					{
						self.colorBlocks.append(block)
					}
				}
			}
		}
		
		self.updateVisuals()
	}
	
	private func updateVisuals()
	{
		if let meta = UserPrefsManager.instance.getMeta(id: self.blockId)
		{
			if let name = meta.customName
			{
				self.classNameField.text = name
			} else
			{
				self.classNameField.text = nil
			}
			
            for color in self.colorBlocks
			{
				if color.getColorHex() == Utils.substring(meta.customColor, StartIndex: 0, EndIndex: 6) // Account for the old system's weird tagging
				{
					color.setShadow(on: true)
				} else
                {
                    color.setShadow(on: false)
                }
			}
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField)
	{
		if var meta = UserPrefsManager.instance.getMeta(id: self.blockId)
		{
			meta.customName = textField.text
			UserPrefsManager.instance.setMeta(id: blockId, meta: &meta)
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		self.classNameField.endEditing(true)
		return false
	}
}

class BlockDetailMenuColorCell: UITableViewCell
{
	var blockId: BlockID!
	
	func getColorBlocks() -> [ColorBlockView]
	{
		var arr: [ColorBlockView] = []
		
		for view in self.subviews
		{
			for view2 in view.subviews // Get all the sub-subviews within the cell content.
			{
				if let block = view2 as? ColorBlockView
				{
					arr.append(block)
				}
			}
		}
		return arr
	}
}

class ColorBlockView: UIView
{
    var colorHex: String?
    
	func getColor() -> CGColor?
	{
		return self.layer.backgroundColor
	}
	
	func getColorHex() -> String?
	{
        if self.colorHex != nil
        {
            return self.colorHex
        }
        
		if let col = self.getColor()
		{
			return Utils.getHexFromCGColor(col)
		}
		return nil
	}
	
	func setShadow(on: Bool)
	{
		if let shadow = getShadow()
		{
            shadow.alpha = on ? 0.1 : 0.0
		}
	}
	
	func getShadow() -> ColorBlockShadowView?
	{
		for view in self.subviews
		{
			if let shadow = view as? ColorBlockShadowView
			{
				return shadow
			}
		}
		return nil
	}
}

class ColorBlockShadowView: UIView {  }
