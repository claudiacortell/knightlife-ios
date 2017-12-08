//
//  SportsViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/7/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class SportsViewController: UIViewController
{	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.navigationItem.setRightBarButton(self.getSportsButton(), animated: false)
	}
	
	@objc func sportsClicked(_ sender: Any)
	{
		self.dismiss(animated: false, completion: nil)
	}

	private func getSportsButton() -> UIBarButtonItem
	{
		let button = UIButton(type: .roundedRect)
		
		button.layer.cornerRadius = 6.0
		button.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
		button.setImage(#imageLiteral(resourceName: "icon_sports"), for: .normal)
		button.layer.backgroundColor = UIColor(red: 14.0 / 255, green: 122.0 / 255, blue: 254.0 / 255, alpha: 1.0).cgColor
		button.tintColor = UIColor.white

		button.addTarget(self, action: #selector(SportsViewController.sportsClicked(_:)), for: .touchUpInside)

		let barButton = UIBarButtonItem(customView: button)
		return barButton
	}
}
