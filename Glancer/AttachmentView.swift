//
//  AttachmentView.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/26/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

enum AttachmentStyle {
	
	case BLUE
	case YELLOW
	case GREEN
	case RED
	case ORANGE
	
	var color: UIColor {
		switch self {
		case .BLUE: // Blue
			return UIColor(hex: "E4F1FE")!
		case .YELLOW: // Yellow
			return UIColor(hex: "FFF0CC")!
		case .GREEN: // Green
			return UIColor(hex: "D9F2EB")!
		case .RED:
			return UIColor(hex: "FFD3C9")!
		case .ORANGE:
			return UIColor(hex: "FFDEB7")!
		}
	}
	
}

class AttachmentView: UIView, UIGestureRecognizerDelegate {
	
	var style: AttachmentStyle! {
		didSet {
			self.backgroundColor = self.style.color
		}
	}
	
	var leftImage: UIImage? {
		didSet {
			if let imageView = self.leftImageView {
				if self.leftImage == nil {
					self.stack.removeArrangedSubview(imageView)
					self.leftImageView = nil
					return
				}
				
				imageView.image = self.leftImage
			} else {
				if self.leftImage == nil {
					return
				}
				
				let imageView = UIImageView(image: self.leftImage!.withRenderingMode(.alwaysTemplate))
				imageView.tintColor = UIColor.black.withAlphaComponent(0.4)

				self.stack.insertArrangedSubview(imageView, at: 0)
				imageView.snp.makeConstraints() {
					constrain in
					
					constrain.height.equalTo(18)
					constrain.width.equalTo(18)
				}
				self.leftImageView = imageView
			}
		}
	}
	
	var showDisclosure: Bool = false {
		didSet {
			self.rightDisclosureWrapper.isHidden = !self.showDisclosure
		}
	}
	
	var text: String? {
		didSet {
			self.textLabel.text = self.text
		}
	}
	
	var clickHandler: () -> Void = {}
	
	fileprivate var stack: UIStackView!
	fileprivate var textLabel: UILabel!
	fileprivate var rightDisclosureWrapper: UIView!

	fileprivate var leftImageView: UIImageView?
	
	init() {
		super.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
		self.build()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.build()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.build()
	}
	
	private func build() {
		self.style = .BLUE
		
//		Style
		self.cornerRadius = 5.0
		self.borderColor = UIColor.black.withAlphaComponent(0.2)
		self.borderWidth = 1.0
		
//		Stack
		let stack = UIStackView()
		self.addSubview(stack)
		
		stack.axis = .horizontal
		stack.alignment = .top
		stack.spacing = 10
		
		stack.snp.makeConstraints() {
			constrain in
			
			constrain.leading.equalToSuperview().inset(15)
			constrain.trailing.equalToSuperview().inset(15)
			constrain.top.equalToSuperview().inset(10)
			constrain.bottom.equalToSuperview().inset(10)
		}
		
//		Center label
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
		label.textColor = UIColor.black.withAlphaComponent(0.4)
		stack.addArrangedSubview(label)
		
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		
		self.stack = stack
		self.textLabel = label
		
//		Disclosure wrapper
		let wrapper = UIView()
		self.stack.addArrangedSubview(wrapper)
		self.rightDisclosureWrapper = wrapper
		
		wrapper.snp.makeConstraints() {
			constrain in
			constrain.height.equalToSuperview()
		}
		
//		Disclosure image
		let imageView = UIImageView(image: UIImage(named: "icon_circle-right")!.withRenderingMode(.alwaysTemplate))
		imageView.tintColor = UIColor.black.withAlphaComponent(0.4)
		
		wrapper.addSubview(imageView)
		
		imageView.snp.makeConstraints() {
			constrain in
			
			constrain.centerY.equalToSuperview()
			constrain.leading.equalToSuperview()
			constrain.trailing.equalToSuperview()
			
			constrain.height.equalTo(18)
			constrain.width.equalTo(18)
		}
		
		self.rightDisclosureWrapper.isHidden = !self.showDisclosure		
	}
	
	func enableClicks() {
		let clickRecognizer = AttachmentTapRecognizer(target: self, action: #selector(handleClick(_:)))
		clickRecognizer.cancelsTouchesInView = false
		clickRecognizer.delegate = self
		self.addGestureRecognizer(clickRecognizer)
	}
	
	@objc func handleClick(_ recognizer: UIGestureRecognizer) {
		self.clickHandler()
	}
	
}

fileprivate class AttachmentTapRecognizer: UITapGestureRecognizer {
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesBegan(touches, with: event)
		
		if let view = self.view as? AttachmentView {
			view.backgroundColor = view.style.color.withAlphaComponent(0.25)
			
//			This timer is because otherwise the view doesn't deselect if you drag the tableView at all. Someone smarter than me can deal with it.
			Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {
				timer in
				
				if self.state != .began {
					print(self.state.rawValue)
					self.animateEnd()
				}
			}
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
	
	override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent) {
		super.pressesEnded(presses, with: event)
		self.animateEnd()
	}
	
	override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent) {
		super.pressesCancelled(presses, with: event)
		self.animateEnd()
	}
	
	private func animateEnd() {
		UIView.animate(withDuration: 0.25) {
			if let view = self.view as? AttachmentView {
				view.backgroundColor = view.style.color
			}
		}
	}
	
}
