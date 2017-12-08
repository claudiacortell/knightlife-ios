//
//  ITableController.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/27/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class ITableController: UITableViewController
{
	var storyboardContainer: TableContainer = TableContainer()
	private var cellHandlers: [String: (Int, UITableViewCell) -> Void] = [:]
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		self.registerCellHandlers()
	}
	
	func registerCellHandlers()
	{
//		Override point
	}
	
	func registerHandler(_ reuseId: String, handler: @escaping (Int, UITableViewCell) -> Void)
	{
		self.cellHandlers[reuseId] = handler
	}
	
	func generateContainer()
	{
//		Override point
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
	{
		if let section = self.storyboardContainer.getSection(section)
		{
			return section.title
		}
		return nil
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int
	{
		return self.storyboardContainer.sectionCount
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		if let section = self.storyboardContainer.getSection(section)
		{
			return section.cellCount
		}
		return 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let template = self.storyboardContainer.getSection(indexPath.section)!.getCell(indexPath.row)!
		let cell = self.tableView.dequeueReusableCell(withIdentifier: template.reuseId)!
		
		if let handler = self.cellHandlers[template.reuseId]
		{
			handler(template.id, cell)
		}
		
		return cell
	}
}
