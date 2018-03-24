//
//  LunchMenuViewTableController.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/23/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class LunchMenuViewTableController: ITableController
{
	var controller: LunchMenuViewController!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.estimatedRowHeight = 40.0
		
		self.tableView.reloadData()
	}
	
	override func generateSections()
	{
		let section = TableSection()
		section.addSpacerCell(5)
		for item in self.controller.controller.lunchMenu!.items
		{
			section.addCell(TableCell("item", callback:
			{
				template, object in
				if let cell = object as? LunchMenuTableCell
				{
					cell.name = item.name
					cell.category = item.type
					cell.allergen = item.allergy
					
					cell.showAllergen = template.getData("show-allergen") as? Bool ?? false
				}
			}))
		}
		
		self.addTableSection(section)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		tableView.deselectRow(at: indexPath, animated: true)
		
		if let template = self.storyboardContainer.getSectionByIndex(indexPath.section)?.getCellByIndex(indexPath.row)
		{
			let curVal = template.getData("show-allergen") as? Bool ?? false
			template.setData("show-allergen", data: !curVal)
		}
		
		tableView.beginUpdates()
		tableView.reloadRows(at: [indexPath], with: .automatic)
		tableView.endUpdates()
	}
}
