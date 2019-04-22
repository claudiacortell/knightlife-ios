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

class UpcomingController: UIViewController, TableHandlerDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableHandler: TableHandler!
    
    func buildCells(handler: TableHandler, layout: TableLayout) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableHandler = TableHandler(table: self.tableView)
        self.tableHandler.dataSource = self
    }
}
