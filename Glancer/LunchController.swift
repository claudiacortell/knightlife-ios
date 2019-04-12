//
//  LunchController.swift
//  Glancer
//
//  Created by Dylan Hanson on 7/27/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class LunchController: UIViewController, TableHandlerDataSource {
	
	var menu: Lunch!
	
	@IBOutlet weak var tableView: UITableView!
	private var tableHandler: TableHandler!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.tableHandler.dataSource = self
		
		self.navigationItem.title = self.menu.title ?? "Lunch"

	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.tableHandler.reload()
	}
	
	func buildCells(handler: TableHandler, layout: TableLayout) {
		let section = layout.addSection()
		
		section.addDivider()
		
		for item in self.menu.items {
			section.addCell(LunchItemCell(item: item, showAllergen: true))
			section.addDivider()
		}
	}
	
}
