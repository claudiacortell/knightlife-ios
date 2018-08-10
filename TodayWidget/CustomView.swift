//
//  CustomView.swift
//  TodayWidget
//
//  Created by Dylan Hanson on 8/10/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CustomView: UIView {
	
	convenience init() {
		self.init(frame: CGRect.zero)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.loadNib()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.loadNib()
	}
	
	func loadNib() {
//	Override point
	}
	
	func secure(view: UIView) {
		self.addSubview(view)
		view.snp.makeConstraints() {
			constrain in
			
			constrain.leading.equalToSuperview()
			constrain.trailing.equalToSuperview()
			constrain.top.equalToSuperview()
			constrain.bottom.equalToSuperview()
		}
		
//		Make clear
		view.backgroundColor = .clear
		self.backgroundColor = .clear
	}
	
}
