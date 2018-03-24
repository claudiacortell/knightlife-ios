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
	private(set) var modules: [TableModule] = []
	
	override func viewDidLoad()
	{
		super.viewDidLoad()		
	}
	
	func reloadTable()
	{
		self.storyboardContainer = TableContainer()
		self.modules.removeAll()

		self.generateSections()

		for module in self.modules // Modules
		{
			module.generateSections(container: self.storyboardContainer)
		}
		
		self.tableView.reloadData()
	}
	
	func generateSections() { }
	
	func reloadEachRowIndividually(_ animation: UITableViewRowAnimation = .automatic)
	{
		var indices: [IndexPath] = []
		for x in 0..<self.storyboardContainer.sectionCount
		{
			for y in 0..<self.storyboardContainer.getSectionByIndex(x)!.cellCount
			{
				indices.append(IndexPath(row: y, section: x))
			}
		}
		
		self.tableView.reloadRows(at: indices, with: animation)
	}
	
	func addTableModule(_ module: TableModule)
	{
		self.modules.append(module)
	}
	
	func addTableSection(_ section: TableSection)
	{
		self.storyboardContainer.addSection(section)
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
	{
		if let section = self.storyboardContainer.getSectionByIndex(section)
		{
			return section.title
		}
		return super.tableView(tableView, titleForHeaderInSection: section)
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int
	{
		return self.storyboardContainer.sectionCount
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		if let section = self.storyboardContainer.getSectionByIndex(section)
		{
			return section.cellCount
		}
		return super.tableView(tableView, numberOfRowsInSection: section)
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let templateCell = self.storyboardContainer.getSectionByIndex(indexPath.section)!.getCellByIndex(indexPath.row)!
		if templateCell.reuseId == "spacer"
		{
			let cell = UITableViewCell()
			cell.selectionStyle = .none
			return cell
		} else
		{
			let cell = self.tableView.dequeueReusableCell(withIdentifier: templateCell.reuseId)!
			templateCell.callback(templateCell, cell)
			return cell
		}
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		if let section = self.storyboardContainer.getSectionByIndex(indexPath.section), let cell = section.getCellByIndex(indexPath.row), let height = cell.height
		{
			return CGFloat(height)
		}
		return super.tableView(tableView, heightForRowAt: indexPath)
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
	{
		if let section = self.storyboardContainer.getSectionByIndex(section), let height = section.headerHeight
		{
			return CGFloat(height)
		}
		return super.tableView(tableView, heightForHeaderInSection: section)
	}
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
	{
		if let section = self.storyboardContainer.getSectionByIndex(section), let height = section.footerHeight
		{
			return CGFloat(height)
		}
		return super.tableView(tableView, heightForFooterInSection: section)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		if self.clearsSelectionOnViewWillAppear
		{
			self.tableView.deselectRow(at: indexPath, animated: true)
		}
	}
}
