//
//  SettingsHeaderCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/31/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class SettingsHeaderCell: UITableViewCell
{
	@IBOutlet weak private var titleLabel: UILabel!
	
	var title: String?
	{
		didSet
		{
			self.titleLabel.text = self.title
		}
	}
}
