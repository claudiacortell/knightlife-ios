//
//  ErrorModule.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/19/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class ErrorModule: TableModule {
	
	let table: UITableView
	let reloadable: ErrorReloadable
	
	init(table: UITableView, reloadable: ErrorReloadable) {
		self.table = table
		self.reloadable = reloadable
		
		super.init()
	}
	
	override func build() {
		let section = self.addSection()
		section.addCell(ErrorCell(reloadable: self.reloadable)).setHeight(self.table.frame.height)
	}
	
}
