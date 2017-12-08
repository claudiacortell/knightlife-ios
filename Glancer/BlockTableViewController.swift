//
//  BlockViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import UIKit

class BlockTableViewController: ITableController
{
	class BlocksCell
	{
		static let CELL_CLASS = "cell_class"
		static let CELL_BLOCK = "cell_block"
		static let CELL_BLOCK_HEADER = "cell_header"
		static let CELL_NOCLASS = "cell_noClass"
	}
	
	var blockViewController: BlockViewController!
	
	var date: EnscribedDate = TimeUtils.todayEnscribed
	
	var daySchedule: DaySchedule!
	var meetings: DayMeetingList!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.refreshControl?.addTarget(self, action: #selector(BlockTableViewController.doRefresh(_:)), for: .valueChanged)
		self.refreshControl?.layer.zPosition = -1
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		self.reload(false, refresh: false)
	}
	
	@objc private func doRefresh(_ sender: Any)
	{
		self.reload()
	}
	
	override func registerCellHandlers()
	{
		self.registerHandler(BlocksCell.CELL_BLOCK, handler:
		{ id, cell in
			if let blockCell = cell as? BlockTableBlockViewCell, let block = self.daySchedule.getBlockByHash(id)
			{
				blockCell.block = block.blockId
				blockCell.startTime = block.time.startTime
				blockCell.endTime = block.time.endTime
				
				if self.meetings.fromBlock(block.blockId).meetings.count > 0
				{
					blockCell.more = true
				}
			}
		})
		
		self.registerHandler(BlocksCell.CELL_CLASS, handler:
		{ id, cell in
			if let classCell = cell as? BlockTableClassViewCell, let block = self.daySchedule.getBlockByHash(id), let classMeeting = self.meetings.fromBlock(block.blockId).getClass()
			{
				classCell.block = block.blockId
				classCell.startTime = block.time.startTime
				classCell.endTime = block.time.endTime
				classCell.className = classMeeting.name
				
				if self.meetings.fromBlock(block.blockId).meetings.count > 1
				{
					classCell.more = true
				}
			}
		})
	}
	
	private func reload(_ hard: Bool = true, refresh: Bool = true)
	{
		if refresh
		{
			self.refreshControl?.beginRefreshing()
		}

		ScheduleManager.instance.retrieveBlockList(hard: hard, date: self.date, execute:
		{ fetch in
			self.scheduleDidLoad(fetch.data != nil, schedule: fetch.data)
		})
	}
	
	private func scheduleDidLoad(_ success: Bool, schedule: DaySchedule?)
	{
		if success
		{
			self.meetings = MeetingManager.instance.getMeetings(date: self.date, schedule: schedule!) // Retrieve meetings for today
			
			self.blockViewController.setTable()

			self.daySchedule = nil
			self.daySchedule = schedule!
			
			self.generateContainer()
			self.tableView.reloadData()
		} else
		{
			self.blockViewController.setError()
			
			self.daySchedule = nil
			
			self.storyboardContainer = TableContainer()
			self.tableView.reloadData()
		}
		self.refreshControl?.endRefreshing()
	}
	
	let variation = 1

	override func generateContainer()
	{
		var container = TableContainer()

		var blockSection = TableSection() // Blocks
		
		if self.daySchedule.blocks.isEmpty // No blocks today
		{
			blockSection.cells.append(TableCell(reuseId: BlocksCell.CELL_NOCLASS, id: 0))
		} else
		{
			blockSection.cells.append(TableCell(reuseId: BlocksCell.CELL_BLOCK_HEADER, id: 0))
			
			for block in self.daySchedule.getScheduleVariation(variation) // Testing variations
			{
				let meetingList = self.meetings.fromBlock(block.blockId)
				
				if meetingList.hasClass()
				{
					blockSection.cells.append(TableCell(reuseId: BlocksCell.CELL_CLASS, id: block.hashValue))
				} else
				{
					blockSection.cells.append(TableCell(reuseId: BlocksCell.CELL_BLOCK, id: block.hashValue))
				}
			}
		}
		
		container.sections.append(blockSection)
		
		self.storyboardContainer = container
	}
}
