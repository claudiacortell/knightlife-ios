//
//  BlockTableClassViewCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import UIKit

class BlockTableClassViewCell: UITableViewCell
{
	@IBOutlet weak private var colorView: UIView!
	@IBOutlet weak private var iconView: UIImageView!
	
	@IBOutlet weak private var classNameLabel: UILabel!
	@IBOutlet weak private var homeworkLabel: UILabel!
	
	@IBOutlet weak private var blockLabel: UILabel!
	
	@IBOutlet weak private var timeFromLabel: UILabel!
	@IBOutlet weak private var timeToLabel: UILabel!
	
	@IBOutlet weak private var moreIcon: UIView!
	
	var className: String?
	{
		didSet
		{
			self.classNameLabel.text = className!
		}
	}
	
	var homework: String?
	{
		didSet
		{
			self.homeworkLabel.text = homework!
		}
	}
	
	var block: BlockID?
	{
		didSet
		{
			self.blockLabel.text = block!.rawValue
		}
	}
	
	var startTime: EnscribedTime?
	{
		didSet
		{
			self.timeFromLabel.text = startTime!.toString()
		}
	}
	
	var endTime: EnscribedTime?
	{
		didSet
		{
			self.timeToLabel.text = endTime!.toString()
		}
	}
	
	var more: Bool?
	{
		didSet
		{
			self.moreIcon.isHidden = !more!
		}
	}
}
