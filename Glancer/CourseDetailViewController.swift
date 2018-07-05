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
import AddictiveLib

class CourseDetailViewController: UITableViewController
{
	var course: Course!
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var blockLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	
	@IBOutlet weak var dateSelectCell: UITableViewCell!
	@IBOutlet weak var buttonContainer: UIStackView!
	private var defaultDateIndex: IndexPath?
	
	@IBOutlet weak var segmentControl: UISegmentedControl!
	
	let alertPresenter: Presentr =
	{
		let presentr = Presentr(presentationType: .alert)
		presentr.roundCorners = true
		presentr.cornerRadius = 12.0
		return presentr
	}()
	
	let popupPresenter: Presentr =
	{
		let presentr = Presentr(presentationType: .popup)
		presentr.roundCorners = true
		presentr.cornerRadius = 12.0
		return presentr
	}()
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.estimatedRowHeight = 60.0
		
		self.reload()
	}
	
	private func reload()
	{
		self.tableView.reloadData()
		
		self.titleLabel.text = self.course.name
		self.blockLabel.text = self.course.courseSchedule.block.displayName
		self.locationLabel.text = self.course.location ?? "-"
		
		self.segmentControl.selectedSegmentIndex = self.course.courseSchedule.frequency == .everyDay ? 0 : 1
		
		for subview in self.buttonContainer.subviews
		{
			if let button = subview as? UIButton
			{
				self.setEnabled(button, self.course.courseSchedule.meetingDaysContains(Day.weekdays()[button.tag]))
			}
		}
	}
	
	@IBAction func editTitle(_ sender: UIButton)
	{
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "EnterTextController") as? EnterTextController
		{
			controller.presentr = self.alertPresenter
			controller.allowNullValues = false
			controller.nullMessage = "You must enter a name"
			controller.prepopulate = self.course.name
			controller.didChangeText =
			{ text in
				self.course.name = text!
				self.reload()
			}
			self.customPresentViewController(self.alertPresenter, viewController: controller, animated: true, completion: nil)
		}
	}
	
	@IBAction func editLocation(_ sender: UIButton)
	{
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "EnterTextController") as? EnterTextController
		{
			controller.presentr = self.alertPresenter
			controller.allowNullValues = true
			controller.prepopulate = self.course.location
			controller.didChangeText =
			{ text in
				self.course.location = text
				self.reload()
			}
			self.customPresentViewController(self.alertPresenter, viewController: controller, animated: true, completion: nil)
		}
	}
	
	@IBAction func changeBlock(_ sender: UIButton)
	{
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "SelectBlockController") as? SelectBlockController
		{
			let schedule = self.course.courseSchedule

			controller.presentr = self.popupPresenter
			controller.selected = schedule.block
			controller.updatedCallback = {
				block in
				schedule.block = block
				self.reload()
			}
			self.customPresentViewController(self.popupPresenter, viewController: controller, animated: true, completion: nil)
		}
	}
	
	@IBAction func meetingDaysChanged(_ sender: UISegmentedControl)
	{
		if sender.selectedSegmentIndex == 0 // Every day
		{
			self.course.courseSchedule.frequency = .everyDay
		} else // Specific days
		{
			self.course.courseSchedule.frequency = .specificDays
		}
		self.reload()
	}
	
	@IBAction func selectDay(_ sender: UIButton)
	{
		let day = Day.weekdays()[sender.tag]
		if self.course.courseSchedule.meetingDaysContains(day)
		{
			self.course.courseSchedule.removeMeetingDay(day)
		} else
		{
			self.course.courseSchedule.addMeetingDay(day)
		}
		self.reload()
	}
	
	private func setEnabled(_ button: UIButton, _ bool: Bool)
	{
		button.layer.borderColor = bool ? Scheme.ColorOrange.cgColor : UIColor.groupTableViewBackground.cgColor
		button.layer.backgroundColor = bool ? Scheme.ColorOrange.cgColor : UIColor.groupTableViewBackground.cgColor
		button.setTitleColor(bool ? UIColor.white : UIColor.lightGray, for: .normal)
	}
	
	@IBAction func deleteCourse(_ sender: UIButton)
	{
		if let abc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmController"), let controller = abc as? ConfirmController
		{
			controller.question = "Delete course \(self.course.name)?"
			controller.presentr = self.alertPresenter
			controller.acceptCallback = {
				CourseManager.instance.removeCourse(self.course)
				self.navigationController?.popViewController(animated: true)
			}
			self.customPresentViewController(self.alertPresenter, viewController: controller, animated: true, completion: {})
		}
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		if indexPath == (self.defaultDateIndex ?? self.tableView.indexPath(for: self.dateSelectCell))
		{
			if self.defaultDateIndex == nil { self.defaultDateIndex = self.tableView.indexPath(for: self.dateSelectCell) }
			return self.course.courseSchedule.frequency == .everyDay ? 0.0 : UITableViewAutomaticDimension
		}
		return super.tableView(tableView, heightForRowAt: indexPath)
	}
}
