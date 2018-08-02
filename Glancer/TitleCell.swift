//
//  TitleCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/30/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class TitleCell: TableCell {
	
	init(title: String, alignment: NSTextAlignment = NSTextAlignment.natural) {
		super.init("title", nib: "TitleCell")
		
		self.setSelectionStyle(.none)
		self.setHeight(30)
		
		self.setCallback() {
			template, cell in
			
			guard let titleCell = cell as? UITitleCell else {
				return
			}
			
			titleCell.titleLabel.text = title
			cell.backgroundColor = Scheme.backgroundMedium.color
			
			titleCell.titleLabel.textAlignment = alignment
		}
	}
	
}

class UITitleCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	
}
