//
//  CourseDetailControlWrapper.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/30/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class CourseDetailControlWrapper: UIViewController
{
	var course: Course!
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		super.prepare(for: segue, sender: sender)
		
		if let controller = segue.destination as? CourseDetailViewController
		{
			controller.course = self.course
		}
	}
}
