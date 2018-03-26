//
//  NewTableTest.swift
//  Glancer
//
//  Created by Dylan Hanson on 3/22/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import Presentr

class BlockViewController: UIViewController
{
	var tableController: BlockViewTableController!
	@IBOutlet weak var headerView: UIView!
	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var headerTitle: UILabel!
	@IBOutlet weak var headerSubtitle: UILabel!
	@IBOutlet weak var headerLunchWrapper: UIView!
	
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	@IBOutlet weak var errorLabel: UILabel!
	
	var actualHeaderHeight: CGFloat { return self.stackView.frame.height }
	var visualHeaderHeight: CGFloat { return self.headerView.frame.height }
	
	private let presentr: Presentr =
	{
		let newObject = Presentr(presentationType: .popup)
		
		newObject.transitionType = .coverVertical
		newObject.dismissTransitionType = .crossDissolve
		
		newObject.roundCorners = true
		newObject.cornerRadius = 12
		
		newObject.dismissOnTap = true
		
		return newObject
	}()
	
	var date: EnscribedDate = EnscribedDate(year: 2018, month: 2, day: 26)!
	
	var daySchedule: DateSchedule?
	var lunchMenu: LunchMenu?
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		self.loadingIndicator.startAnimating()
		self.errorLabel.text = nil
		
		self.tableController.view.isHidden = true
		self.navigationItem.title = nil

		self.updateHeader()
		self.reload(hard: false, delayResult: false, useRefreshControl: false, hapticFeedback: false)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if let destination = segue.destination as? BlockViewTableController
		{
			self.tableController = destination
			destination.controller = self
			
			self.tableController.tableView.refreshControl?.addTarget(self, action: #selector(forceReload), for: .valueChanged)
		}
	}
	
	@IBAction func openLunchMenu(_ sender: Any)
	{
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "LunchViewController") as? LunchMenuViewController
		{
			controller.controller = self
			self.presentr.shouldIgnoreTapOutsideContext = true
			self.customPresentViewController(self.presentr, viewController: controller, animated: true, completion: nil)
		}
	}
	
	func didScroll(_ scroll: CGFloat)
	{
		if self.daySchedule == nil || self.daySchedule!.isEmpty
		{
			return
		}
		
		self.headerHeightConstraint.constant = -1 * scroll // -1 because the content insets mean that the content offset is (-1)*(header height)
		self.stackView.layer.opacity = (Float(min(1, max(0, self.headerHeightConstraint.constant / self.stackView.frame.height))))
		self.stackView.setNeedsDisplay()
		
		if self.visualHeaderHeight <= 0
		{
			self.navigationItem.title = self.headerTitle.text
		} else
		{
			self.navigationItem.title = nil
		}
	}
	
	@objc private func forceReload()
	{
		self.reload(hard: true, delayResult: true, useRefreshControl: true, hapticFeedback: true)
	}
	
	private func reload(hard: Bool, delayResult: Bool, useRefreshControl: Bool, hapticFeedback: Bool)
	{
		if useRefreshControl
		{
			self.tableController.refreshControl!.beginRefreshing()
		}
		
		if hapticFeedback
		{
			HapticUtils.IMPACT.impactOccurred()
		}
		
		let chain = ResourceChain(success:
		{
			self.delayResult(delayResult, hapticFeedback: hapticFeedback)
		}, failure: {
			self.daySchedule = nil
			self.lunchMenu = nil
			
			self.delayResult(delayResult, hapticFeedback: hapticFeedback)
		})
		
		chain.addLink()
		{ parent in
			if let schedule = ScheduleManager.instance.patchHandler.getSchedule(self.date, hard: hard, callback: // Pass both our callback and our sync method to the schedule handler to interpret.
				{ error, result in
					self.daySchedule = result
					parent.nextLink(result != nil)
			})
			{
				self.daySchedule = schedule
				parent.nextLink(true)
			}
		}
		
		chain.addLink()
		{
			parent in
			if let lunch = LunchManager.instance.menuHandler.getMenu(self.date, hard: hard, callback:
				{
					error, result in
					self.lunchMenu = result
					parent.nextLink(true) // Ignore any errors and continue; it's just a lunch menu. Being null is fine.
			})
			{
				self.lunchMenu = lunch
				parent.nextLink(true)
			}
		}
		
		chain.start()
	}
	
	private func delayResult(_ delay: Bool, hapticFeedback: Bool)
	{
		if delay
		{
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1)
			{
				self.closeLoop(hapticFeedback: hapticFeedback)
			}
		} else
		{
			self.closeLoop(hapticFeedback: hapticFeedback)
		}
	}
	
	private func closeLoop(hapticFeedback: Bool)
	{
		if hapticFeedback
		{
			HapticUtils.IMPACT.impactOccurred()
		}
		
		self.loadingIndicator.stopAnimating()
		self.tableController.refreshControl?.endRefreshing()
		
		self.updateHeader()
		self.tableController.reloadTable()
		
		self.tableController.view.isHidden = false
		
		if self.daySchedule == nil
		{
			self.errorLabel.text = "An Error Occured"
		} else if self.daySchedule!.isEmpty
		{
			self.errorLabel.text = "No Classes"
		} else
		{
			self.errorLabel.text = nil
		}
	}
	
	private func updateHeader()
	{
		self.headerTitle.text =
		{
			if TimeUtils.isToday(self.date) { return "Today" }
			if TimeUtils.isTomorrow(self.date) { return "Tomorrow" }
			if TimeUtils.wasYesterday(self.date) { return "Yesterday" }
			if TimeUtils.isThisWeek(self.date) { return self.date.dayOfWeek.displayName }
			return self.date.prettyString
		}()
		
		if self.daySchedule == nil
		{
			self.headerLunchWrapper.isHidden = true
			self.headerSubtitle.isHidden = true
			
			self.view.setNeedsLayout()
			self.view.layoutIfNeeded()
			
			self.headerHeightConstraint.constant = self.actualHeaderHeight
			return
		}
		
		if let subtitle = self.daySchedule?.subtitle
		{
			self.headerSubtitle.isHidden = false
			self.headerSubtitle.text = subtitle
		} else
		{
			self.headerSubtitle.isHidden = true
		}

		self.headerLunchWrapper.isHidden = self.lunchMenu == nil

		self.view.setNeedsLayout()
		self.view.layoutIfNeeded()

		UIView.animate(withDuration: 0.1, animations:
		{
			self.headerHeightConstraint.constant = self.actualHeaderHeight
			
			self.view.setNeedsLayout()
			self.view.layoutIfNeeded()
		})
	}
}
