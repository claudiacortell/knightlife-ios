//
//  SettingsColorInfoView.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import Color_Picker_for_iOS

class SettingsColorInfoView: UIView, HRColorInfoViewProtocol {
	
	var color: UIColor! {
		didSet {
			self.colorChanged()
		}
	}
	
	convenience init() {
		self.init(frame: CGRect.zero)
		self.doInit()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.doInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.doInit()
	}
	
	private func doInit() {
		self.borderWidth = 1.0
		self.borderColor = Scheme.dividerColor.color
		
		self.layer.cornerRadius = 5.0
	}
	
	private func colorChanged() {
		self.backgroundColor = self.color
	}

}
