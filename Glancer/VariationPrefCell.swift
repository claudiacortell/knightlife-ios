//
//  VariationPrefCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/31/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class VariationPrefCell: TableCell {
	
	let module: VariationPrefsModule
	let weekday: DayOfWeek
	let variation: Int
	
	init(module: VariationPrefsModule, weekday: DayOfWeek, variation: Int) {
		self.module = module
		self.weekday = weekday
		self.variation = variation
		
		super.init("variationpref", nib: "VariationPrefCell")
		
		self.setSelectionStyle(.none)
		self.setHeight(47)
		
		self.setCallback() {
			template, cell in
			
			guard let variationCell = cell as? UIVariationPrefCell else {
				return
			}
			
			variationCell.titleLabel.text = weekday.displayName
			variationCell.variationSwitch.isOn = variation == 1
			
			variationCell.variationSwitch.removeTarget(self, action: #selector(self.switchFlipped(_:)), for: .valueChanged)
			variationCell.variationSwitch.addTarget(self, action: #selector(self.switchFlipped(_:)), for: .valueChanged)
		}
	}
	
	@objc func switchFlipped(_ sender: Any) {
		guard let flip = sender as? UISwitch else {
			return
		}
		
		let variation = flip.isOn ? 1 : 0
		self.module.valueChanged(weekday: self.weekday, variation: variation)
	}
	
}

class UIVariationPrefCell: UITableViewCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var variationSwitch: UISwitch!
	
}
