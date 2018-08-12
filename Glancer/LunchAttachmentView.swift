//
//  LunchAttachmentView.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/26/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class LunchAttachmentView: AttachmentView {
	
	private var menuName: String?
	
	init(menuName: String? = nil) {
		super.init()
		
		self.menuName = menuName
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
		self.style = .BLUE
		
		if let name = self.menuName {
			self.text = "\(name) menu available"
		} else {
			self.text = "Lunch menu available"
		}
		
		self.leftImage = UIImage(named: "icon_bell")!
		
		self.showDisclosure = true
		self.enableClicks()
	}
}
