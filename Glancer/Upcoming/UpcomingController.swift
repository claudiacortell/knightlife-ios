//
//  UpcomingController.swift
//  Glancer
//
//  Created by Andy Xu on 4/21/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import UIKit
import AddictiveLib
import SnapKit

class UpcomingController: UIViewController, UITabBarDelegate, TableHandlerDataSource, ErrorReloadable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    
    var tableHandler: TableHandler!
    
    var date: Date!
    
    var bundle: DayBundle?
    var bundleError: Error?
    var bundleDownloaded: Bool { return bundle != nil || bundleError != nil }
    
    // schedule -> tag = 0
    // homework -> tag = 1
    var selectedTabTag: Int!
    let SCHEDULE: Int = 0
    let HOMEWORK: Int = 1
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //function (from UITabBarDelegate) is called whenever tab is clicked
        
        //simply sets the tag (see values in above comment) of the clicked tab
        selectedTabTag = item.tag
        self.reloadData()
    }
    
    func buildCells(handler: TableHandler, layout: TableLayout) {
        
        if selectedTabTag == SCHEDULE {
            if !self.bundleDownloaded {
                layout.addModule(LoadingModule(table: self.tableView))
                return
            }
            
            if let _ = self.bundleError {
                layout.addModule(ErrorModule(table: self.tableView, reloadable: self))
                return
            }
            
            if self.bundle!.schedule.getBlocks().isEmpty {
                layout.addModule(NoClassModule(table: self.tableView, fullHeight: !self.bundle!.events.hasOutOfSchoolEvents))
                layout.addModule(AfterSchoolEventsModule(bundle: self.bundle!, title: "Events", options: [.topBorder, .bottomBorder]))
                
                return
            }
            
            layout.addModule(UpcomingBlockListModule(controller: self, bundle: self.bundle!, title: nil, blocks: self.bundle!.schedule.getBlocks(), options: [.topBorder, .bottomBorder]))
            layout.addModule(AfterSchoolEventsModule(bundle: self.bundle!, title: "After School", options: [.bottomBorder]))
            
            layout.addSection().addSpacerCell().setBackgroundColor(.clear).setHeight(35)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.date = Date.tomorrow()
        
        self.tableHandler = TableHandler(table: self.tableView)
        self.tableHandler.dataSource = self
        
        self.tabBar.delegate = self
        
        //set default tab as SCHEDULE
        self.tabBar.selectedItem = tabBar.items![SCHEDULE] as UITabBarItem?
        selectedTabTag = SCHEDULE

        self.registerListeners()
        self.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerListeners()
        
        self.tableHandler.reload()
    }
    
    private func buildMailButtonItem(badge: Int) -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_mail")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = Scheme.blue.color
        
        let badgeWrapper = UIView()
        badgeWrapper.backgroundColor = UIColor.red
        badgeWrapper.cornerRadius = 7.0
        
        let badgeLabel = UILabel()
        badgeLabel.font = UIFont.systemFont(ofSize: 10.0, weight: .bold)
        badgeLabel.text = "\(badge)"
        badgeLabel.textColor = UIColor.white
        
        badgeWrapper.addSubview(badgeLabel)
        badgeLabel.snp.makeConstraints() { $0.center.equalToSuperview() }
        
        button.addSubview(badgeWrapper)
        badgeWrapper.snp.makeConstraints() {
            constrain in
            
            constrain.width.equalTo(14.0)
            constrain.height.equalTo(14.0)
            
            constrain.centerX.equalTo(button.snp.trailing).inset(1)
            constrain.centerY.equalTo(button.snp.top).inset(2)
        }
        
        return UIBarButtonItem(customView: button)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //        TODO: UNREGISTER ON UNWIND.
        self.unregisterListeners()
    }
    
    func unregisterListeners() {
        DayBundleManager.instance.getBundleWatcher(date: self.date).unregisterFailure(self)
        DayBundleManager.instance.getBundleWatcher(date: self.date).unregisterSuccess(self)
        
        ScheduleManager.instance.getVariationWatcher(day: self.date.weekday).unregisterSuccess(self)
    }
    
    func reloadData() {
        self.bundle = nil
        self.bundleError = nil
        
        self.tableHandler.reload()
        
        DayBundleManager.instance.getDayBundle(date: self.date)
    }
    
    func registerListeners() {
        DayBundleManager.instance.getBundleWatcher(date: self.date).onSuccess(self) {
            bundle in
            
            self.bundle = bundle
            self.bundleError = nil
            
            self.tableHandler.reload()
        }
        
        DayBundleManager.instance.getBundleWatcher(date: self.date).onFailure(self) {
            error in
            
            self.bundle = nil
            self.bundleError = error
            
            self.tableHandler.reload()
        }
        
        ScheduleManager.instance.getVariationWatcher(day: self.date.weekday).onSuccess(self) {
            variation in
            self.tableHandler.reload()
        }
    }
    
    func openLunch(menu: Lunch) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "Lunch") as? LunchController else {
            return
        }
        
        controller.menu = menu
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func hasDisplayedNoticeAlready(notice: DateNotice) -> Bool {
        guard let displayedNotices: [String: [String]] = Globals.getData("displayedNotices") else {
            let array: [String: [String]] = [:]
            Globals.setData("displayedNotices", data: array)
            return false
        }
        
        guard let todayNotices = displayedNotices[self.date.webSafeDate] else {
            return false
        }
        
        let noticeHash = "\(notice.priority.rawValue)\(notice.message)"
        return todayNotices.contains(noticeHash)
    }
    
    private func showNotice(notice: DateNotice) {
        var displayedNotices: [String: [String]] = Globals.getData("displayedNotices")!
        if displayedNotices[self.date.webSafeDate] == nil {
            displayedNotices[self.date.webSafeDate] = []
        }
        
        let noticeHash = "\(notice.priority.rawValue)\(notice.message)"
        displayedNotices[self.date.webSafeDate]!.append(noticeHash)
        
        Globals.setData("displayedNotices", data: displayedNotices) // Make sure it gets set properly again
        
        let alert = UIAlertController(title: "Alert", message: notice.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}
