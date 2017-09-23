//
//  ViewController.swift
//  Glancer
//
//  Created by Vishnu Murale on 5/13/15.
//  Copyright (c) 2015 Vishnu Murale. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate
{
	// Week switches
	@IBOutlet weak var Blue: UIView!
    @IBOutlet weak var M: UISwitch!
    @IBOutlet weak var T: UISwitch!
    @IBOutlet weak var W: UISwitch!
    @IBOutlet weak var Th: UISwitch!
    @IBOutlet weak var F: UISwitch!
	
    @IBOutlet weak var blockViewTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var blockViewBottomConstraint: NSLayoutConstraint!
	
	// Block field names
    @IBOutlet var Gblock: UITextField!
    @IBOutlet var Fblock: UITextField!
    @IBOutlet var Eblock: UITextField!
    @IBOutlet var Dblock: UITextField!
    @IBOutlet var Ablock: UITextField!
    @IBOutlet var Bblock: UITextField!
    @IBOutlet var Cblock: UITextField!
	
	// Color buttons
    @IBOutlet weak var AColorButton: UIButton!
    @IBOutlet weak var BColorButton: UIButton!
    @IBOutlet weak var CColorButton: UIButton!
    @IBOutlet weak var DColorButton: UIButton!
    @IBOutlet weak var EColorButton: UIButton!
    @IBOutlet weak var FColorButton: UIButton!
    @IBOutlet weak var GColorButton: UIButton!
	
    var ArrayOfField = [UITextField]()
    var ArrayOfSwitch = [UISwitch]()
    var ArrayOfButton = [UIButton]()
	
	var blockTextFields: [BlockID: UITextField] = [:] // Block text name
	var blockColorButtons: [BlockID: UIButton] = [:] // Block color button
	var daySwitches: [DayID: UISwitch] = [:] // First lunch toggles
	
	struct BlockElements
	{
		var textField: UITextField!
		var colorButton: UIButton!
	}
	
    var timer = Timer();
	
    override func viewDidLoad()
	{
        super.viewDidLoad()
		
        //this actauly holds the UI elements, you will make these prgramtically but add the "UITextField" to "ArrayOfField"
		self.blockTextFields[BlockID.a] = Ablock
		self.blockTextFields[BlockID.b] = Bblock
		self.blockTextFields[BlockID.c] = Cblock
		self.blockTextFields[BlockID.d] = Dblock
		self.blockTextFields[BlockID.e] = Eblock
		self.blockTextFields[BlockID.f] = Fblock
		self.blockTextFields[BlockID.g] = Gblock
		
		self.blockColorButtons[BlockID.a] = AColorButton
		self.blockColorButtons[BlockID.b] = BColorButton
		self.blockColorButtons[BlockID.c] = CColorButton
		self.blockColorButtons[BlockID.d] = DColorButton
		self.blockColorButtons[BlockID.e] = EColorButton
		self.blockColorButtons[BlockID.f] = FColorButton
		self.blockColorButtons[BlockID.g] = GColorButton
		
		self.daySwitches[DayID.monday] = M
		self.daySwitches[DayID.tuesday] = T
		self.daySwitches[DayID.wednesday] = W
		self.daySwitches[DayID.thursday] = Th
		self.daySwitches[DayID.friday] = F
		
		for textField in self.blockTextFields.values
		{
			textField.delegate = self
		}		
    }
    
    override func viewWillAppear(_ animated: Bool)
	{
        super.viewWillAppear(true)
		
		for (block, field) in self.blockTextFields
		{
			if let meta = UserPrefsManager.instance.getMeta(id: block)
			{
				field.text = meta.customName
			}
		}
		
		for (block, button) in self.blockColorButtons
		{
			if let meta = UserPrefsManager.instance.getMeta(id: block)
			{
				let rgb = Utils.getRGBFromHex(meta.customColor)
				button.backgroundColor = UIColor(red: (rgb[0] / 255.0), green: (rgb[1] / 255.0), blue: (rgb[2] / 255.0), alpha: 1)
			}
		}
		
		for (day, flip) in self.daySwitches
		{
			if let flop = UserPrefsManager.instance.getSwitch(id: day)
			{
				flip.isOn = flop
			}
		}
	}
    
    func textFieldDidBeginEditing(_ textField: UITextField)
	{
        if textField.isEqual(Dblock)
		{
            self.setViewMovedUp(true)
        } else if textField.isEqual(Eblock)
		{
            self.setViewMovedUp(true)
        } else if textField.isEqual(Fblock)
		{
            self.setViewMovedUp(true)
        } else if textField.isEqual(Gblock)
		{
            self.setViewMovedUp(true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
	{
		for (block, field) in self.blockTextFields
		{
			if field === textField
			{
				if var meta = UserPrefsManager.instance.getMeta(id: block)
				{
					meta.customName = textField.text
					UserPrefsManager.instance.setMeta(id: block, meta: meta)
					break
				}
			}
		}
		
		//If it isn't count as one of the block fields
		self.setViewMovedUp(false)
    }
    
    func setViewMovedUp(_ movedUp: Bool)
	{
        if (movedUp)
		{
            self.blockViewTopConstraint.constant = -216
            self.blockViewBottomConstraint.constant = 216
        } else
		{
            self.blockViewTopConstraint.constant = 0
            self.blockViewBottomConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
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
		if let destination = segue.destination as? ColorSelectionViewController
		{
			if segue.identifier != nil
			{
				let id = BlockID.fromRaw(raw: segue.identifier!)
				if id != nil
				{
					destination.block = id
				}
			}
		}
    }
	
    override func didReceiveMemoryWarning()
	{
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
        self.view.endEditing(true)
        return false
    }
}
