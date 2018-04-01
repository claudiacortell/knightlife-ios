//
//  ConfirmController.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/31/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import Presentr

class ConfirmController: UIViewController
{
	var presentr: Presentr?
	var acceptCallback: () -> Void = {}
	var question: String?
	
	@IBOutlet weak var questionLabel: UILabel!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.questionLabel.text = self.question
		if self.presentr != nil { self.presentr!.dismissTransitionType = .coverVertical }
	}
	
	@IBAction func acceptClicked()
	{
		self.acceptCallback()
		
		if self.presentr != nil
		{
			self.presentr!.dismissTransitionType = .crossDissolve
			self.dismiss(animated: true, completion: {})
		}
	}
	
	@IBAction func cancelClicked()
	{
		self.dismiss(animated: true, completion: {})
	}
}
