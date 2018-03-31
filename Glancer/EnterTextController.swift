//
//  EnterTextController.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/30/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import Presentr

class EnterTextController: UIViewController, UITextFieldDelegate
{
	var didChangeText: (String?) -> Void = {_ in}
	var presentr: Presentr!
	
	var prepopulate: String?
	
	var allowNullValues: Bool = false
	var nullMessage: String?
	
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var nullLabel: UILabel!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.textField.delegate = self
		self.presentr.dismissTransitionType = TransitionType.coverVertical
		
		self.textField.text = self.prepopulate
		
		self.nullLabel.text = self.nullMessage
		self.nullLabel.layer.opacity = 0.0
	}
	
	@IBAction func didCancel(_ sender: UIButton)
	{
		self.textField.endEditing(true)
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func didAccept(_ sender: UIButton)
	{
		if (self.textField.text == nil || self.textField.text == "") && !self.allowNullValues
		{
			self.nullLabel.layer.opacity = 1.0
			UIView.animate(withDuration: 0.5, delay: 3.0, options: .curveLinear, animations: { self.nullLabel.layer.opacity = 0.0 }, completion: nil)
			return
		}
		
		self.presentr.dismissTransitionType = TransitionType.crossDissolve
		
		self.textField.endEditing(true)
		self.dismiss(animated: true, completion: nil)
		
		var text: String? = self.textField.text
		if text == "" { text = nil }
		
		self.didChangeText(text)
	}
}
