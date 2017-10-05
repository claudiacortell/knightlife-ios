//
//  TabBarManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/5/17.
//  Copyright © 2017 Vishnu Murale. All rights reserved.
//

import Foundation

class TabBarController: UITabBarController
{
	override func viewDidLoad()
	{
		// TODO: Preload all the things.
	}
	
	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
	{
		
	}
}

protocol TabBarChild
{
	func tabBarItemSelected(item: UITabBarItem)
}
