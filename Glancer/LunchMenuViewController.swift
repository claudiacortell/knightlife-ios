//
//  LunchMenuViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/20/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib

class LunchMenuViewController: UIViewController, TableBuilder
{
	var controller: BlockViewController!
	@IBOutlet weak var tableRef: UITableView!
	private var tableHandler: TableHandler!
	
	@IBOutlet weak var menuTitle: UILabel!
	@IBOutlet weak var menuSubtitle: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableHandler = TableHandler(table: self.tableRef)
		self.tableHandler.builder = self
		
		if let lunch = self.controller.lunchMenu {
			if let title = lunch.title {
				self.menuSubtitle.text = title
				self.menuSubtitle.isHidden = false
			} else {
				self.menuSubtitle.isHidden = true
			}
		}
		
		self.tableRef.rowHeight = UITableViewAutomaticDimension
		self.tableRef.estimatedRowHeight = 40.0
		
		self.tableRef.reloadData()
	}
	
	func buildCells(layout: TableLayout) {
		for type in LunchMenuItemType.values {
			var items: [LunchMenuItem] = []
			for item in self.controller.lunchMenu!.items {
				if item.type == type {
					items.append(item)
				}
			}
			
			if !items.isEmpty {
				let section = layout.addSection()
				section.setTitle(type.rawValue.uppercased())
				section.setHeaderHeight(14)
				section.setHeaderColor(Scheme.ColorOrange)
				section.setHeaderFont(UIFont.systemFont(ofSize: 12.0, weight: .medium))
				section.setHeaderTextColor(UIColor.white)
				section.setHeaderIndent(15)
				
				for item in items {
					let cell = section.addCell("item")
					
					cell.setCallback() {
						template, object in
						
						if let cell = object as? LunchMenuTableCell {
							cell.name = item.name
							cell.allergen = item.allergy
							
							if item.allergy == nil {
								cell.showsDisclosure = false
								cell.selectionStyle = UITableViewCellSelectionStyle.none
							} else {
								cell.showsDisclosure = true
							}
														
							let showAllergen: Bool = template.getMetadata("show-allergen") ?? false
							cell.showAllergen = showAllergen
							cell.rotateDisclosure = showAllergen
						}
					}
					cell.setMetadata("item", data: item)
				}
			}
		}
	}
	
//	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		tableView.deselectRow(at: indexPath, animated: true)
//
//		if let template = self.tableForm.getSection(indexPath)?.getCell(indexPath) {
//			if let item: LunchMenuItem = template.getMetadata("item") {
//				if item.allergy == nil {
//					return
//				}
//			}
//
//			template.setMetadata("show-allergen", data: !(template.getMetadata("show-allergen") ?? false))
//		}
//
//		HapticUtils.SELECTION.selectionChanged()
//		
//		tableView.beginUpdates()
//		tableView.reloadRows(at: [indexPath], with: .automatic)
//		tableView.endUpdates()
//	}
	
}
