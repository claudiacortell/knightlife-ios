//
//  LunchPrefsCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/31/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class LunchPrefsCell: TableCell {
	
	let module: LunchPrefsModule
	
	init(module: LunchPrefsModule, show: Bool) {
		self.module = module
		
		super.init("lunchprefs", nib: "LunchPrefsCell")
		
		self.setSelectionStyle(.none)
		self.setHeight(47)
		
		self.setCallback() {
			template, cell in
			
			guard let lunchCell = cell as? UILunchPrefsCell else {
				return
			}
			
			lunchCell.switch.removeTarget(self, action: #selector(self.switchFlipped(_:)), for: .valueChanged)
			lunchCell.switch.addTarget(self, action: #selector(self.switchFlipped(_:)), for: .valueChanged)
			
			lunchCell.switch.isOn = show
		}
	}
	
	@objc func switchFlipped(_ sender: Any) {
		if let flip = sender as? UISwitch {
			self.module.valueChanged(bool: flip.isOn)
		}
	}
	
}

class UILunchPrefsCell: UITableViewCell {
	
	@IBOutlet weak var `switch`: UISwitch!
	
}
