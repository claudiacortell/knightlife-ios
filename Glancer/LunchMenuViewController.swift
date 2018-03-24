//
//  LunchMenuViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/20/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import Presentr

class LunchMenuViewController: UIViewController
{
	var controller: BlockViewController!
	var tableController: LunchMenuViewTableController!
	
	@IBOutlet weak var menuTitle: UILabel!
	@IBOutlet weak var menuSubtitle: UILabel!
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if let destination = segue.destination as? LunchMenuViewTableController
		{
			self.tableController = destination
			destination.controller = self
		}
	}
	
	override func viewDidLoad()
	{
		if let lunch = self.controller.lunchMenu
		{
			if let title = lunch.title
			{
				self.menuSubtitle.text = title
				self.menuSubtitle.isHidden = false
			} else
			{
				self.menuSubtitle.isHidden = true
			}
			
			self.tableController.reloadTable()
		}
	}
}
