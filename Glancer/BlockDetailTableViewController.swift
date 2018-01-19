//
//  BlockDetailTableViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/8/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class BlockDetailTableViewController: ITableController
{
	var controller: BlockDetailViewController!
	
	var date: EnscribedDate!
	
	var block: ScheduleBlock!
	var daySchedule: DateSchedule!

	var lunch: LunchMenu?
	var meetings: BlockCourseList?

	var chainedResourceFetches: [() -> Void] = []
	var processing = false
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
				
		self.buildRefreshControl()
		self.reload(hard: false, delayResult: false, useRefreshControl: false, hapticFeedback: false)
	}
	
	private func buildRefreshControl()
	{
		self.refreshControl = UIRefreshControl()
		self.refreshControl?.addTarget(self, action: #selector(forceReload), for: .valueChanged)
		
		self.refreshControl?.layer.zPosition = -1
		self.refreshControl?.layer.backgroundColor = UIColor("FFB53D").cgColor
		self.refreshControl?.tintColor = UIColor.white
	}
	
	@objc private func forceReload()
	{
		self.reload(hard: true, delayResult: true, useRefreshControl: true, hapticFeedback: true)
	}
	
	private func reload(hard: Bool, delayResult: Bool, useRefreshControl: Bool, hapticFeedback: Bool)
	{
		if useRefreshControl
		{
			self.refreshControl!.beginRefreshing()
		}
		
		if hapticFeedback
		{
			HapticUtils.IMPACT.impactOccurred()
		}
		
		self.chainedResourceFetches.removeAll()
		self.processing = true
		
		if self.block.blockId == .lunch
		{
			self.chainedResourceFetches.append
			{
				LunchManager.instance.getMenu(self.date, forceRefresh: hard, allowRemoteFetch: true, success:
				{ result in
//					self.delayResult(result.menu, delayResult: delayResult, hapticFeedback: hapticFeedback)
//					{ args in
//						self.lunch = result.menu
//						self.nextChainLink()
//					}
				}, failure:
				{ error in
					self.dataFailedToLoad()
				})
			}
		}
		
		self.nextChainLink()
	}
	
	private func nextChainLink()
	{
		if !self.chainedResourceFetches.isEmpty
		{
			self.chainedResourceFetches.removeFirst()()
		} else
		{
			self.dataDidLoad()
		}
	}
	
	private func dataFailedToLoad()
	{
		
	}
	
	private func dataDidLoad()
	{
		
	}
	
	private func scheduleDidLoad(_ schedule: DateSchedule?, hapticFeedback: Bool)
	{
		if hapticFeedback
		{
			HapticUtils.IMPACT.impactOccurred()
		}
		
		self.daySchedule = schedule
		
		self.controller.stopRefreshing()
		self.refreshControl?.endRefreshing()
		
		self.view.isHidden = false
		self.reloadTable()
	}
	
	override func generateSections()
	{
		if self.daySchedule == nil
		{
			var section = TableSection()
			var errorCell = TableCell("error")
			errorCell.setHeight(self.view.frame.height)
			section.addCell(errorCell)
			self.addTableSection(section)
		} else if self.daySchedule!.isEmpty
		{
//			self.addTableModule(BlockTableModuleMasthead(controller: self))
			
			var section = TableSection()
			var classCell = TableCell("noClass")
			classCell.setHeight(self.view.frame.height)
			section.addCell(classCell)
			self.addTableSection(section)
		} else
		{
//			self.addTableModule(BlockTableModuleMasthead(controller: self))
//			self.addTableModule(BlockTableModuleBlocks(controller: self))
		}
	}
}
