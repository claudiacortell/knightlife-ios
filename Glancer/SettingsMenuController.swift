//
//  SettingsMenuController.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/28/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class SettingsMenuController: ITableController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.estimatedRowHeight = 70.0
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		self.reloadTable()
	}
	
	override func generateSections()
	{
		let section = TableSection()
		section.addSpacerCell(10)
		
		section.addCell(TableCell("header", callback: {
			template, cell in
			if let header = cell as? SettingsHeaderCell
			{
				header.title = "Courses"
			}
		}).setHeight(40.0))
		
		section.addSpacerCell(5)

		for course in CourseManager.instance.getCourses()
		{
			let cell = TableCell("course-list", callback:
			{
				template, cell in
				if let courseCell = cell as? CourseListCell
				{
					courseCell.color = UIColor(course.color ?? "777777")
					courseCell.name = course.name
					courseCell.course = course
				}
			})
			cell.setHeight(55)
			section.addCell(cell)
		}
		section.addSpacerCell(5)
		section.addCell(TableCell("course-add").setHeight(50.0))
		
		self.addTableSection(section)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if let from = sender as? CourseListCell, let controller = segue.destination as? CourseDetailControlWrapper
		{
			controller.course = from.course
		}
	}
}
