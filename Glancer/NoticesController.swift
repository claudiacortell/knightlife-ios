//
//  NoticesController.swift
//  Glancer
//
//  Created by Dylan Hanson on 8/12/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class NoticesController: UIViewController, TableBuilder {
	
	var notices: [DateNotice]!
	
	@IBOutlet weak var tableView: UITableView!
	private var tableHandler: TableHandler!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableView)
		self.tableHandler.builder = self
		
		self.navigationItem.title = "Messages"
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.tableHandler.reload()
	}
	
	func buildCells(layout: TableLayout) {
		let lowPriority = self.notices.filter({ $0.priority == .notice })
		let highPriority = self.notices.filter({ $0.priority == .warning })
		
		if !highPriority.isEmpty {
			let section = layout.addSection()
			section.addDivider()
			section.addCell(TitleCell(title: "Alerts"))
			section.addDivider()
			
			section.addSpacerCell().setBackgroundColor(.white).setHeight(5)
			
			for notice in highPriority {
				section.addCell(NoticeCell(notice: notice))
			}
			
			section.addSpacerCell().setBackgroundColor(.white).setHeight(5)
		}
		
		if !lowPriority.isEmpty {
			let section = layout.addSection()
			section.addDivider()
			section.addCell(TitleCell(title: "Notices"))
			section.addDivider()
			
			section.addSpacerCell().setBackgroundColor(.white).setHeight(5)
			
			for notice in lowPriority {
				section.addCell(NoticeCell(notice: notice))
			}
			
			section.addSpacerCell().setBackgroundColor(.white).setHeight(5)
		}
		
		layout.addSection().addDivider() // Cap off the bottom.
	}
	
}
