//
//  NoClassCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/30/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class NoClassCell: TableCell {
	
	init() {
		super.init("noclass", nib: "NoClassCell")
		
		self.setSelectionStyle(.none)
		
		self.setCallback() {
			template, cell in
			
			guard let noClass = cell as? UINoClassCell else {
				return
			}
			
			noClass.backgroundColor = .clear
			noClass.iconImage.image = noClass.iconImage.image?.withRenderingMode(.alwaysTemplate)
		}
	}
	
}

class UINoClassCell: UITableViewCell {
	
	@IBOutlet weak var iconImage: UIImageView!
	
	
}
