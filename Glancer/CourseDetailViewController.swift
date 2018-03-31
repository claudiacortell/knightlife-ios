//
//  CourseDetailViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/28/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import Presentr

class CourseDetailViewController: UITableViewController
{
	var course: Course!
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var blockLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	
	let textPresentr: Presentr =
	{
		let presentr = Presentr(presentationType: .alert)
		presentr.roundCorners = true
		presentr.cornerRadius = 12.0
		return presentr
	}()
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		self.reload()
	}
	
	private func reload()
	{
		self.titleLabel.text = self.course.name
		
		if let schedule = self.course.courseSchedule
		{
			self.blockLabel.text = schedule.block.displayName
		} else
		{
			self.blockLabel.text = "-"
		}
		
		self.locationLabel.text = self.course.location ?? "-"
	}
	
	@IBAction func editTitle(_ sender: UIButton)
	{
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "EnterTextController") as? EnterTextController
		{
			controller.presentr = self.textPresentr
			
			controller.allowNullValues = false
			controller.nullMessage = "You must enter a name"
			
			controller.prepopulate = self.course.name
			
			controller.didChangeText =
			{ text in
				self.course.name = text!
				self.reload()
			}
			self.customPresentViewController(self.textPresentr, viewController: controller, animated: true, completion: nil)
		}
	}
	
	@IBAction func editLocation(_ sender: UIButton)
	{
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "EnterTextController") as? EnterTextController
		{
			controller.presentr = self.textPresentr
			
			controller.allowNullValues = true
			
			controller.prepopulate = self.course.location
			
			controller.didChangeText =
			{ text in
				self.course.location = text
				self.reload()
			}
			self.customPresentViewController(self.textPresentr, viewController: controller, animated: true, completion: nil)
		}
	}
	
	@IBAction func changeBlock(_ sender: UIButton)
	{
		
	}
	
	@IBAction func deleteCourse(_ sender: UIButton)
	{
		
	}
}
