//
//  SelectBlockController.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/30/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class SelectBlockController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
	@IBOutlet weak var tableView: UITableView!
	
	var selected: BlockID!
	var presentr: Presentr!
	var updatedCallback: (BlockID) -> Void = {_ in}
	
	override func viewDidLoad()
	{
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
		self.tableView.reloadData()
		
		self.presentr.dismissTransitionType = .coverVertical
	}
	
	@IBAction func cancelClicked(_ sender: Any)
	{
		self.dismiss(animated: true, completion: {})
	}
	
	@IBAction func acceptClicked(_ sender: Any)
	{
		self.presentr.dismissTransitionType = .crossDissolve
		self.dismiss(animated: true, completion: {})
		self.updatedCallback(self.selected)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return BlockID.academicBlocks().count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let id = BlockID.academicBlocks()[indexPath.row]
		
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! SelectBlockCell
		cell.cellLabel.text = id.displayName
		cell.accessoryType = self.selected == id ? .checkmark : .none
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		return 50.0
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		let path = IndexPath(row: BlockID.academicBlocks().index(of: self.selected)!, section: 0)
		self.selected = BlockID.academicBlocks()[indexPath.row]
		self.tableView.reloadRows(at: [indexPath, path], with: .automatic)
	}
}

class SelectBlockCell: UITableViewCell
{
	@IBOutlet weak fileprivate var cellLabel: UILabel!
}
