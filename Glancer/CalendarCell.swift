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
        
        super.init("calendar", nib: "CalendarCell")
        
        self.setEstimatedHeight(50)
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
        let analyst = BlockAnalyst(schedule: self.composite.schedule, calendar: self.composite.calendar)
        let block = self.composite.calendar
        
        //        Setup
        cell.nameLabel.text = analyst.getDisplayName()
        
        cell.fromLabel.text = calendar.time.start.prettyTime

        //        Formatting
        var heavy = !analyst.getCourses().isEmpty
        if block.id == .lab, let before = self.composite.schedule.getBlockBefore(block) {
            if !BlockAnalyst(schedule: self.composite.schedule, block: before).getCourses().isEmpty {
                heavy = true
            }
        }
        
        cell.nameLabel.font = UIFont.systemFont(ofSize: 22, weight: heavy ? .bold : .semibold)
        cell.nameLabel.textColor = analyst.getColor()
        
        
        //        Attachments
        for arranged in cell.attachmentsStack.arrangedSubviews { cell.attachmentsStack.removeArrangedSubview(arranged) ; arranged.removeFromSuperview() }
        
        if block.id == .lunch {
            if let menu = self.composite.lunch {
                let lunchView = LunchAttachmentView(menuName: menu.title)
                lunchView.clickHandler = {
                    self.controller.openLunch(menu: menu)
                }
                cell.attachmentsStack.addArrangedSubview(lunchView)
            }
        }
        
        for event in composite.events {
            if !event.isRelevantToUser() {
                continue // Don't show if it's not relevant
            }
            
            let view = EventAttachmentView()
            view.text = event.completeDescription()
            cell.attachmentsStack.addArrangedSubview(view)
        }
        
        cell.attachmentStackBottomConstraint.constant = cell.attachmentsStack.arrangedSubviews.count > 0 ? 10.0 : 0.0
    }
    
}

class UICalendarCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    
}
