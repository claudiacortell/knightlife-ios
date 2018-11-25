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

class SettingsClassController: UIViewController, TableHandlerDataSource {
	
	var course: Course!
	
	@IBOutlet weak var tableView: UITableView!
	private var tableHandler: TableHandler!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.tableHandler.dataSource = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.tableHandler.reload()
	}
	
	private func needsNotificationUpdate() {
		NotificationManager.instance.scheduleShallowNotifications()
	}
	
	private func didChangeSettings() {
		CourseManager.instance.courseChanged(course: self.course)
	}
	
	func buildCells(handler: TableHandler, layout: TableLayout) {
		let about = layout.addSection()
		about.addDivider()
		about.addCell(TitleCell(title: "About"))
		about.addDivider()
		about.addCell(SettingsTextCell(left: "Name", right: self.course.name) {
			self.showChangeName()
		})
		
		about.addDivider()
		
		about.addCell(SettingsCourseColorCell(color: self.course.color) {
			guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "Color") as? SettingsColorPickerController else {
				return
			}

			controller.color = self.course.color
			controller.colorPicked = {
				color in
				
				self.course.color = color
				self.didChangeSettings()
			}
			
			self.navigationController?.pushViewController(controller, animated: true)
		})
		
		about.addDivider()
		
		about.addSpacerCell().setBackgroundColor(.clear).setHeight(35 / 2)
		
		about.addDivider()
		
		about.addCell(SettingsTextCell(left: "Location", right: self.course.location ?? "") {
			self.showChangeClass()
		})
		
		about.addDivider()
		
		about.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
		
		let scheduling = layout.addSection()
		scheduling.addDivider()
		
		scheduling.addCell(TitleCell(title: "Scheduling"))
		
		scheduling.addDivider()
		
		scheduling.addCell(SettingsTextCell(left: "Block", right: self.course.courseSchedule.block.displayName) {
			self.showChangeBlock()
		})
		
		scheduling.addDivider()
		
		scheduling.addCell(SettingsTextCell(left: "Days", right: {
			switch self.course.courseSchedule.frequency {
			case .everyDay:
				return "Every"
			default:
				return "Specific"
			}
		}(), clicked: {
			self.showChangeDays()
		}))
		
		switch self.course.courseSchedule.frequency {
		case .specificDays(_):
			for weekday in DayOfWeek.weekdays() {
				scheduling.addCell(SettingsCourseDayCell(course: self.course, day: weekday) {
					path, day, selected in
					
					if selected {
						self.course.courseSchedule.addMeetingDay(day)
					} else {
						self.course.courseSchedule.removeMeetingDay(day)
					}
					
					self.tableView.reloadRows(at: [path], with: .fade)
					self.didChangeSettings()
					self.needsNotificationUpdate()
				})
			}
			break
		default:
			break
		}
		
		scheduling.addDivider()
		
		scheduling.addSpacerCell().setBackgroundColor(.clear).setHeight(35)

		let notifications = layout.addSection()
		notifications.addDivider()
		
		notifications.addCell(TitleCell(title: "Notifications"))
		
		notifications.addDivider()
		
		notifications.addCell(PrefToggleCell(title: "Before Class", on: self.course.showBeforeClassNotifications) {
			self.course.showBeforeClassNotifications = $0
			self.didChangeSettings()
			self.needsNotificationUpdate()
		})
		
		notifications.addDivider()
		
		notifications.addCell(PrefToggleCell(title: "Class End", on: self.course.showAfterClassNotifications) {
			self.course.showAfterClassNotifications = $0
			self.didChangeSettings()
			self.needsNotificationUpdate()
		})
		
		notifications.addDivider()
		
		notifications.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
		
		let delete = layout.addSection()
		delete.addDivider()
		
		delete.addCell(SettingsCourseDeleteCell() {
			self.showDelete()
		})
		
		delete.addDivider()
		delete.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
	private func showChangeName() {
		let alert = UIAlertController(title: "Class Name", message: nil, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		let saveAction = UIAlertAction(title: "Save", style: .default, handler: { action in
			if let name = alert.textFields?.first?.text {
				self.course.name = name.trimmingCharacters(in: .whitespaces)
				self.tableHandler.reload()
				
				self.didChangeSettings()
				self.needsNotificationUpdate()
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
				
				self.didChangeSettings()
				self.needsNotificationUpdate()
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
		let alert = UIAlertController(title: "Block", message: "During what block does this class meet?", preferredStyle: .actionSheet)
		
//		Array of tuples instead of dictionary so that it retains its order
		var blockActions: [(id: BlockID, alert: UIAlertAction)] = []
		
		let handler: (UIAlertAction) -> Void = {
			alert in
			
//			Get the tuple with this specific action, and thus its blockId
			guard let key = blockActions.filter({ $0.alert === alert }).first?.id else {
				return
			}
			
			self.course.courseSchedule.block = key
			self.tableHandler.reload()
			
			self.didChangeSettings()
			self.needsNotificationUpdate()
		}
		
		blockActions = [
			(.a, UIAlertAction(title: "A Block", style: .default, handler: handler)),
			(.b, UIAlertAction(title: "B Block", style: .default, handler: handler)),
			(.c, UIAlertAction(title: "C Block", style: .default, handler: handler)),
			(.d, UIAlertAction(title: "D Block", style: .default, handler: handler)),
			(.e, UIAlertAction(title: "E Block", style: .default, handler: handler)),
			(.f, UIAlertAction(title: "F Block", style: .default, handler: handler)),
			(.g, UIAlertAction(title: "G Block", style: .default, handler: handler)),
			(.x, UIAlertAction(title: "X Block", style: .default, handler: handler)),
			(.activities, UIAlertAction(title: "Activities", style: .default, handler: handler))
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
	
	private func showChangeDays() {
		let alert = UIAlertController(title: "Days", message: "On which days does this class meet? This should be Every Day unless the class skips certain days.", preferredStyle: .actionSheet)
		
		let everyDayAction = UIAlertAction(title: "Every Day", style: .default) {
			action in
			
			switch self.course.courseSchedule.frequency {
			case .specificDays(_): // Only need to change things if the value was changed.
				self.course.courseSchedule.frequency = CourseFrequency.everyDay
				self.didChangeSettings()
				self.needsNotificationUpdate()
			default:
				break
			}
			
			self.tableHandler.reload()
		}
		
		let specificDaysAction = UIAlertAction(title: "Specific Days", style: .default) {
			action in
			
			switch self.course.courseSchedule.frequency {
			case .everyDay: // Only need to change things if the value was changed.
				self.course.courseSchedule.frequency = CourseFrequency.specificDays(DayOfWeek.weekdays())
				self.didChangeSettings()
				self.needsNotificationUpdate()
			default:
				break
			}
			
			self.tableHandler.reload()
		}
		
		switch self.course.courseSchedule.frequency {
		case .everyDay:
			everyDayAction.setValue(true, forKey: "checked")
		case .specificDays(_):
			specificDaysAction.setValue(true, forKey: "checked")
		}
		
		alert.addAction(everyDayAction)
		alert.addAction(specificDaysAction)
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		self.present(alert, animated: true)
	}
	
	private func showDelete() {
		let alert = UIAlertController(title: "Remove Class", message: "This action cannot be undone.", preferredStyle: .actionSheet)
		
		alert.addAction(UIAlertAction(title: "Remove", style: UIAlertActionStyle.destructive) {
			action in
			
			CourseManager.instance.removeCourse(self.course)
			self.needsNotificationUpdate()
			
			self.navigationController?.popViewController(animated: true)
		})
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		self.present(alert, animated: true)
	}
	
}
