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
			self.titleLabel.isHidden = self.title == nil
			self.titleLabel.text = self.title
		}
	}
	
	@IBInspectable var subtitle: String? {
		didSet {
			self.subtitleLabel.isHidden = self.subtitle == nil
			self.subtitleLabel.text = self.subtitle
		}
	}
	
	@IBInspectable var subtitleColor: UIColor = UIColor.darkGray {
		didSet {
			self.subtitleLabel.textColor = self.subtitleColor
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
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .center
		
		let titleLabel = UILabel()
		titleLabel.textColor = UIColor.darkText
		titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		titleLabel.text = self.title
		
		let subtitleLabel = UILabel()
		subtitleLabel.textColor = self.subtitleColor
		subtitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
		subtitleLabel.text = self.subtitle
		
		self.titleLabel = titleLabel
		self.subtitleLabel = subtitleLabel
		
		stackView.addArrangedSubview(titleLabel)
		stackView.addArrangedSubview(subtitleLabel)
		
		let spacer = UIView()
		spacer.snp.makeConstraints() {
			constrain in
			constrain.height.equalTo(2)
		}
		stackView.addArrangedSubview(spacer)

		self.titleView = stackView
	}
	

	
}
