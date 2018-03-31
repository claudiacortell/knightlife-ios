//
//  CourseListViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/28/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class CourseListViewController: ITableController
{
	override func viewDidLoad()
	{
		self.reloadTable()
	}
	
	override func generateSections()
	{
		let section = TableSection()
		section.addSpacerCell(10)
		
		for course in CourseManager.instance.getCourses()
		{
			let cell = TableCell("cell", callback:
			{
				template, cell in
				if let courseCell = cell as? CourseListCell
				{
					courseCell.color = UIColor(course.color ?? "777777")
					courseCell.name = course.name
					courseCell.course = course
				}
			})
			cell.height = 60.0
			section.addCell(cell)
		}
		
		self.addTableSection(section)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if let from = sender as? CourseListCell, let controller = segue.destination as? CourseDetailViewController
		{
			controller.course = from.course
		}
	}
}
