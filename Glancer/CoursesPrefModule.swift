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
		section.addDivider()
		section.addCell(TitleCell(title: CourseManager.instance.meetings.isEmpty ? "No Classes" : "Classes"))
		section.addDivider()
		
		for course in CourseManager.instance.meetings {
			section.addCell(CoursePrefCell(controller: self.controller, course: course))
			section.addDivider()
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
