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
	
	override func build() {
		let section = self.addSection()
		
		section.addDivider()
		section.addCell(TitleCell(title: CourseM.courses.isEmpty ? "No Classes" : "Classes"))
		section.addDivider()
		
		for course in CourseM.courses {
			section.addCell(CoursePrefCell(module: self, course: course))
			section.addDivider()
		}
		
		section.addSpacerCell().setBackgroundColor(.clear).setHeight(15)
		section.addCell(PrefsActionCell(title: "Add", image: UIImage(named: "icon_add")!) {
			self.openAddMenu()
		})
		
		section.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
	private func openAddMenu() {
		let alert = UIAlertController(title: "Add Class", message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		let saveAction = UIAlertAction(title: "Add", style: .default, handler: { action in
			if let name = alert.textFields?.first?.text {
				let trimmedName = name.trimmingCharacters(in: .whitespaces)
				
				let course = CourseM.createCourse(name: trimmedName)
				
				self.presentCourse(course: course)
			}
		})
		
		alert.addAction(saveAction)
		
		alert.addTextField(configurationHandler: { textField in
			textField.autocapitalizationType = .words
			textField.autocorrectionType = .default
			
			textField.placeholder = "e.g. English"
			
			NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
				saveAction.isEnabled = textField.text!.trimmingCharacters(in: .whitespaces).count > 0
			}
		})
		
		self.controller.present(alert, animated: true)
	}
	
	func presentCourse(course: Course) {
		guard let classView = self.controller.storyboard?.instantiateViewController(withIdentifier: "SettingsClass") as? SettingsClassController else {
			return
		}
		
		classView.course = course
		controller.navigationController?.pushViewController(classView, animated: true)
	}
	
}
