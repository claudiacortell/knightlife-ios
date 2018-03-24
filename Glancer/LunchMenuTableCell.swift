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
	
	@IBOutlet weak private var nameLabel: UILabel!
	@IBOutlet weak private var allergenLabel: UILabel!
	
	@IBOutlet weak private var disclosureIndicator: UIImageView!
	private var rotated = false
	
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
			self.allergenLabel.isHidden = !self.showAllergen
			self.stackView.layoutSubviews()
		}
	}
	
	var showsDisclosure: Bool = true
	{
		didSet
		{
			self.disclosureIndicator.isHidden = !showsDisclosure
		}
	}
	
	var rotateDisclosure: Bool = false
	{
		didSet
		{
			if self.rotateDisclosure
			{
				if !self.rotated
				{
					self.disclosureIndicator.transform = self.disclosureIndicator.transform.rotated(by: CGFloat(Double.pi))
					self.rotated = true
				}
			} else
			{
				if self.rotated
				{
					self.disclosureIndicator.transform = self.disclosureIndicator.transform.rotated(by: CGFloat(-Double.pi))
					self.rotated = false
				}
			}
		}
	}
}
