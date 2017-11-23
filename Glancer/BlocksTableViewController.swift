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
	var storyboardContainer: TableContainer?
	var date: EnscribedDate?
	{
		didSet
		{
//			self.generateContainer() // Generate container when the current date is changed.
		}
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.date = TimeUtils.todayEnscribed
	}
	
	func generateContainer()
	{
//		var container = TableContainer()
//
//        if self.date != nil
//        {
//            if let blocks = ScheduleManager.instance.retrieveBlockList(date: self.date!)
//            {
//                var section = TableSection()
//
//                if blocks.blocks.isEmpty
//                {
//
//                } else
//                {
//                    for block in blocks.blocks
//                    {
//                        section.cells.append(TableCell(reuseId: "", id: block.hashValue))
//                    }
//                }
//                container.sections.append(section)
//            }
//
//            var sportsSection = TableSection()
//            sportsSection.title = "Sports"
//
//            for sport in SportsManager.instance.retrieveMeetings(self.date!)
//            {
//
//            }
//            container.sections.append(sportsSection)
//        }
//		self.storyboardContainer = container
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int
	{
        if let count = self.storyboardContainer?.sections.count
        {
            return count
        }
        return -1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
        if let count = self.storyboardContainer?.getSection(id: section)?.cellCount
        {
            return count
        }
        return -1
    }
	
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//
//    }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
	{
        if let title = self.storyboardContainer?.getSection(id: section)?.title
        {
            return title
        }
        return nil
    }
	
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        if let cell = self.storyboardContainer?.getSection(id: indexPath.section)?.getCell(id: indexPath.row)
//        {
//            if let val = self.tableView.dequeueReusableCell(withIdentifier: cell.reuseId)
//            {
//                return val
//            }
//        }
////        Blank cell
//    }
}
