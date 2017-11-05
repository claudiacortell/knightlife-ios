//
//  BlocksViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation
import UIKit

class BlocksTableViewController: UITableViewController, Storyboardable
{
	var storyboardContainer: StoryboardContainer?
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
	}
	
	func generateContainer()
	{
		var container = StoryboardContainer()
		
		if let blocks = ScheduleManager.instance.retrieveBlockList()
		{
			if blocks.blocks.isEmpty
			{
				
			}
			
			for block in blocks.blocks
			{
				
			}
		} else
		{
//			ERROR
		}
		
		for sport in SportsManager.instance.retrieveMeetings()
		{
			
		}
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int
	{
		return 2 // Blocks + Sports
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
	{
		
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		
	}
}
