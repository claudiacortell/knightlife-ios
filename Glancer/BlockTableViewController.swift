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
	var controller: BlockViewController!

	var date: EnscribedDate = TimeUtils.todayEnscribed
	
	var daySchedule: DateSchedule?
	var lunchMenu: LunchMenu?
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
				
		self.buildRefreshControl()
		self.reload(hard: false, delayResult: false, useRefreshControl: false, hapticFeedback: false)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if let container = segue.destination as? BlockDetailViewController, (segue.identifier != nil && segue.identifier! == "detail")
		{			
			if let cell = sender as? BlockTableBlockViewCell
			{
				container.daySchedule = self.daySchedule!
				container.block = cell.block
				container.date = self.date
			}
		}
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
		
		let chain = ResourceChain(success:
		{
			self.delayResult(delayResult, hapticFeedback: hapticFeedback)
		}, failure: {
			self.daySchedule = nil
			self.lunchMenu = nil
			
			self.delayResult(delayResult, hapticFeedback: hapticFeedback)
		})
		
		chain.addLink()
		{ parent in
			if let schedule = ScheduleManager.instance.patchHandler.getSchedule(self.date, hard: hard, callback: // Pass both our callback and our sync method to the schedule handler to interpret.
			{ error, result in
				self.daySchedule = result
				parent.nextLink(result != nil)
			})
			{
				self.daySchedule = schedule
				parent.nextLink(true)
			}
		}
		
		chain.addLink()
		{
			parent in
			if let lunch = LunchManager.instance.menuHandler.getMenu(self.date, hard: hard, callback:
			{
				error, result in
				self.lunchMenu = result
				parent.nextLink(true) // Ignore any errors and continue; it's just a lunch menu. Being null is fine.
			})
			{
				self.lunchMenu = lunch
				parent.nextLink(true)
			}
		}
		
		chain.start()
	}
	
	private func delayResult(_ delay: Bool, hapticFeedback: Bool)
	{
		if delay
		{
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1)
			{
				self.closeLoop(hapticFeedback: hapticFeedback)
			}
		} else
		{
			self.closeLoop(hapticFeedback: hapticFeedback)
		}
	}
	
	private func closeLoop(hapticFeedback: Bool)
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
		if self.daySchedule == nil
		{
			let section = TableSection()
			let errorCell = TableCell("error")
			
			errorCell.setHeight(self.view.frame.height)
			section.addCell(errorCell)
			
			self.addTableSection(section)
		} else if self.daySchedule!.isEmpty
		{
			self.addTableModule(BlockTableModuleMasthead(controller: self))
			
			let section = TableSection()
			let classCell = TableCell("no_class")
			
			classCell.setHeight(self.view.frame.height)
			section.addCell(classCell)
			
			self.addTableSection(section)
		} else
		{
			self.addTableModule(BlockTableModuleMasthead(controller: self))

			if TimeUtils.isToday(self.date)
			{
				self.addTableModule(BlockTableModuleToday(controller: self))
			}
			
			self.addTableModule(BlockTableModuleBlocks(controller: self))
		}
	}
	
	@IBAction func openLunchMenu(_ sender: Any)
	{
		self.controller.openLunchMenu()
	}
}
