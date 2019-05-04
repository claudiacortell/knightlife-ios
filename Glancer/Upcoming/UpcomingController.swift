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

class UpcomingController: UIViewController, TableHandlerDataSource, ErrorReloadable {
    
    @IBOutlet weak var tableView: UITableView!
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
    
    let cTabBar: CustomTabBar = {
        let tb = CustomTabBar()
        return tb
    }()
    
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
        
        self.date = Date.today
        
        self.tableHandler = TableHandler(table: self.tableView)
        self.tableHandler.dataSource = self
        
        //set default tab as SCHEDULE
        selectedTabTag = SCHEDULE
        self.cTabBar.setSelected(index: selectedTabTag)
        
        self.registerListeners()
        self.reloadData()
        
        tableView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        tableView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        
        self.setupCustomTabBar()
        self.setupTabBarObserver()
    }
    
    private func setupTabBarObserver() {
        NotificationCenter.default.addObserver(forName: Notification.Name("TabSelected"), object: nil, queue: nil) {
            (notification) in
            
            self.selectedTabTag = self.cTabBar.getSelected()
            self.reloadData()
        }
    }
    
    private func setupCustomTabBar() {
        view.addSubview(cTabBar)
        //view.addConstraintsWithFormat("H:|[v0]|", views: cTabBar)
        //view.addConstraintsWithFormat("V:|[v0(50)]", views: cTabBar)
        self.formatTabView(tView: cTabBar)
    }
    
    private func formatTabView(tView: UIView) {
        tView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            let guide = self.view.safeAreaLayoutGuide
            tView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            tView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            tView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
            tView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        } else {
            NSLayoutConstraint(item: tView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: view, attribute: .top,
                               multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: tView,
                               attribute: .leading,
                               relatedBy: .equal, toItem: view,
                               attribute: .leading,
                               multiplier: 1.0,
                               constant: 0).isActive = true
            NSLayoutConstraint(item: tView, attribute: .trailing,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .trailing,
                               multiplier: 1.0,
                               constant: 0).isActive = true
            
            tView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerListeners()
        
     
        self.navigationController?.navigationBar.tintColor = UIColor.init(displayP3Red: 0.266667
            , green: 0.505882
            , blue: 0.921569
            , alpha: 1)
        
        self.tableHandler.reload()
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

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
