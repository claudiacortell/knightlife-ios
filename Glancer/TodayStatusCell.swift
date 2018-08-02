//
//  TodayStatusCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/1/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class TodayStatusCell: TableCell {
	
	init(state: String, minutes: Int, image: UIImage, color: UIColor) {
		super.init("todaystatus", nib: "TodayStatusCell")
		
		self.setSelectionStyle(.none)
		self.setHeight(100)
		
		self.setCallback() {
			template, cell in
			
			guard let todayCell = cell as? UITodayStatusCell else {
				return
			}
			
			todayCell.backgroundColor = .clear
			
			let hours: Int = Int(floor(Double(minutes / 60)))
			let minutes: Int = minutes % 60
			
			todayCell.minutesLabel.text = {
				if hours == 0 && minutes == 0 {
					return "0m"
				} else if hours == 0 {
					return "\(minutes)m"
				} else {
					return "\(hours)h \(minutes)m"
				}
			}()
			
			todayCell.iconImage.image = image.withRenderingMode(.alwaysTemplate)
			todayCell.stateLabel.text = state
			
			todayCell.minutesLabel.textColor = color
			todayCell.iconImage.tintColor = color
			todayCell.stateLabel.textColor = color
		}
	}
	
}

class UITodayStatusCell: UITableViewCell {
	
	@IBOutlet weak var minutesLabel: UILabel!
	@IBOutlet weak var iconImage: UIImageView!
	
	@IBOutlet weak var stateLabel: UILabel!
	
}
