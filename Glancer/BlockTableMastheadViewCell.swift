//
//  BlockTableMastheadViewCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/7/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class BlockTableMastheadViewCell: UITableViewCell
{
	private let originalHeight = 92
	
	@IBOutlet private weak var scopeLabel: UILabel!
	@IBOutlet private weak var dateLabel: UILabel!
	
	@IBOutlet private weak var stackView: UIStackView!

	var scope: String?
	{
		didSet
		{
			self.scopeLabel.text = self.scope
		}
	}
	
	var date: String?
	{
		didSet
		{
			self.dateLabel.text = self.date
		}
	}
	
	var height: CGFloat
	{
		return CGFloat(self.originalHeight + 20 * self.stackView.arrangedSubviews.count)
	}
	
	func clearSubtitles()
	{
		for title in self.stackView.arrangedSubviews
		{
			self.stackView.removeArrangedSubview(title)
			title.removeFromSuperview()
		}
	}
	
	func addSubtitle(_ title: String)
	{
		let label = UILabel()
		
		label.text = title
		label.font.withSize(CGFloat(18))
		label.textColor = UIColor.darkGray
		
		label.frame = CGRect(x: 0, y: 0, width: 0, height: 20.0)
		
		label.addConstraint(NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 20.0))
		
		self.stackView.addArrangedSubview(label)
	}
}
