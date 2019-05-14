//
//  TimeEventAttachmentView.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/14/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class TimeEventAttachmentView: AttachmentView {
	
	fileprivate var timeStack: UIStackView!
	fileprivate var startLabel: UILabel!
	fileprivate var arrowImage: UIImageView!
	fileprivate var endLabel: UILabel!
	
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
		
//		Do time stack setup
		let timeStack = UIStackView()
		self.timeStack = timeStack
		
		timeStack.axis = .horizontal
		timeStack.spacing = 8.0
		timeStack.alignment = .center
		
		self.v_stack.addArrangedSubview(timeStack)
		
//		Set up time views
		self.startLabel = UILabel()
		self.timeStack.addArrangedSubview(self.startLabel)
		
		self.arrowImage = UIImageView(image: UIImage(named: "icon_right")?.withRenderingMode(.alwaysTemplate))
		self.arrowImage.tintColor = UIColor.black.withAlphaComponent(0.4)
		self.timeStack.addArrangedSubview(self.arrowImage)
		
		self.arrowImage.snp.makeConstraints() {
			constrain in
			constrain.width.equalTo(18)
			constrain.height.equalTo(18)
		}

		self.endLabel = UILabel()
		self.timeStack.addArrangedSubview(self.endLabel)

		self.startLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
		self.startLabel.textColor = UIColor.black.withAlphaComponent(0.4)
		
		self.endLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
		self.endLabel.textColor = UIColor.black.withAlphaComponent(0.4)
		
		self.startLabel.setContentHuggingPriority(.required, for: .horizontal)
		self.endLabel.setContentHuggingPriority(.required, for: .horizontal)

		self.setupEvent()
	}
	
	private func setupEvent() {
		if let event = self.event {
			self.text = "\(event.oldCompleteTitle)"
			self.timeStack.isHidden = false
			
			self.startLabel.text = event.schedule.start!.prettyTime
			
			if let end = event.schedule.end {
				self.arrowImage.isHidden = false
				self.endLabel.isHidden = false
				
				self.endLabel.text = end.prettyTime
			} else {
				self.arrowImage.isHidden = true
				self.endLabel.isHidden = true
			}
		} else {
			self.text = nil
			self.timeStack.isHidden = true
		}
	}
	
}
