//
//  UpcomingBlockListModule.swift
//  Glancer
//
//  Created by Andy Xu on 4/28/19.
//  Copyright © 2019 Dylan Hanson. All rights reserved.
//

import Foundation
import AddictiveLib

class UpcomingBlockListModule: TableModule {
    
    let controller: UpcomingController
    
    let title: String?
    
    let bundle: DayBundle
    let blocks: [Block]
    
    let options: [DayModuleOptions]
    
    init(controller: UpcomingController, bundle: DayBundle, title: String?, blocks: [Block], options: [DayModuleOptions] = []) {
        self.controller = controller
        
        self.title = title
        
        self.bundle = bundle
        self.blocks = blocks
        
        self.options = options
        
        super.init()
    }
    
    override func build() {
        if self.blocks.isEmpty {
            return
        }
        
        let section = self.addSection()
        
        if self.options.contains(.topBorder) { section.addDivider() }
        
        if let title = self.title {
            section.addCell(TitleCell(title: title))
            section.addDivider()
        }
        
        for block in self.blocks {
            let composite = CompositeBlock(schedule: self.bundle.schedule, block: block, lunch: (block.id == .lunch && !self.bundle.menu.items.isEmpty ? bundle.menu : nil), events: self.bundle.events.getEventsByBlock(block: block.id))
            
            section.addCell(UpcomingBlockCell(controller: self.controller, composite: composite))
            
            if self.blocks.last == block {
                if self.options.contains(.bottomBorder) { section.addDivider() }
            } else {
                section.addDivider()
            }
        }
    }
    
}
