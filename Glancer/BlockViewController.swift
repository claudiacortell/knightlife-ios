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
import Charcore

class BlockViewController: TableHandler
{
	@IBOutlet weak var tableRep: UITableView!
	
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
	
	var todayView: Bool = false
	var date: EnscribedDate!
	
	var daySchedule: DateSchedule?
	var lunchMenu: LunchMenu?
	
	private var registeredScheduleHandler = false
	private var fetchName: String
	{
		return "block view: \(self.date.string)"
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		super.link(self.tableRep)
		
		self.buildRefreshControl()
		
		self.loadingIndicator.startAnimating()
		self.errorLabel.text = nil
		
		self.tableView.isHidden = true
		self.navigationItem.title = nil
		
		if !self.registeredScheduleHandler
		{
			self.registeredScheduleHandler = true
			ScheduleManager.instance.patchHandler.registerSuccessCallback(self.fetchName,
			{
				o in
				if let res = o
				{
					let date = res.0
					if let schedule = res.1
					{
						if date == self.date
						{
							self.daySchedule = schedule
							self.closeLoop(hapticFeedback: false)
						}
					}
				}
			})
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.updateHeader()
		self.reload(hard: false, delayResult: false, useRefreshControl: false, hapticFeedback: false)
	}
	
	deinit {
		if self.registeredScheduleHandler {
			ScheduleManager.instance.patchHandler.removeSuccessCallback(self.fetchName)
		}
	}
	
	private func buildRefreshControl() {
		self.tableView.refreshControl = UIRefreshControl()
		
		self.tableView.refreshControl?.layer.zPosition = -1
		self.tableView.refreshControl?.layer.backgroundColor = Scheme.ColorOrange.cgColor
		self.tableView.refreshControl?.tintColor = UIColor.white
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let scroll = scrollView.contentOffset.y
		
		if self.daySchedule == nil || self.daySchedule!.isEmpty {
			return
		}
		
		self.headerHeightConstraint.constant = -1 * scroll // -1 because the content insets mean that the content offset is (-1)*(header height)
		self.stackView.layer.opacity = (Float(min(1, max(0, self.headerHeightConstraint.constant / self.stackView.frame.height))))
		self.stackView.setNeedsDisplay()
		
		if self.visualHeaderHeight <= 0 {
			self.navigationItem.title = self.headerTitle.text
		} else {
			self.navigationItem.title = nil
		}
	}
	
	override func loadCells() {
		if self.daySchedule == nil {
			//
		} else if self.daySchedule!.isEmpty {
			//
		} else {
			if TimeUtils.isToday(self.date) {
				self.addModule(BlockTableModuleToday(controller: self))
			}
			self.addModule(BlockTableModuleBlocks(controller: self))
		}
		
		self.tableView.contentInset = UIEdgeInsets(top: self.actualHeaderHeight, left: 0, bottom: 0, right: 0)
		self.tableView.contentOffset = CGPoint(x: 0.0, y: -self.tableView.contentInset.top)
	}
	
	@IBAction func openLunchMenu(_ sender: Any) {
		if let controller = self.storyboard?.instantiateViewController(withIdentifier: "LunchViewController") as? LunchMenuViewController {
			controller.controller = self
			self.presentr.shouldIgnoreTapOutsideContext = true
			self.customPresentViewController(self.presentr, viewController: controller, animated: true, completion: nil)
		}
	}
	
	@objc private func forceReload() {
		self.reload(hard: true, delayResult: true, useRefreshControl: true, hapticFeedback: true)
	}
	
	private func reload(hard: Bool, delayResult: Bool, useRefreshControl: Bool, hapticFeedback: Bool) {
		if useRefreshControl {
			self.tableView.refreshControl!.beginRefreshing()
		}
		
		if hapticFeedback {
			HapticUtils.IMPACT.impactOccurred()
		}
		
		let chain = ProcessChain(success: {
			self.delayResult(delayResult, hapticFeedback: hapticFeedback)
		}, failure: {
			self.daySchedule = nil
			self.lunchMenu = nil
			
			self.delayResult(delayResult, hapticFeedback: hapticFeedback)
		})
		
		chain.addLink() {
			parent in
			if let schedule = ScheduleManager.instance.patchHandler.getSchedule(self.date, hard: hard, callback: {
				error, result in
				
				self.daySchedule = result
				parent.nextLink(result != nil)
			}) {
				self.daySchedule = schedule
				parent.nextLink(true)
			}
		}
		
		chain.addLink() {
			parent in
			if let lunch = LunchManager.instance.menuHandler.getMenu(self.date, hard: hard, callback: {
				error, result in
				
				self.lunchMenu = result
				parent.nextLink(true) // Ignore any errors and continue; it's just a lunch menu. Being null is fine.
			}) {
				self.lunchMenu = lunch
				parent.nextLink(true)
			}
		}
		
		chain.start()
	}
	
	private func delayResult(_ delay: Bool, hapticFeedback: Bool) {
		if delay {
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
				self.closeLoop(hapticFeedback: hapticFeedback)
			}
		} else {
			self.closeLoop(hapticFeedback: hapticFeedback)
		}
	}
	
	private func closeLoop(hapticFeedback: Bool) {
		if hapticFeedback {
			HapticUtils.IMPACT.impactOccurred()
		}
		
		self.loadingIndicator.stopAnimating()
		self.tableView.refreshControl?.endRefreshing()
		
		self.updateHeader()
		self.reloadTable()
		
		self.tableView.isHidden = false
		
		if self.daySchedule == nil {
			self.errorLabel.text = "An Error Occured"
		} else if self.daySchedule!.isEmpty {
			self.errorLabel.text = "No Classes"
		} else {
			self.errorLabel.text = nil
		}
	}
	
	private func updateHeader() {
		self.headerTitle.text = {
			if TimeUtils.isToday(self.date) { return "Today" }
			if TimeUtils.isTomorrow(self.date) { return "Tomorrow" }
			if TimeUtils.wasYesterday(self.date) { return "Yesterday" }
			if TimeUtils.isThisWeek(self.date) { return self.date.dayOfWeek.displayName }
			return self.date.prettyString
		}()
		
		if self.daySchedule == nil {
			self.headerLunchWrapper.isHidden = true
			self.headerSubtitle.isHidden = true
			
			self.view.setNeedsLayout()
			self.view.layoutIfNeeded()
			
			self.headerHeightConstraint.constant = self.actualHeaderHeight
			return
		}
		
		if let subtitle = self.daySchedule?.subtitle {
			self.headerSubtitle.isHidden = false
			self.headerSubtitle.text = subtitle
		} else {
			self.headerSubtitle.isHidden = true
		}

		self.headerLunchWrapper.isHidden = self.lunchMenu == nil

		self.view.setNeedsLayout()
		self.view.layoutIfNeeded()

		UIView.animate(withDuration: 0.1, animations: {
			self.headerHeightConstraint.constant = self.actualHeaderHeight
			
			self.view.setNeedsLayout()
			self.view.layoutIfNeeded()
		})
	}
}
