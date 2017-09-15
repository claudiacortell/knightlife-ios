//
//  ColorSelectionViewController.swift
//  Glancer
//
//  Created by Cassandra Kane on 6/11/16.
//  Copyright © 2016 Vishnu Murale. All rights reserved.
//

import UIKit

class ColorSelectionViewController: UIViewController
{
	var block: BlockID?
	
    override func viewDidLoad()
	{
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
	{
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		let background = self.view.layer.backgroundColor
		if background != nil && self.block != nil
		{
			var meta = UserPrefsManager.instance.blockMeta[self.block!]
			if meta != nil
			{
				meta!.customColor = Utils.getHexFromCGColor(background!)
			}
		}
		let tabBar: UITabBarController = segue.destination as! UITabBarController
        tabBar.selectedIndex = 2
	}
}
