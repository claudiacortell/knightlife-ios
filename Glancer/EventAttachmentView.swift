//
//  EventAttachmentView.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/26/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class EventAttachmentView: AttachmentView {
	
	var event: Event? {
		didSet {
			self.setupEvent()
		}
	}
	
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
		self.style = .YELLOW
		self.showDisclosure = false
		
		self.leftImage = UIImage(named: "icon_alert")!
		
		self.setupEvent()
	}
	
	private func setupEvent() {
		if self.event == nil {
			self.text = nil
		} else {
			self.text = "\(self.event!.oldCompleteTitle)"
		}
	}
	
}
