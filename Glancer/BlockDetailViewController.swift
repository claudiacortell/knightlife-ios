//
//  BlockDetailViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/12/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class BlockDetailViewController: UIViewController
{
	@IBOutlet private weak var refreshControl: UIActivityIndicatorView!
	var childView: BlockDetailTableViewController!
	
	var date: EnscribedDate!
	var block: ScheduleBlock!
	var daySchedule: DateSchedule!
	
	func stopRefreshing()
	{
		self.refreshControl.stopAnimating()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if segue.identifier == "embed"
		{
			self.childView = segue.destination as! BlockDetailTableViewController
		
			self.childView.date = date
			self.childView.block = block
			self.childView.daySchedule = daySchedule
			
			self.childView.controller = self
			self.childView.view.isHidden = true
		}
	}
}
