//
//  SettingsViewManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 4/17/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import UIKit

class SettingsViewManager: UIViewController, TableBuilder {
	
	@IBOutlet weak var tableRep: UITableView!
	private var tableHandler: TableHandler!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableRep)
		self.tableHandler.builder = self
		
		self.tableRep.rowHeight = UITableViewAutomaticDimension
		self.tableRep.estimatedRowHeight = 70.0
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tableHandler.reload()
	}
	
	func buildCells(layout: TableLayout) {
		let section = layout.addSection()
		section.addSpacerCell().setHeight(10)
		
		section.addCell("header").setHeight(40).setCallback() {
			template, cell in
			if let header = cell as? SettingsHeaderCell {
				header.title = "Courses"
			}
		}
		
		section.addSpacerCell().setHeight(5)
		
		for course in CourseManager.instance.getCourses() {
			section.addCell("course-list").setHeight(55).setCallback({
				template, cell in
				
				if let courseCell = cell as? CourseListCell {
					courseCell.color = UIColor(hex: course.color ?? "777777")
					courseCell.name = course.name
					courseCell.course = course
				}
			})
		}
		
		section.addSpacerCell().setHeight(5)
		section.addCell("course-add").setHeight(50)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let from = sender as? CourseListCell, let controller = segue.destination as? CourseDetailControlWrapper {
			controller.course = from.course
		}
	}
	
}
