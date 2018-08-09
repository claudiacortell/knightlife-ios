//
//  SettingsBlockController.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class SettingsBlockController: UIViewController, TableBuilder {
	
	@IBOutlet weak var tableView: UITableView!
	private var tableHandler: TableHandler!
	
	var meta: BlockMeta!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.tableHandler.builder = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationItem.title = self.meta.block.displayName
		self.tableHandler.reload()
	}
	
	private func didChangeSettings() {
		BlockMetaManager.instance.saveStorage()
	}
	
	func buildCells(layout: TableLayout) {
		let about = layout.addSection()
		
		about.addDivider()
		about.addCell(TitleCell(title: "About"))
		about.addDivider()
		
		if self.meta.block == .free {
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
				
				self.meta.color = color
				self.didChangeSettings()
			}
			
			self.navigationController?.pushViewController(controller, animated: true)
		})
		
		about.addDivider()
		about.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
		
		let notifications = layout.addSection()
		
		notifications.addDivider()
		notifications.addCell(TitleCell(title: "Notifications"))
		notifications.addDivider()
		
		notifications.addCell(PrefToggleCell(title: "Show Alerts", on: self.meta.notifications) {
			self.meta.notifications = $0
			self.didChangeSettings()
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
				
				self.meta.customName = trimmed.count > 0 ? trimmed : nil
				self.tableHandler.reload()
				
				self.didChangeSettings()
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
