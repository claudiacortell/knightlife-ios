//
//  DayViewController.swift
//  Glancer
//
//  Created by Dylan Hanson on 5/20/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class DayViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	
	@IBOutlet weak var toolbarView: ToolbarView!
	
	private var pageController: UIPageViewController!
	private var pageControllerPages: [UIViewController] = []
	
	var date: EnscribedDate! = TimeUtils.todayEnscribed
	var isTodayView: Bool = true
	
	private var schedule: DateSchedule? { // Soft reference that's automatically updated
		didSet {
			self.updateHeader()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupPages()
		self.setupSchedule()

		self.toolbarView.viewDidLoad()
		self.updateHeader()
	}
	
	deinit {
		ScheduleManager.instance.patchHandler.unregisterSuccess(self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let _ = segue.identifier, segue.identifier == "embed" {
			self.pageController = segue.destination as! UIPageViewController
			
			self.pageController.delegate = self
			self.pageController.dataSource = self
		}
	}

	private func setupPages() {
		self.pageControllerPages = [
			{
				let scheduleController = self.storyboard!.instantiateViewController(withIdentifier: "DayScheduleController") as! DayScheduleViewController
				scheduleController.parentController = self
				return scheduleController
			}(),
			{
				return self.storyboard!.instantiateViewController(withIdentifier: "DaySportsController")
			}()
		]
		
		self.pageController.isDoubleSided = false
		self.pageController.setViewControllers([self.pageControllerPages.first!], direction: .forward, animated: true, completion: nil)
	}
	
	private func setupSchedule() { // Used to get day subtitles and information
		ScheduleManager.instance.patchHandler.onSuccess(self) {
			package in
			
			if package != nil {
				let date = package!.0
				let schedule = package!.1
				
				if date == self.date {
					self.schedule = schedule
				}
			}
		}

		ScheduleManager.instance.patchHandler.getSchedule(self.date) // Result is picked up by the handler registered above
	}
	
	private func updateHeader() {
		self.toolbarView.resetValues()
		
		if TimeUtils.isToday(self.date) {
			self.toolbarView.title = "Today"
		} else if TimeUtils.wasYesterday(self.date) {
			self.toolbarView.title = "Yesterday"
		} else if TimeUtils.isTomorrow(self.date) {
			self.toolbarView.title = "Tomorrow"
		} else {
			self.toolbarView.title = self.date.prettyString
			
			// X days away
			let daysUntil = TimeUtils.daysUntil(self.date)
			if daysUntil < 0 {
				self.toolbarView.subtitle = "\(abs(daysUntil)) days ago"
			} else {
				self.toolbarView.subtitle = "\(daysUntil) days away"
			}
		}
		
		// Get subtitle from date
		if let schedule = self.schedule, let subtitle = schedule.subtitle {
			self.toolbarView.subtitle = subtitle
		}
		
//		Pagination
		var titles: [String] = []
		for controller in self.pageControllerPages {
			titles.append(controller.title!)
		}
		
		self.toolbarView.pagination = titles
	}

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let curIndex = self.pageControllerPages.index(of: viewController) else { return nil }
		
		let previousIndex = curIndex - 1
		guard previousIndex >= 0 && previousIndex < self.pageControllerPages.count else { return nil }
		
		return self.pageControllerPages[previousIndex]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let curIndex = self.pageControllerPages.index(of: viewController) else { return nil }
		
		let nextIndex = curIndex + 1
		guard nextIndex >= 0 && nextIndex < self.pageControllerPages.count else { return nil }
		
		return self.pageControllerPages[nextIndex]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		if let viewControllers = self.pageController.viewControllers {
			if let first = viewControllers.first {
				self.toolbarView.paginationSelected = self.pageControllerPages.index(of: first)!
			}
		}
	}
	
}
