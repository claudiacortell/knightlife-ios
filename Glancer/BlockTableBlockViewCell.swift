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
	
	@IBOutlet weak private var moreIcon: UIView!
	
	var block: BlockID?
	{
		didSet
		{
			self.blockLabel.text = block?.displayName
			self.blockLetterLabel.text = block?.displayLetter
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
	
	var more: Bool = false
	{
		didSet
		{
			self.moreIcon.isHidden = !more
		}
	}
}
