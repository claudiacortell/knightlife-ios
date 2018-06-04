//
//  BlockFooterTableViewCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 5/22/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import Charcore

class BlockFooterTableViewCell: UITableViewCell {
	
	@IBOutlet weak private var roomLabel: UILabel!
	@IBOutlet weak private var teacherLabel: UILabel!
	@IBOutlet weak private var progressView: UIProgressView!
	
	var room: String? {
		didSet {
			self.roomLabel.text = self.room
		}
	}
	
	var teacher: String? {
		didSet {
			self.teacherLabel.text = self.teacher
		}
	}
	
	var progress: Float = 0.0 {
		didSet {
			self.progressView.progress = self.progress
		}
	}
	
}
