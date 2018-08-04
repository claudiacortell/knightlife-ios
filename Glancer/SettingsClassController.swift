//
//  SettingsClassController.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/3/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class SettingsClassController: UIViewController, TableBuilder {
	
	var course: Course!
	
	@IBOutlet weak var tableView: UITableView!
	private var tableHandler: TableHandler!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.tableHandler.builder = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.tableHandler.reload()
	}
	
	func buildCells(layout: TableLayout) {
		let about = layout.addSection()
		about.addDivider()
		about.addCell(TitleCell(title: "About"))
		about.addDivider()
		about.addCell(SettingsCourseTextCell(left: "Name", right: self.course.name) {
//			Open change name dialog
		})
		
		about.addDivider()
		
		about.addCell(SettingsCourseColorCell(color: self.course.color) {
//			Open color change dialog
		})
		
		about.addDivider()
		
		about.addSpacerCell().setBackgroundColor(.clear).setHeight(35 / 2)
		
		about.addDivider()
		
		about.addCell(SettingsCourseTextCell(left: "Room", right: self.course.location ?? "") {
//			Open change room dialog
		})
		
		about.addDivider()
		
		about.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
		
		let scheduling = layout.addSection()
		scheduling.addDivider()
		
		scheduling.addCell(TitleCell(title: "Scheduling"))
		
		scheduling.addDivider()
		
		scheduling.addCell(SettingsCourseTextCell(left: "Block", right: self.course.courseSchedule.block.displayName) {
//			Change block dialog
		})
		
		scheduling.addDivider()
		
		scheduling.addCell(SettingsCourseTextCell(left: "Days", right: {
			switch self.course.courseSchedule.frequency {
			case .everyDay:
				return "Every"
			case .specificDays(let days):
				return days.map({ $0.shortName }).joined(separator: ", ")
			}
		}(), clicked: {
//			Change days dialog
		}))
		
		scheduling.addDivider()
	}
	
}
