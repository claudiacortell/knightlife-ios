//
//  BlockTableBlockViewCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/28/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class BlockTableBlockViewCell: UITableViewCell
{
	@IBOutlet weak private var colorView: UIView!
	@IBOutlet weak private var blockLetterLabel: UILabel!
	
	@IBOutlet weak private var blockLabel: UILabel!
	
	@IBOutlet weak private var timeFromLabel: UILabel!
	@IBOutlet weak private var timeToLabel: UILabel!
	
	var blockLetter: String?
	{
		didSet
		{
			self.blockLetterLabel.text = blockLetter
		}
	}
	
	var color: String?
	{
		didSet
		{
			self.colorView.backgroundColor = color == nil ? nil : UIColor(color!)
		}
	}
	
	var blockName: String?
	{
		didSet
		{
			self.blockLabel.text = blockName
		}
	}
	
	var startTime: EnscribedTime?
	{
		didSet
		{
			self.timeFromLabel.text = startTime?.toString()
		}
	}
	
	var endTime: EnscribedTime?
	{
		didSet
		{
			self.timeToLabel.text = endTime?.toString()
		}
	}
}
