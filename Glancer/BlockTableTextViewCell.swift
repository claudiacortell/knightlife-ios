//
//  BlockTableTextViewCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/10/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class BlockTableTextViewCell: UITableViewCell
{
	@IBOutlet private weak var textBoxLabel: UILabel!
	
	var textBox: String?
	{
		didSet
		{
			self.textBoxLabel.text = self.textBox
		}
	}
}
