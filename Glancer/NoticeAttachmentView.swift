//
//  NoticeAttachmentView.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/12/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class NoticeAttachmentView: AttachmentView {
	
	var notice: DateNotice? {
		didSet {
			self.setupNotice()
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
		self.style = .ORANGE
		self.showDisclosure = false
		
		self.leftImage = UIImage(named: "icon_mail")!
		
		self.setupNotice()
	}
	
	private func setupNotice() {
		if self.notice == nil {
			self.text = nil
		} else {
			self.text = "\(self.notice!.priority.displayName): \(self.notice!.message)"
		}
	}
	
}
