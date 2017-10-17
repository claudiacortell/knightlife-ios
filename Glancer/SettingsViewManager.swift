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
	@IBOutlet weak var eventsDot: UIView!
	
	@IBOutlet weak var aName: UILabel!
	@IBOutlet weak var bName: UILabel!
	@IBOutlet weak var cName: UILabel!
	@IBOutlet weak var dName: UILabel!
	@IBOutlet weak var eName: UILabel!
	@IBOutlet weak var fName: UILabel!
	@IBOutlet weak var gName: UILabel!
	
	var daySwitches: [DayID: UISwitch] = [:] // First lunch toggle
	var blockDots: [BlockID: UIView] = [:] // First lunch toggle
	var blockNames: [BlockID: UILabel] = [:] // Block names view
	
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
		self.blockDots[BlockID.custom] = self.eventsDot
		
		self.blockNames[BlockID.a] = self.aName
		self.blockNames[BlockID.b] = self.bName
		self.blockNames[BlockID.c] = self.cName
		self.blockNames[BlockID.d] = self.dName
		self.blockNames[BlockID.e] = self.eName
		self.blockNames[BlockID.f] = self.fName
		self.blockNames[BlockID.g] = self.gName
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		
		self.updateVisuals()
	}
	
	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)
		
		self.updateVisuals()
	}
	
	private func updateVisuals()
	{
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
		
		for (block, field) in self.blockNames
		{
			if let meta = UserPrefsManager.instance.getMeta(id: block)
			{
				if meta.customName != nil
				{
					field.text = meta.customName
				}
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
}

class SettingsDetailPageViewController: UIViewController
{
	var blockId: BlockID!
	
	@IBOutlet weak var titleText: UILabel!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		if let tableView = self.getTableView()
		{
			tableView.blockId = self.blockId
		}
	}
	
	@IBAction func returnButtonClicked(_ sender: Any)
	{
		self.navigationController?.popViewController(animated: true)		
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		
		if self.blockId == .custom
		{
			self.titleText.text = "Events"
		} else
		{
			self.titleText.text = "\(self.blockId.rawValue) Block"
		}
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
}

class BlockDetailMenuViewController: UITableViewController, UITextFieldDelegate
{
	var blockId: BlockID!
	
	var selectedColorChanged = false
	var selectedColor: String?
	
	@IBOutlet weak var classNameField: UITextField!
	@IBOutlet weak var roomField: UITextField!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
	
		if self.classNameField != nil && self.roomField != nil
		{
			self.classNameField.delegate = self
			self.roomField.delegate = self
		}
	}
	
	override func viewWillDisappear(_ animated: Bool)
	{
		if self.selectedColorChanged && self.selectedColor != nil
		{
			if var meta = UserPrefsManager.instance.getMeta(id: self.blockId)
			{
				meta.customColor = self.selectedColor
				UserPrefsManager.instance.setMeta(id: self.blockId, meta: &meta)
			}
		}
	}
	
    @IBAction func blockTapped(_ sender: Any)
    {
        if let button = sender as? UIButton
        {
            if let view = button.superview as? ColorBlockView
            {
                let color = view.getColorHex()
				if color != nil
				{
					if self.selectedColor != color
					{
						self.selectedColor = color
						self.selectedColorChanged = true
						
						self.updateVisuals()
					}
				}
            }
        }
    }
    
	override func viewWillAppear(_ animated: Bool)
	{
		if let meta = UserPrefsManager.instance.getMeta(id: self.blockId)
		{
			self.selectedColor = meta.customColor
			if self.classNameField != nil && meta.customName != nil
			{
				self.classNameField.text = meta.customName
			}
			if self.roomField != nil && meta.roomNumber != nil
			{
				self.roomField.text = meta.roomNumber!
			}
			self.updateVisuals()
		}
	}
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
	{
		if let colorCell = cell as? BlockDetailMenuColorCell
		{
			for block in colorCell.getColorBlocks()
			{
				block.setShadow(on: block.colorHex == self.selectedColor)
			}
		}
	}
	
	private func updateVisuals()
	{
		for cell in self.tableView.visibleCells
		{
			if let colorCell = cell as? BlockDetailMenuColorCell
			{
				for block in colorCell.getColorBlocks()
				{
					block.setShadow(on: block.colorHex == self.selectedColor)
				}
			}
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField)
	{
		if textField == self.classNameField || textField == self.roomField
		{
			if var meta = UserPrefsManager.instance.getMeta(id: self.blockId)
			{
				if textField == self.classNameField
				{
					meta.customName = textField.text
				} else if textField == self.roomField
				{
					meta.roomNumber = textField.text
				}
				
				UserPrefsManager.instance.setMeta(id: blockId, meta: &meta)
			}
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		textField.endEditing(true)
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
    @objc var colorHex: String? // Set in the runtime variables
	
	func getColorHex() -> String?
	{
        if self.colorHex != nil
        {
            return self.colorHex
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
