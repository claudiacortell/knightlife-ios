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
	
	var onClick: () -> Void = {}
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
		self.style = .INFO
		self.showDisclosure = true
		
		if let name = self.menuName {
			self.text = "\(name) menu available"
		} else {
			self.text = "Lunch menu available"
		}
		
		self.leftImage = UIImage(named: "icon_bell")!
		
		let clickRecognizer = LunchGestureRecognizer(target: self, action: #selector(handleClick(_:)))
		self.addGestureRecognizer(clickRecognizer)
	}
	
	@objc func handleClick(_ recognizer: UIGestureRecognizer) {
		self.onClick()
	}
	
}

fileprivate class LunchGestureRecognizer: UITapGestureRecognizer {
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesBegan(touches, with: event)
		
		if let view = self.view as? LunchAttachmentView {
			view.backgroundColor = view.style.color.withAlphaComponent(0.25)
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesEnded(touches, with: event)
		self.animateEnd()
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesCancelled(touches, with: event)
		self.animateEnd()
	}
	
	private func animateEnd() {
		if let view = self.view as? LunchAttachmentView {
			UIView.animate(withDuration: 0.25) {
				view.backgroundColor = view.style.color
			}
		}
	}
	
}
