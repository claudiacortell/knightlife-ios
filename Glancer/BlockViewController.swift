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
	}
	
	@objc func sportsClicked(_ sender: Any)
	{
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "controller_sports")
		{
			self.present(controller, animated: false, completion: nil)
		}
	}

	private func getSportsButton() -> UIBarButtonItem
	{
		let button = UIButton(type: .roundedRect)
		
		button.layer.cornerRadius = 6.0
		button.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
		button.setImage(#imageLiteral(resourceName: "icon_sports"), for: .normal)
//		button.layer.backgroundColor = UIColor(red: 14.0 / 255, green: 122.0 / 255, blue: 254.0 / 255, alpha: 1.0).cgColor
//		button.tintColor = UIColor.white
		
		button.addTarget(self, action: #selector(BlockViewController.sportsClicked(_:)), for: .touchUpInside)
		
		let barButton = UIBarButtonItem(customView: button)
		return barButton
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		self.setLoading()
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
