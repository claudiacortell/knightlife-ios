//
//  SubtitleNavigationItem.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/25/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SubtitleNavigationItem: UINavigationItem {
	
	private var titleLabel: UILabel!
	private var subtitleLabel: UILabel!
	
	override var title: String? {
		didSet {
			self.titleLabel.text = self.title
		}
	}
	
	@IBInspectable var subtitle: String? {
		didSet {
			self.subtitleLabel.text = self.subtitle
		}
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.setup()
	}
	
	override init(title: String) {
		super.init(title: title)
		self.setup()
	}
	
	private func setup() {
		let view = UIView()
		view.snp.makeConstraints() {
			constrain in
			
			constrain.height.equalTo(38)
		}
		
		let titleLabel = UILabel()
		titleLabel.textColor = UIColor.darkText
		titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		titleLabel.text = self.title
		
		let subtitleLabel = UILabel()
		subtitleLabel.textColor = UIColor.darkGray
		subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
		subtitleLabel.text = self.subtitle
		
		self.titleLabel = titleLabel
		self.subtitleLabel = subtitleLabel
		
		view.addSubview(titleLabel)
		view.addSubview(subtitleLabel)
		
		titleLabel.snp.makeConstraints() {
			constrain in
			
			constrain.centerX.equalToSuperview()
			constrain.top.equalToSuperview()
		}
		
		subtitleLabel.snp.makeConstraints() {
			constrain in
			
			constrain.centerX.equalToSuperview()
			constrain.bottom.equalToSuperview().inset(2)
		}
		
		self.titleView = view
	}
	

	
}
