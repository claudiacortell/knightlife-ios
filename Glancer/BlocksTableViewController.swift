//
//  BlocksViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import UIKit

class BlocksTableViewController: UITableViewController, ITable
{
	var storyboardContainer: TableContainer!
	var date: EnscribedDate = TimeUtils.todayEnscribed
	var daySchedule: DaySchedule!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		navigationController!.navigationBar.prefersLargeTitles = true

		self.storyboardContainer = TableContainer()
		
		self.reload()
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
	}
	
	private func reload(_ hard: Bool = false)
	{
		self.showLoadingSymbol(true)
		ScheduleManager.instance.retrieveBlockList(hard: hard, date: self.date, execute:
			{ fetch in
				self.scheduleDidLoad(fetch.data != nil, schedule: fetch.data)
		})
	}
	
	private func scheduleDidLoad(_ success: Bool, schedule: DaySchedule?)
	{
		if success
		{
			self.daySchedule = nil
			self.daySchedule = schedule!
			
			self.generateContainer()
			
			self.showLoadingSymbol(false)
			self.tableView.reloadData()
		} else
		{
			//			Display error message
		}
	}
	
	func generateContainer()
	{
		var container = TableContainer()

		var blockSection = TableSection() // Blocks
		blockSection.title = "Blocks"
		blockSection.cells.append(TableCell(reuseId: "cell_header", id: 0))
		
		for block in self.daySchedule.blocks
		{
			blockSection.cells.append(TableCell(reuseId: "cell_class", id: block.hashValue))
		}
		
		container.sections.append(blockSection)
		
		self.storyboardContainer = nil
		self.storyboardContainer = container
	}
	
	private func showLoadingSymbol(_ val: Bool)
	{
		//		TODO: This
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
		return self.tableView.dequeueReusableCell(withIdentifier: template.reuseId)!
    }
	
	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
	{
		if let classCell = cell as? BlockTableClassViewCell, let tableCell = self.storyboardContainer.getSection(indexPath.section)?.getCell(indexPath.row)
		{
			if let block = self.daySchedule.getBlockByHash(tableCell.id)
			{
				classCell.block = block.blockId
				classCell.className = "Class!!!!"
				classCell.startTime = block.time.startTime
				classCell.endTime = block.time.endTime
				classCell.homework = "No Homework my dude"
				classCell.more = false
			}
		}
	}
}
