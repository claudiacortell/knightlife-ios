//
//  EventManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

//class EventManager: Manager
//{
//    static let instance = EventManager()
//
//    var eventHandlers: [String: EventHandler]
//
//    required init()
//    {
//        self.eventHandlers = [:]
//        super.init(name: "Event Manager", registerEvents: false)
//    }
//
//    func registerHandler(handler: EventHandler)
//    {
//        if !self.handlerRegistered(handler: handler)
//        {
//            self.eventHandlers[handler.eventHandlerName()] = handler
//        }
//    }
//
//    func unregisterHandler(handler: EventHandler) -> Bool
//    {
//        return self.eventHandlers.removeValue(forKey: handler.eventHandlerName()) == nil ? false : true
//    }
//
//    func handlerRegistered(handler: EventHandler) -> Bool
//    {
//        for handlerName in self.eventHandlers.keys
//        {
//            if handlerName == handler.eventHandlerName()
//            {
//                return true
//            }
//        }
//        return false
//    }
//
//    func callEvent(event: Event)
//    {
//        for handler in self.eventHandlers.values
//        {
//            if handler.eventHandlerTriggers().contains(event.name)
//            {
//                handler.eventHandler(event: event)
//            }
//        }
//    }
//}

