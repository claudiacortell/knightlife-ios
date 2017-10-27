//
//  Event.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class Event
{
    let name: String
    private(set) var meta: [String: Any] // Means of tagging the event should we ever need to transmit even more data through it.
    
    init(name: String, meta: [String: Any] = [:])
    {
        self.name = name
        self.meta = meta
    }
    
    func hasMeta(tag: String) -> Bool
    {
        return self.meta[tag] != nil
    }
    
    func getMeta(tag: String) -> Any?
    {
        return self.hasMeta(tag: tag) ? self.meta[tag] : nil
    }
    
    func setMeta(tag: String, val: Any)
    {
        self.meta[tag] = val
    }
}
