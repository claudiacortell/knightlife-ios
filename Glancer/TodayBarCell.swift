//
//  TodayBarCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/6/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class TodayBarCell: TableCell {
	
	init(color: UIColor, duration: Float) {
		super.init("todaybar", nib: "TodayBarCell")
		
		self.setHeight(2)
		self.setSelectionStyle(.none)
		
		self.setCallback() {
			template, cell in
			
			guard let todayCell = cell as? UITodayBarCell else {
				return
			}
			
			todayCell.backgroundColor = Scheme.dividerColor.color
			todayCell.progressView.backgroundColor = color
			
			let screenWidth = UIScreen.main.bounds.width
			let barWidth = screenWidth * CGFloat(duration)
			
			let trailing = screenWidth - barWidth
			
			todayCell.trailingConstraint.constant = trailing
		}
	}
	
}

class UITodayBarCell: UITableViewCell {
	
	@IBOutlet weak var progressView: UIView!
	@IBOutlet weak var widthView: UIView!
	
	@IBOutlet weak var trailingConstraint: NSLayoutConstraint!
	
}
