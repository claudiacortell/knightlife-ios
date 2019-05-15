//
//  InClassView.swift
//  TodayWidget
//
//  Created by Dylan Hanson on 8/10/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class InClassView: CustomView {
	
	@IBOutlet var backgroundView: UIView!
	
	@IBOutlet weak var minuteLabel: UILabel!
	@IBOutlet weak var statusIconImage: UIImageView!
	@IBOutlet weak var statusLabel: UILabel!
	
	@IBOutlet weak var blockImage: UIImageView!
	@IBOutlet weak var blockLabel: UILabel!
	
	@IBOutlet weak var statusBarView: UIView!
	@IBOutlet weak var statusBarTrailingConstraint: NSLayoutConstraint!
	
	var percentage: Float!
	
	var color: UIColor! {
		didSet {
//			self.minuteLabel.textColor = self.color
//			self.statusIconImage.tintColor = self.color
//			self.statusLabel.textColor = self.color
			self.statusBarView.backgroundColor = self.color
		}
	}
	
	let schedule: Schedule!
	let block: Block!
	let minutes: Int!
	
	init(schedule: Schedule!, block: Block, minutes: Int) {
		self.schedule = schedule
		self.block = block
		self.minutes = minutes
		
		super.init(frame: CGRect.zero)
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.schedule = nil
		self.block = nil
		self.minutes = nil
		
		super.init(coder: aDecoder)
	}
	
	override func loadNib() {
		Bundle.main.loadNibNamed("InClassView", owner: self, options: nil)
		self.secure(view: self.backgroundView)
		
		let analyst = BlockAnalyst(schedule: self.schedule, block: self.block)
		
		self.statusIconImage.image = self.statusIconImage.image?.withRenderingMode(.alwaysTemplate)
		self.blockImage.image = self.blockImage.image?.withRenderingMode(.alwaysTemplate)

		self.blockLabel.text = "\(self.block.id.displayName)"
		self.statusLabel.text = "in \(analyst.getDisplayName())"
		self.minuteLabel.text = {
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
		
		let secondPassed = Calendar.normalizedCalendar.dateComponents([.second], from: self.block.time.start, to: Date.today).second!
		let secondDuration = Calendar.normalizedCalendar.dateComponents([.second], from: self.block.time.start, to: self.block.time.end).second!
		
		let secondsLeft = secondDuration - secondPassed
		
		let percentage = Float(secondsLeft) / Float(secondDuration)
		self.percentage = percentage
		
		self.color = analyst.getColor()
	}
	
	override func willMove(toSuperview newSuperview: UIView?) {
		if newSuperview != nil {
			self.statusBarTrailingConstraint.constant = (newSuperview!.bounds.size.width * CGFloat(percentage))
		}
	}
	
}
