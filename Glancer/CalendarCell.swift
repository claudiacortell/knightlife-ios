//
//  CalendarCell.swift
//  Glancer
//
//  Created by Joseph Zhou on 5/5/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//
import Foundation
import UIKit
import AddictiveLib

class CalendarCell: TableCell {
    
    private let controller: CalendarController
    private let composite: CompositeBlock
    
    init(controller: CalendarController, composite: CompositeBlock) {
        self.controller = controller
        self.composite = composite
        
        super.init("block", nib: "BlockCell")
        
        self.setEstimatedHeight(70)
        self.setSelectionStyle(.none)
        
        self.setCallback() {
            template, cell in
            
            if let calendarCell = cell as? UICalendarCell {
                self.layout(cell: calendarCell)
            }
        }
    }
    
    //    Set name label to bold if there's a class or not
    
    private func layout(cell: UICalendarCell) {
        let analyst = BlockAnalyst(schedule: self.composite.schedule, block: self.composite.block)
        let block = self.composite.block
        
        //        Setup
        cell.nameLabel.text = analyst.getDisplayName()
        cell.fromLabel.text = block.time.start.prettyTime
        
        //        Formatting
        var heavy = !analyst.getCourses().isEmpty
        if block.id == .lab, let before = self.composite.schedule.getBlockBefore(block) {
            if !BlockAnalyst(schedule: self.composite.schedule, block: before).getCourses().isEmpty {
                heavy = true
            }
        }
        
        cell.nameLabel.font = UIFont.systemFont(ofSize: 22, weight: heavy ? .bold : .semibold)
        cell.nameLabel.textColor = analyst.getColor()
        
    }
    

}
class UICalendarCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
}
