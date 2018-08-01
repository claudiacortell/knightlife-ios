//
//  CoursesPrefModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/30/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib
import Hero
import SnapKit

class CoursesPrefModule: TableModule {
	
	let controller: UIViewController
	
	init(controller: UIViewController) {
		self.controller = controller
	}
	
	func loadCells(layout: TableLayout) {
		let section = layout.addSection()
		section.addDividerCell(left: 0, right: 0, backgroundColor: UIColor.clear, insetColor: UIColor(hex: "E1E1E6")!)
		section.addCell(TitleCell(title: CourseManager.instance.meetings.isEmpty ? "No Classes" : "Classes"))
		
		section.addDividerCell(left: 0, right: 0, backgroundColor: UIColor.clear, insetColor: UIColor(hex: "E1E1E6")!)

		for course in CourseManager.instance.meetings {
			section.addCell(CoursePrefCell(controller: self.controller, course: course))
			section.addDividerCell(left: 0, right: 0, backgroundColor: UIColor.clear, insetColor: UIColor(hex: "E1E1E6")!)
		}
		
		section.addSpacerCell().setBackgroundColor(.clear).setHeight(15)
		section.addCell(PrefsActionCell(title: "Add", image: UIImage(named: "icon_add")!) {
			self.openAddMenu()
		})
		
		section.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
	private func openAddMenu() {

	}
	
}
