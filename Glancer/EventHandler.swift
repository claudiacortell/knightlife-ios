//
//  EventHandler.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

protocol EventHandler
{
    func eventHandlerName() -> String
    func eventHandlerTriggers() -> [String]
    func eventHandler(event: Event)
}
