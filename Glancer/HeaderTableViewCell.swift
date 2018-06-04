//
//  HeaderTableViewCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 5/13/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var moreButton: UIButton!
	
	var title: String? {
		didSet {
			self.titleLabel.text = self.title
		}
	}
	
	var subtitle: String? {
		didSet {
			self.subtitleLabel.text = self.subtitle
		}
	}
	
	var showButton: Bool = false {
		didSet {
			self.moreButton.isHidden = self.showButton
		}
	}
	
	var buttonText: String? {
		didSet {
			self.moreButton.setTitle(self.buttonText, for: .normal)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.reloadSettings()
	}
	
	private func reloadSettings() {
		self.titleLabel.text = self.title
		self.subtitleLabel.text = self.subtitle
		self.moreButton.isHidden = self.showButton
		self.moreButton.setTitle(self.buttonText, for: .normal)
	}
    
}
