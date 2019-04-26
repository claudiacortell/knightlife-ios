//
//  BeforeSchoolView.swift
//  TodayWidget
//
//  Created by Dylan Hanson on 8/10/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class BeforeSchoolView: CustomView {
	
	@IBOutlet var backgroundView: UIView!
	@IBOutlet weak var minutesLabel: UILabel!
	
	let minutes: Int!
	
	init(schedule: Schedule!, block: Block, minutes: Int) {
		self.minutes = minutes
		
		super.init(frame: CGRect.zero)
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.minutes = nil
		
		super.init(coder: aDecoder)
	}
	
	override func loadNib() {
		Bundle.main.loadNibNamed("BeforeSchoolView", owner: self, options: nil)
		self.secure(view: self.backgroundView)

		self.minutesLabel.text = {
			let hours: Int = Int(floor(Double(self.minutes / 60)))
			let minutes: Int = self.minutes % 60
			
			if hours == 0 && minutes == 0 {
				return "0m"
			} else if hours == 0 {
				return "\(minutes)m"
			} else {
				return "\(hours)h \(minutes)m"
			}
		}()
	}
	
}
