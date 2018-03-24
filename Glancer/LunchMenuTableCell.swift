//
//  LunchMenuTableCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/23/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class LunchMenuTableCell: UITableViewCell
{
	@IBOutlet weak private var stackView: UIStackView!
	
	@IBOutlet weak private var categoryLabel: UILabel!
	@IBOutlet weak private var nameLabel: UILabel!
	
	@IBOutlet weak var allergenWrapper: UIView!
	@IBOutlet weak private var allergenLabel: UILabel!
	
	override func layoutSubviews()
	{
		super.layoutSubviews()
	}
	
	var height: CGFloat
	{
		return self.stackView.frame.height
	}
	
	var name: String?
	{
		didSet
		{
			self.nameLabel.text = self.name
		}
	}
	
	var category: LunchMenuItemType?
	{
		didSet
		{
			self.categoryLabel.text = (self.category ?? LunchMenuItemType.other
			).rawValue.uppercased()
		}
	}
	
	var allergen: String?
	{
		didSet
		{
			self.allergenLabel.text = self.allergen
		}
	}
	
	var showAllergen: Bool = false
	{
		didSet
		{
			self.allergenWrapper.isHidden = !self.showAllergen
		
			self.allergenWrapper.setNeedsLayout()
			self.allergenWrapper.layoutIfNeeded()
			self.stackView.layoutSubviews()
		}
	}
}
