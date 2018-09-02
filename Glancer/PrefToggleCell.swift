//
//  PrefToggleCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class PrefToggleCell: TableCell {
	
	var personalSwitch: UISwitch!
	let flipped: (Bool) -> Void
	
	init(title: String, on: Bool, flipped: @escaping (Bool) -> Void) {
		self.flipped = flipped
		
		super.init("preftoggle", nib: "PrefToggleCell")
		
		self.setSelectionStyle(.none)
		self.setHeight(47)
		
		self.setCallback() {
			template, cell in
			
			guard let toggleCell = cell as? UIPrefToggleCell else {
				return
			}
			
			toggleCell.title.text = title
			
			self.personalSwitch = toggleCell.switch
			toggleCell.switch.removeTarget(self, action: #selector(self.switchFlipped(_:)), for: .valueChanged)
			toggleCell.switch.addTarget(self, action: #selector(self.switchFlipped(_:)), for: .valueChanged)
			
			toggleCell.switch.isOn = on
		}
	}
	
	@objc func switchFlipped(_ sender: Any) {
		if let senderSwitch = sender as? UISwitch, senderSwitch !== self.personalSwitch {
			return
		}
		
		if let flip = sender as? UISwitch {
			self.flipped(flip.isOn)
		}
	}
	
}

class UIPrefToggleCell: UITableViewCell {
	
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var `switch`: UISwitch!
	
}
