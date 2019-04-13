//
//  SettingsBlockController.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class SettingsBlockController: UIViewController, TableHandlerDataSource {
	
	@IBOutlet weak var tableView: UITableView!
	private var tableHandler: TableHandler!
	
	var meta: BlockMeta!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.tableHandler.dataSource = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationItem.title = self.meta.id.displayName
		self.tableHandler.reload()
	}
	
	private func needsNotificationsUpdate() {
		NotificationManager.instance.scheduleShallowNotifications()
	}
	
	func buildCells(handler: TableHandler, layout: TableLayout) {
		let about = layout.addSection()
				
		about.addDivider()
		about.addCell(TitleCell(title: "About"))
		about.addDivider()
		
		if self.meta.id == .free {
			about.addCell(SettingsTextCell(left: "Name", right: self.meta.customName ?? "") {
				self.showChangeName()
			})
			about.addDivider()
			
			about.addSpacerCell().setBackgroundColor(.clear).setHeight(35 / 2)
			
			about.addDivider()
		}
		
		about.addCell(SettingsCourseColorCell(color: self.meta.color) {
			guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "Color") as? SettingsColorPickerController else {
				return
			}
			
			controller.color = self.meta.color
			controller.colorPicked = {
				color in
				
				try! Realms.write {
					self.meta.color = color
				}
			}
			
			self.navigationController?.pushViewController(controller, animated: true)
		})
		
		about.addDivider()
		about.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
		
		let notifications = layout.addSection()
		
		notifications.addDivider()
		notifications.addCell(TitleCell(title: "Notifications"))
		notifications.addDivider()
		
		notifications.addCell(PrefToggleCell(title: "Before Block", on: self.meta.beforeClassNotifications) { flag in
			try! Realms.write {
				self.meta.beforeClassNotifications = flag
			}
			
			self.needsNotificationsUpdate()
		})
		
		notifications.addDivider()
		
		notifications.addCell(PrefToggleCell(title: "Block End", on: self.meta.afterClassNotifications) { flag in
			try! Realms.write {
				self.meta.afterClassNotifications = flag
			}
			
			self.needsNotificationsUpdate()
		})
		
		notifications.addDivider()
		
		notifications.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
	}
	
	private func showChangeName() {
		let alert = UIAlertController(title: "Free Block Name", message: "This will be displayed instead of the block's type.", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		let saveAction = UIAlertAction(title: "Save", style: .default, handler: { action in
			if let name = alert.textFields?.first?.text {
				let trimmed = name.trimmingCharacters(in: .whitespaces)
				
				try! Realms.write {
					self.meta.customName = trimmed.count > 0 ? trimmed : nil
				}
				
				self.tableHandler.reload()
				
				self.needsNotificationsUpdate()
			}
		})
		
		alert.addAction(saveAction)
		
		alert.addTextField(configurationHandler: { textField in
			textField.autocapitalizationType = .words
			textField.autocorrectionType = .default
			
			textField.placeholder = "e.g. Chill Time"
			textField.text = self.meta.customName
		})
		
		self.present(alert, animated: true)
	}
	
}
