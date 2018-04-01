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
		for type in LunchMenuItemType.values
		{
			var items: [LunchMenuItem] = []
			for item in self.controller.controller.lunchMenu!.items
			{
				if item.type == type
				{
					items.append(item)
				}
			}
			
			if !items.isEmpty
			{
				let section = TableSection()
				section.title = type.rawValue.uppercased()
				section.headerHeight = 14
				
				section.headerColor = Scheme.ColorOrange
				section.headerFont = UIFont.systemFont(ofSize: 12.0, weight: .medium)
				section.headerTextColor = UIColor.white
				section.headerIndent = 15.0
				
				for item in items
				{
					let cell = TableCell("item", callback:
					{
						template, object in
						if let cell = object as? LunchMenuTableCell
						{
							cell.name = item.name
							cell.allergen = item.allergy
							
							if item.allergy == nil
							{
								cell.showsDisclosure = false
								cell.selectionStyle = UITableViewCellSelectionStyle.none
							} else
							{
								cell.showsDisclosure = true
							}
							
							let showAllergen = template.getData("show-allergen") as? Bool ?? false
							cell.showAllergen = showAllergen
							cell.rotateDisclosure = showAllergen
						}
					})
					cell.setData("item", data: item)
					section.addCell(cell)
				}
				
				self.addTableSection(section)
			}
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		tableView.deselectRow(at: indexPath, animated: true)
		
		if let template = self.storyboardContainer.getSectionByIndex(indexPath.section)?.getCellByIndex(indexPath.row)
		{
			if let item = template.getData("item") as? LunchMenuItem
			{
				if item.allergy == nil
				{
					return
				}
			}
			
			let curVal = template.getData("show-allergen") as? Bool ?? false
			template.setData("show-allergen", data: !curVal)
		}
		
		HapticUtils.SELECTION.selectionChanged()
		
		tableView.beginUpdates()
		tableView.reloadRows(at: [indexPath], with: .automatic)
		tableView.endUpdates()
	}
}
