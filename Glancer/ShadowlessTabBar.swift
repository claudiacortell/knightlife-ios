//
//  ShadowlessTabBar.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/27/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class ShadowlessTabBar: UITabBarController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.tabBar.backgroundImage = UIImage()
		self.tabBar.shadowImage = UIImage()
		
		self.tabBar.unselectedItemTintColor = UIColor.lightGray
		self.tabBar.tintColor = UIColor.darkGray
	}
}
