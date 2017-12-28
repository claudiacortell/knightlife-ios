//
//  BlockViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/1/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit

class BlockViewController: UIViewController
{
	@IBOutlet weak var loadingIcon: UIActivityIndicatorView!
	@IBOutlet weak var errorIcon: UIView!
	@IBOutlet weak var blockTableContainerView: UIView!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.navigationItem.setRightBarButton(self.getSportsButton(), animated: false)
		
		for viewController in self.childViewControllers
		{
			if let blockTableViewController = viewController as? BlockTableViewController
			{
				blockTableViewController.blockViewController = self
				break
			}
		}
		
		self.setLoading()
	}
	
	@objc func sportsClicked(_ sender: Any)
	{
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "controller_sports") as? SportsViewController
		{
			self.navigationController?.pushViewController(controller, animated: false)
		}
	}

	private func getSportsButton() -> UIBarButtonItem
	{
		let button = UIButton(type: .roundedRect)
		
		button.layer.cornerRadius = 6.0
		button.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
		button.setImage(#imageLiteral(resourceName: "icon_sports"), for: .normal)
		
		button.addTarget(self, action: #selector(BlockViewController.sportsClicked(_:)), for: .touchUpInside)
		
		let barButton = UIBarButtonItem(customView: button)
		return barButton
	}
	
	func setLoading()
	{
		self.loadingIcon.isHidden = false
		self.errorIcon.isHidden = true
		self.blockTableContainerView.isHidden = true
	}
	
	func setError()
	{
		self.loadingIcon.isHidden = true
		self.errorIcon.isHidden = false
		self.blockTableContainerView.isHidden = false
	}
	
	func setTable()
	{
		self.loadingIcon.isHidden = true
		self.errorIcon.isHidden = true
		self.blockTableContainerView.isHidden = false
	}
}
