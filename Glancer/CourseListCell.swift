//
//  CourseListCell.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/28/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class CourseListCell: UITableViewCell
{
	@IBOutlet weak private var colorView: UIView!
	@IBOutlet weak private var courseLabel: UILabel!
	
	var course: Course!
	
	var color: UIColor?
	{
		didSet
		{
			self.colorView.backgroundColor = self.color
		}
	}
	
	var name: String?
	{
		didSet
		{
			self.courseLabel.text = self.name
		}
	}
}
