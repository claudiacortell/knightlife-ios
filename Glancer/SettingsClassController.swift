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
			self.showChangeName()
		})
		
		about.addDivider()
		
		about.addCell(SettingsCourseColorCell(color: self.course.color) {
//			Open color change dialog
		})
		
		about.addDivider()
		
		about.addSpacerCell().setBackgroundColor(.clear).setHeight(35 / 2)
		
		about.addDivider()
		
		about.addCell(SettingsCourseTextCell(left: "Location", right: self.course.location ?? "") {
			self.showChangeClass()
		})
		
		about.addDivider()
		
		about.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
		
		let scheduling = layout.addSection()
		scheduling.addDivider()
		
		scheduling.addCell(TitleCell(title: "Scheduling"))
		
		scheduling.addDivider()
		
		scheduling.addCell(SettingsCourseTextCell(left: "Block", right: self.course.courseSchedule.block.displayName) {
			self.showChangeBlock()
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
	
	private func showChangeName() {
		let alert = UIAlertController(title: "Class Name", message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		let saveAction = UIAlertAction(title: "Save", style: .default, handler: { action in
			if let name = alert.textFields?.first?.text {
				self.course.name = name.trimmingCharacters(in: .whitespaces)
				self.tableHandler.reload()
			}
		})
		
		alert.addAction(saveAction)
		
		alert.addTextField(configurationHandler: { textField in
			textField.autocapitalizationType = .words
			textField.autocorrectionType = .default
			
			textField.placeholder = "e.g. English"
			textField.text = self.course.name
			
			NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
				saveAction.isEnabled = textField.text!.trimmingCharacters(in: .whitespaces).count > 0
			}
		})

		self.present(alert, animated: true)
	}
	
	private func showChangeClass() {
		let alert = UIAlertController(title: "Location", message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		let saveAction = UIAlertAction(title: "Save", style: .default, handler: { action in
			if let name = alert.textFields?.first?.text {
				let trimmed = name.trimmingCharacters(in: .whitespaces)

				self.course.location = trimmed.count > 0 ? trimmed : nil
				self.tableHandler.reload()
			}
		})
		
		alert.addAction(saveAction)
		
		alert.addTextField(configurationHandler: { textField in
			textField.autocapitalizationType = .words
			textField.autocorrectionType = .default
			
			textField.placeholder = "e.g. Room #123"
			textField.text = self.course.location
		})
		
		self.present(alert, animated: true)
	}
	
	private func showChangeBlock() {
		let alert = UIAlertController(title: "Block", message: nil, preferredStyle: .actionSheet)
		
//		Array of tuples instead of dictionary so that it retains its order
		var blockActions: [(id: BlockID, alert: UIAlertAction)] = []
		
		let handler: (UIAlertAction) -> Void = {
			alert in
			
			guard let key = blockActions.filter({ $0.alert === alert }).first?.id else {
				return
			}
			
			self.course.courseSchedule.block = key
			self.tableHandler.reload()
		}
		
		blockActions = [
			(.a, UIAlertAction(title: "A Block", style: .default, handler: handler)),
			(.b, UIAlertAction(title: "B Block", style: .default, handler: handler)),
			(.c, UIAlertAction(title: "C Block", style: .default, handler: handler)),
			(.d, UIAlertAction(title: "D Block", style: .default, handler: handler)),
			(.e, UIAlertAction(title: "E Block", style: .default, handler: handler)),
			(.f, UIAlertAction(title: "F Block", style: .default, handler: handler)),
			(.g, UIAlertAction(title: "G Block", style: .default, handler: handler)),
		]
		
		for (id, action) in blockActions {
			if self.course.courseSchedule.block == id {
				action.setValue(true, forKey: "checked")
			}
			
			alert.addAction(action)
		}
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		self.present(alert, animated: true)
	}
	
}
