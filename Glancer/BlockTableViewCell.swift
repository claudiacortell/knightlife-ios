//
//  BlockTableViewCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 5/13/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import UIKit
import AddictiveLib

class BlockTableViewCell: UITableViewCell {

	@IBOutlet weak private var markerBackground: UIView!
	@IBOutlet weak private var markerLabel: UILabel!
	
	@IBOutlet weak private var titleLabel: UILabel!
	@IBOutlet weak private var timeLabel: UILabel!
	
	@IBOutlet weak private var moreButton: UIButton!
	
	var title: String? {
		didSet {
			self.titleLabel.text = self.title
		}
	}
	
	var timeRange: TimeDuration? {
		didSet {
			if self.timeRange == nil { self.timeLabel.text = "" }
			else { self.timeLabel.text = "\(self.timeRange!.startTime.toString()) - \(self.timeRange!.endTime.toString())" }
		}
	}
	
	var letter: String? {
		didSet {
			self.markerLabel.text = self.letter
		}
	}
	
	var color: String = "777777" {
		didSet {
			self.markerBackground.backgroundColor = UIColor(hex: self.color)
			self.titleLabel.textColor = UIColor(hex: self.color)
		}
	}
	
	var moreLabel: String? {
		didSet {
			self.moreButton.isHidden = self.moreLabel == nil
			self.moreButton.setTitle(self.moreLabel, for: .normal)
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.title = nil
		self.timeRange = nil
		self.letter = nil
		self.color = "777777"
		self.moreLabel = nil
	}
}
