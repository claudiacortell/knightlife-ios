//
//  TodayDoneCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/30/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class TodayDoneCell: TableCell {
	
	init() {
		super.init("todaydone", nib: "TodayDoneCell")
		
		self.setSelectionStyle(.none)
		
		self.setCallback() {
			template, cell in
			
			guard let done = cell as? UITodayDoneCell else {
				return
			}
			
			cell.backgroundColor = .clear
			done.iconImage.image = done.iconImage.image?.withRenderingMode(.alwaysTemplate)
		}
	}
	
}

class UITodayDoneCell: UITableViewCell {
	
	@IBOutlet weak var iconImage: UIImageView!
	
}
