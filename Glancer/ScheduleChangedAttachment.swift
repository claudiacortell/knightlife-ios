//
//  ScheduleChangedAttachment.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/12/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class ScheduleChangedAttachment: AttachmentView {

	override init() {
		super.init()
		self.setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}
	
	private func setup() {
		self.style = .RED
		self.showDisclosure = false
		
		self.leftImage = UIImage(named: "icon_clock")!
		
		self.text = "Special schedule"
	}
	
}
