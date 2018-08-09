//
//  SettingsController.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/29/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class SettingsController: UIViewController, TableBuilder {
	
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
		self.tableHandler.addModule(CoursesPrefModule(controller: self))
		self.tableHandler.addModule(BlockPrefsModule(controller: self))
		self.tableHandler.addModule(VariationPrefsModule())
		self.tableHandler.addModule(LunchPrefsModule())
	}
	
}
