//
//  PrefsActionCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/31/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class PrefsActionCell: TableCell {
	
	let title: String
	let image: UIImage
	let action: () -> Void
	
	init(title: String, image: UIImage, action: @escaping () -> Void) {
		self.title = title
		self.image = image
		self.action = action
		
		super.init("prefsaction", nib: "PrefsActionCell")
		
		self.setEstimatedHeight(32)
		self.setSelectionStyle(.none)
		
		self.setCallback() {
			template, cell in
			
			guard let prefsCell = cell as? UIPrefsActionCell else {
				return
			}
			
			prefsCell.backgroundColor = UIColor.clear
		
			prefsCell.actionButton.setTitle(self.title.uppercased(), for: .normal)
			prefsCell.actionButton.setImage(self.image.withRenderingMode(.alwaysTemplate), for: .normal)
			
			prefsCell.actionButton.removeTarget(self, action: #selector(self.onClick(_:)), for: .touchUpInside)
			prefsCell.actionButton.addTarget(self, action: #selector(self.onClick(_:)), for: .touchUpInside)
		}
	}
	
	@objc func onClick(_ sender: Any) {
		self.action()
	}
	
}

class UIPrefsActionCell: UITableViewCell {
	
	@IBOutlet weak var actionButton: UIButton!
	
}
