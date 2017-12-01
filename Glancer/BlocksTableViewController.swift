//
//  BlocksViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import UIKit

class BlocksTableViewController: ITableController
{
	class BlocksCell
	{
		static let CELL_CLASS = "cell_class"
		static let CELL_BLOCK = "cell_block"
		static let CELL_BLOCK_HEADER = "cell_header"
	}
	
	var date: EnscribedDate = TimeUtils.todayEnscribed
	var daySchedule: DaySchedule!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		navigationController!.navigationBar.prefersLargeTitles = true
		
		self.reload()
	}
	
	@IBAction func buttonReload(_ sender: Any)
	{
		self.reload(true)
	}
	
	override func registerCellHandlers()
	{
		self.registerHandler(BlocksCell.CELL_CLASS, handler:
			{ id, cell in
				if let classCell = cell as? BlockTableClassViewCell, let block = self.daySchedule.getBlockByHash(id)
				{
					classCell.block = block.blockId
					classCell.className = "Class!!!!"
					classCell.startTime = block.time.startTime
					classCell.endTime = block.time.endTime
					classCell.homework = "No Homework my dude"
				}
		})
		
		
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
	
	let variation = 1

	override func generateContainer()
	{
		var container = TableContainer()

		var blockSection = TableSection() // Blocks
		blockSection.title = "Blocks"
		blockSection.cells.append(TableCell(reuseId: BlocksCell.CELL_BLOCK_HEADER, id: 0))
		
		for block in self.daySchedule.getScheduleVariation(variation) // Testing variations
		{
			blockSection.cells.append(TableCell(reuseId: BlocksCell.CELL_BLOCK, id: block.hashValue))
		}
		
		container.sections.append(blockSection)
		
		self.storyboardContainer = container
	}
	
	private func showLoadingSymbol(_ val: Bool)
	{
		
		
		//		TODO: This
	}
}
