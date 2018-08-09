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
		let color = layout.addSection()
		
		color.addDivider()
		color.addCell(TitleCell(title: "About"))
		color.addDivider()
		
		color.addCell(SettingsCourseColorCell(color: self.meta.color) {
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
		
		color.addDivider()
		color.addSpacerCell().setBackgroundColor(.clear).setHeight(35)
		
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
	
}
