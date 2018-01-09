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
	var date: EnscribedDate = TimeUtils.todayEnscribed
	
	var daySchedule: DateSchedule?
	var meetings: DayCourseList!
	
	var hasLoadedForTheFirstTime = false
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.setLoading()
		self.reload(hard: false, refresh: false, delay: false)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if let detail = segue.destination as? BlockDetailTableViewController, let cell = sender as? BlockTableBlockViewCell
		{
			detail.schedule = self.daySchedule!
			detail.block = cell.block
		}
	}
	
	private func setLoading()
	{
		if self.hasLoadedForTheFirstTime
		{
			return
		}

		var container = TableContainer()
		var blockSection = TableSection() // Blocks
		
		blockSection.cells.append(TableCell("loading", id: 15, height: CGFloat(510)))
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
				blockCell.block = block
				
				let analyst = BlockAnalyst(block, schedule: self.daySchedule!)
				blockCell.blockName = analyst.getDisplayName()
				blockCell.blockLetter = analyst.getDisplayLetter()
				blockCell.color = analyst.getColor()
				
				blockCell.time = block.time
			}
		})
		
		self.registerCellHandler("masthead", handler:
		{ id, cell in
			if let blockCell = cell as? BlockTableMastheadViewCell, let templateCell = self.storyboardContainer.getCell(id)
			{
				blockCell.clearSubtitles()
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
				
				if self.daySchedule != nil
				{
					if let subtitle = self.daySchedule?.subtitle
					{
						blockCell.addEmphasizedSubtitle(subtitle)
						blockCell.addEmphasizedSubtitle("")
					}
					
					if let first = self.daySchedule!.getFirstBlock(), let last = self.daySchedule!.getLastBlock()
					{
						blockCell.addSubtitle("\(first.time.startTime.toString()) - \(last.time.endTime.toString())")
						blockCell.addSubtitle("\(self.daySchedule!.getBlocks().count) Blocks")						
					}
					
					if self.daySchedule!.changed
					{
						blockCell.setScheduleChanged()
					}
				}
				
				self.storyboardContainer.setHeight(templateCell, height: blockCell.height)
			}
		})
	}
	
	private func reload(hard: Bool = true, refresh: Bool = true, delay: Bool = true)
	{
		if refresh
		{
			self.refreshControl?.beginRefreshing()
		}
		
		if hard
		{
			ScheduleManager.instance.fetchDaySchedule(self.date,
			{ fetch in
				self.scheduleDidLoad(fetch.hasData, schedule: fetch.data, delay: delay)
			})
		} else
		{
			let status = ScheduleManager.instance.getSchedule(self.date)
			if status.status == .dead
			{
				self.reload(hard: true, refresh: refresh)
			} else
			{
				self.scheduleDidLoad(status.hasData, schedule: status.data, delay: delay)
			}
		}
	}
	
	private func scheduleDidLoad(_ success: Bool, schedule: DateSchedule?, delay: Bool)
	{
		if delay
		{
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1)
			{
				HapticUtils.IMPACT.impactOccurred()
				self.executeLoaded(success, schedule: schedule)
			}
		} else
		{
			self.executeLoaded(success, schedule: schedule)
		}
	}
	
	private func executeLoaded(_ success: Bool, schedule: DateSchedule?)
	{
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
				itemSection.cells.append(TableCell("block", id: block.hashValue, height: 65))
				container.sections.append(itemSection)
			}
		}
		
		self.storyboardContainer = container
	}
}
