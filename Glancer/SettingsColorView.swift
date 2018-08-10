//
//  SettingsColorView.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/9/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import AddictiveLib

class SettingsColorView: UIView {
	
	var controller: SettingsColorPickerController!
	
	var checkView: UIImageView?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}
	
	var color: UIColor {
		return self.backgroundColor ?? Scheme.nullColor.color
	}
	
	private func setup() {
		let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.clicked(_:)))
		self.addGestureRecognizer(recognizer)
	}
	
	@objc func clicked(_ sender: UITapGestureRecognizer) {
		HapticUtils.SELECTION.selectionChanged()
		
		self.select()
		
		UIView.animate(withDuration: 0.1, animations: {
			self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
		}, completion: {
			successful in
			
			UIView.animate(withDuration: 0.1, animations: {
				self.transform = CGAffineTransform.identity
			})
		})
		
		self.controller.colorPicked(color: self.color, view: self)
	}
	
	func select() {
		if self.checkView != nil {
			return
		}
		
		let imageView = UIImageView()
		imageView.image = UIImage(named: "icon_check")?.withRenderingMode(.alwaysTemplate)
		imageView.tintColor = .white
		
		self.checkView = imageView
		self.addSubview(imageView)
		
		imageView.snp.makeConstraints() {
			constrain in
			
			constrain.centerX.equalToSuperview()
			constrain.centerY.equalToSuperview()
			
			constrain.height.equalToSuperview().multipliedBy(0.4)
			constrain.width.equalToSuperview().multipliedBy(0.4)
		}
	}
	
	func deselect() {
		guard let imageView = self.checkView else {
			return
		}
		
		UIView.animate(withDuration: 0.2, animations: {
			imageView.layer.opacity = 0.0
		}, completion: {
			success in
			
			self.checkView = nil
			imageView.removeFromSuperview()
		})
	}
	
}
