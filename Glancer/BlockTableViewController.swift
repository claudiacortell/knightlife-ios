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
	var date: EnscribedDate = EnscribedDate(year: 2018, month: 1, day: 11)!
	
	var daySchedule: DateSchedule?
	var meetings: DayCourseList!
	
	var hasLoadedForTheFirstTime = false
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
	
		self.reload(hard: false, refresh: false)
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		
		self.setLoading()
	}
	
	private func setLoading()
	{
		if self.hasLoadedForTheFirstTime
		{
			return
		}

		var container = TableContainer()
		var blockSection = TableSection() // Blocks
		
		blockSection.cells.append(TableCell("loading", id: 15, height: self.view.frame.height))
		container.sections.append(blockSection)
		
		self.storyboardContainer = container
		self.tableView.reloadData()
	}
	
	private func buildRefreshControl()
	{
		if self.hasLoadedForTheFirstTime
		{
			return
		}
		
		self.refreshControl = UIRefreshControl()
		self.refreshControl?.addTarget(self, action: #selector(BlockTableViewController.doRefresh), for: .valueChanged)
		
		self.refreshControl?.layer.zPosition = -1
		self.refreshControl?.layer.backgroundColor = UIColor("FFB53D").cgColor
		self.refreshControl?.tintColor = UIColor.white
		
		self.hasLoadedForTheFirstTime = true
	}
	
	@objc private func doRefresh()
	{
		HapticUtils.IMPACT.impactOccurred()
		self.reload()
	}
	
	override func registerCellHandlers()
	{
		self.registerCellHandler("block", handler:
		{ id, cell in
			if let blockCell = cell as? BlockTableBlockViewCell, let block = self.daySchedule?.getBlockByHash(id)
			{
				let analyst = BlockAnalyst(block, schedule: self.daySchedule!)
				blockCell.blockName = analyst.getDisplayName()
				blockCell.blockLetter = analyst.getDisplayLetter()
				blockCell.color = analyst.getColor()
				
				blockCell.startTime = block.time.startTime
				blockCell.endTime = block.time.endTime
			}
		})
		
		self.registerCellHandler("masthead", handler:
		{ id, cell in
			if let blockCell = cell as? BlockTableMastheadViewCell, var templateCell = self.storyboardContainer.getCell(id)
			{
				blockCell.date = self.date.prettyString

				if TimeUtils.isToday(self.date)
				{
					blockCell.scope = "TODAY"
				} else if TimeUtils.isTomorrow(self.date)
				{
					blockCell.scope = "TOMORROW";
				} else
				{
					blockCell.scope = "\(TimeUtils.daysUntil(self.date)) DAYS AWAY"
				}
				
				blockCell.clearSubtitles()
				if self.daySchedule != nil
				{
					if let first = self.daySchedule!.getFirstBlock(), let last = self.daySchedule!.getLastBlock()
					{
						blockCell.addSubtitle("\(first.time.startTime.toString()) - \(last.time.endTime.toString())")
						blockCell.addSubtitle("\(self.daySchedule!.getBlocks().count) Blocks")
					}
				}
				
				self.storyboardContainer.setHeight(templateCell, height: blockCell.height)
			}
		})
	}
	
	private func reload(hard: Bool = true, refresh: Bool = true)
	{
		if refresh
		{
			self.refreshControl?.beginRefreshing()
		}
		
		if hard
		{
			ScheduleManager.instance.fetchDaySchedule(self.date,
			{ fetch in
				self.scheduleDidLoad(fetch.hasData, schedule: fetch.data)
			})
		} else
		{
			let status = ScheduleManager.instance.getSchedule(self.date)
			if status.status == .dead
			{
				self.reload(hard: true, refresh: refresh)
			} else
			{
				self.scheduleDidLoad(status.hasData, schedule: status.data)
			}
		}
	}
	
	private func scheduleDidLoad(_ success: Bool, schedule: DateSchedule?)
	{
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1)
		{
			HapticUtils.IMPACT.impactOccurred()
			if success
			{
				self.daySchedule = schedule!
				
				self.generateContainer()
				self.tableView.reloadData()
			} else
			{
				self.daySchedule = nil
				
				self.generateContainer()
				self.tableView.reloadData()
				
			}
			
			self.buildRefreshControl()
			self.refreshControl?.endRefreshing()
		}
	}

	override func generateContainer()
	{
		var container = TableContainer()

		if self.daySchedule == nil
		{
			var blockSection = TableSection() // Blocks
			blockSection.cells.append(TableCell("error", id: 0, height: self.view.frame.height))
			container.sections.append(blockSection)
		} else if self.daySchedule!.isEmpty // No blocks today
		{
			var blockSection = TableSection()
			blockSection.cells.append(TableCell("masthead", id: 294))
			blockSection.cells.append(TableCell("noClass", id: 0))
			container.sections.append(blockSection)
		} else
		{
			var blockSection = TableSection()
			blockSection.cells.append(TableCell("masthead", id: 294))
			container.sections.append(blockSection)

			for block in self.daySchedule!.getBlocks() // Testing variations
			{
				var itemSection = TableSection()
				itemSection.headerHeight = 1
				itemSection.footerHeight = 1
				itemSection.cells.append(TableCell("block", id: block.hashValue, height: 65))
				container.sections.append(itemSection)
			}
		}
		
		self.storyboardContainer = container
	}
}
