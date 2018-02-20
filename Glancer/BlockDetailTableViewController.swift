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
	var error = false
	
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
		
		if self.block.blockId == .lunch
		{
			self.chainedResourceFetches.append
			{
				if let menu = LunchManager.instance.menuHandler.getMenu(self.date, hard: hard, callback:
				{ error, data in
					if let result = data
					{
						self.lunch = result
						self.nextChainLink(hapticFeedback)
					} else
					{
						self.dataFailedToLoad(hapticFeedback)
					}
				})
				{
					self.lunch = menu
					self.nextChainLink(hapticFeedback)
				}
			}
		}
		
		self.nextChainLink(hapticFeedback)
	}
	
	private func nextChainLink(_ hapticFeedback: Bool)
	{
		if !self.chainedResourceFetches.isEmpty
		{
			self.chainedResourceFetches.removeFirst()()
		} else
		{
			self.dataDidLoad(hapticFeedback)
		}
	}
	
	private func dataFailedToLoad(_ hapticFeedback: Bool)
	{
		self.error = true
		self.dataFinishedLoading(hapticFeedback: hapticFeedback)
	}
	
	private func dataDidLoad(_ hapticFeedback: Bool)
	{
		self.error = false
		self.dataFinishedLoading(hapticFeedback: hapticFeedback)
	}
	
	private func dataFinishedLoading(hapticFeedback: Bool)
	{
		if hapticFeedback
		{
			HapticUtils.IMPACT.impactOccurred()
		}
		
		self.controller.stopRefreshing()
		self.refreshControl?.endRefreshing()
		
		self.view.isHidden = false
		self.reloadTable()
	}
	
	override func generateSections()
	{
//		if self.error
//		{
//			let section = TableSection()
//			let errorCell = TableCell("error")
//
//			errorCell.setHeight(self.view.frame.height)
//			section.addCell(errorCell)
//
//			self.addTableSection(section)
//		} else
//		{
		var section = TableSection()
		section.addCell(TableCell("popup"))
		self.addTableSection(section)
		
//			self.addTableModule(BlockDetailModuleMasthead(self))
//		}
	}
}
