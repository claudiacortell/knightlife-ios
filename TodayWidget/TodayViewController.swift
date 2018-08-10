//
//  TodayViewController.swift
//  TodayWidget
//
//  Created by Dylan Hanson on 8/6/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import UIKit
import NotificationCenter
import AddictiveLib

class TodayViewController: UIViewController, NCWidgetProviding {
	
	private var state: TodayManager.TodayScheduleState? // Null if error
	
	@IBOutlet weak var activeStack: UIStackView!
	var activeView: UIView?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.registerListener()
		
		Globals.BundleID = "MAD.BBN.KnightLife.TodayWidget"
		Globals.StorageID = "MAD.BBN.KnightLife.Storage"
		Globals.storeUrlBase(url: "https://knightlife-server.herokuapp.com/api/")
		
		_ = TodayManager.instance
		self.handleStateChange(state: TodayManager.instance.currentState)
	}
	
	private func registerListener() {
		TodayManager.instance.statusWatcher.onSuccess(self) {
			state in
			
			self.handleStateChange(state: state)
		}
		
		TodayManager.instance.statusWatcher.onFailure(self) {
			error in
			
			self.handleStateChange(state: nil)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		TodayManager.instance.startTimer()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		TodayManager.instance.stopTimer()
	}
	
	func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
		TodayManager.instance.reloadTodayBundle()
		completionHandler(NCUpdateResult.newData)
	}
	
	private func handleStateChange(state: TodayManager.TodayScheduleState?) {
		self.state = state
		self.updateViews()
	}
	
	@IBAction func openContainingApp(_ sender: Any) {
		self.extensionContext?.open(URL(string: "MAD.BBN.KnightLife.URL.OpenApp://")!, completionHandler: nil)
	}
	
	private func updateViews() {
		guard let state = self.state else {
			self.setView(view: NoConnectionView())
			return
		}
		
		switch state {
		case .ERROR:
			self.setView(view: NoConnectionView())
		case .LOADING:
			self.setView(view: LoadingView())
		case .NO_CLASS(_, _):
			self.setView(view: NoClassView())
		case .AFTER_SCHOOL(_, _):
			self.setView(view: AfterSchoolView())
		case let .IN_CLASS(bundle, block, _, minutes):
			self.setView(view: InClassView(schedule: bundle.schedule, block: block, minutes: minutes))
		case let .BETWEEN_CLASS(bundle, block, minutes):
			self.setView(view: BetweenClassView(schedule: bundle.schedule, block: block, minutes: minutes))
		case let .BEFORE_SCHOOL(bundle, block, minutes):
			self.setView(view: BeforeSchoolView(schedule: bundle.schedule, block: block, minutes: minutes))
		}
	}
	
	func setView(view: UIView) {
		if let activeView = self.activeView {
			activeView.removeFromSuperview()
			self.activeView = nil
		}
		
		self.activeStack.addArrangedSubview(view)
		self.activeView = view
	}
	
}
