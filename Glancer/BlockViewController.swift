//
//  BlockViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 1/9/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class BlockViewController: UIViewController
{
	@IBOutlet private weak var refreshControl: UIActivityIndicatorView!
	var childView: BlockTableViewController!

	func stopRefreshing()
	{
		self.refreshControl.stopAnimating()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if segue.identifier == "embed"
		{
			self.childView = segue.destination as? BlockTableViewController
			
			self.childView.controller = self
			self.childView.view.isHidden = true
		}
	}
}
