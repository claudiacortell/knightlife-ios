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
	
	var color: UIColor! {
		didSet {
			self.minuteLabel.tintColor = self.color
			self.statusIconImage.tintColor = self.color
			self.statusLabel.tintColor = self.color
			self.statusBarView.backgroundColor = self.color
		}
	}
	
	let schedule: DateSchedule!
	let block: Block!
	let minutes: Int!
	
	init(schedule: DateSchedule!, block: Block, minutes: Int) {
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
		
		let percentage = Float(self.minutes) / Float(self.block.time.duration())
		self.statusBarTrailingConstraint.constant = (self.superview!.bounds.size.width * CGFloat(percentage))
		
		self.color = analyst.getColor()
	}
	
}
