//
//  TodayViewController.swift
//  Class Schedule
//
//  Created by Dylan Hanson on 1/3/18.
//  Copyright © 2018 BB&N. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding
{
	@IBOutlet weak var statusLabel: UILabel!
	
	@IBOutlet weak var containerNow: UIView!
	@IBOutlet weak var containerNext: UIView!
	
	@IBOutlet weak var blockBackground: UIView!
	@IBOutlet weak var blockLabel: UILabel!
	
	@IBOutlet weak var blockBackgroundWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var blockBackgroundHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var curClassLabel: UILabel!
	@IBOutlet weak var curTimeLabel: UILabel!
	
	@IBOutlet weak var nextBlockLabel: UILabel!
	@IBOutlet weak var nextLabel: UILabel!
	
	var timer: Timer?
	
	@IBAction func openContainingApp(_ sender: Any)
	{
		self.extensionContext?.open(URL(string: "MAD.BBN.KnightLife.URL.OpenApp://")!, completionHandler: nil)
	}
	
    override func viewDidLoad()
	{
        super.viewDidLoad()
		
		formatViews()
		
		ScheduleManager.instance.loadBlocks()
		updateView()
	}
	
	private func formatViews()
	{
		self.containerNext.layer.borderWidth = CGFloat(3)
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		
		if self.timer == nil
		{
			self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
		}
	}
	
	override func viewDidDisappear(_ animated: Bool)
	{
		super.viewDidDisappear(animated)
		
		if self.timer != nil
		{
			self.timer!.invalidate()
			self.timer = nil
		}
	}
	
	@objc func updateTime()
	{
		updateView()
	}
	
	func updateView()
	{
		let state = ScheduleManager.instance.getCurrentScheduleInfo()
				
		if state.scheduleState == .inClass
		{
			self.statusLabel.isHidden = true
			self.containerNow.isHidden = false
			
			self.blockBackgroundWidthConstraint.constant = self.blockBackgroundHeightConstraint.constant
			self.updateViewConstraints()
			
			self.blockBackground.backgroundColor = Utils.getUIColorFromHex(state.curBlock!.analyst.getColor())
			self.blockLabel.text = state.curBlock!.analyst.getDisplayLetter()
			
			self.curClassLabel.text = state.curBlock!.analyst.getDisplayName(true)
			self.curTimeLabel.text = "for \(TimeUtils.formatMinutesToString(state.minutesRemaining))"
			
			if let nextBlock = state.nextBlock
			{
				containerNext.isHidden = false
				containerNext.layer.borderColor = Utils.getUIColorFromHex(nextBlock.analyst.getColor()).cgColor
				
				nextBlockLabel.text = nextBlock.analyst.getDisplayName(true)
				nextLabel.text = "Next"
			} else
			{
				containerNext.isHidden = true
			}
		} else if state.scheduleState == .getToClass
		{
			self.statusLabel.isHidden = true
			self.containerNext.isHidden = true
			self.containerNow.isHidden = false
			
			self.blockBackgroundWidthConstraint.constant = self.blockBackgroundHeightConstraint.constant
			self.updateViewConstraints()
			
			self.blockBackground.backgroundColor = Utils.getUIColorFromHex(state.nextBlock!.analyst.getColor())
			self.blockLabel.text = String(state.minutesRemaining)
			
			self.curClassLabel.text = state.nextBlock!.analyst.getDisplayName(true)
			self.curTimeLabel.text = "Get to class"
		} else if state.scheduleState == .beforeSchool
		{
			self.statusLabel.isHidden = true
			self.containerNext.isHidden = false
			self.containerNow.isHidden = false
			
			self.blockBackgroundWidthConstraint.constant = CGFloat(0)
			self.updateViewConstraints()
			
			self.blockBackground.backgroundColor = Utils.getUIColorFromHex("000000")
			self.blockLabel.text = ""
			
			self.curClassLabel.text = "School Starts"
			self.curTimeLabel.text = "in \(TimeUtils.formatMinutesToString(state.minutesRemaining))"
			
			self.nextBlockLabel.text = state.nextBlock!.analyst.getDisplayName(true)
			containerNext.layer.borderColor = Utils.getUIColorFromHex(state.nextBlock!.analyst.getColor()).cgColor
			self.nextLabel.text = "First class"
		} else if state.scheduleState == .beforeSchoolGetToClass
		{
			self.statusLabel.isHidden = true
			self.containerNext.isHidden = true
			self.containerNow.isHidden = false
			
			self.blockBackgroundWidthConstraint.constant = self.blockBackgroundHeightConstraint.constant
			self.updateViewConstraints()
			
			self.blockBackground.backgroundColor = Utils.getUIColorFromHex(state.nextBlock!.analyst.getColor())
			self.blockLabel.text = String(state.minutesRemaining)
			
			self.curClassLabel.text = state.nextBlock!.analyst.getDisplayName(true)
			self.curTimeLabel.text = "Get to class"
		} else if state.scheduleState == .noClass
		{
			self.statusLabel.isHidden = false
			self.statusLabel.text = "No school! Enjoy"
			
			self.containerNow.isHidden = true
			self.containerNext.isHidden = true
		} else if state.scheduleState == .afterSchool
		{
			self.statusLabel.isHidden = false
			self.statusLabel.text = "School is over"
			
			self.containerNow.isHidden = true
			self.containerNext.isHidden = true
		} else
		{
			self.statusLabel.isHidden = false
			self.statusLabel.text = "An error occured"
			
			self.containerNow.isHidden = true
			self.containerNext.isHidden = true
		}
	}
	
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void))
	{
		ScheduleManager.instance.loadBlocks()
		UserPrefsManager.instance.loadPrefs()
		
		completionHandler(NCUpdateResult.newData)
    }
}
