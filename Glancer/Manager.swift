//
//  Manager.swift
//  Glancer
//
//  Created by Dylan Hanson on 10/27/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class Manager: EventHandler
{
    let name: String
    
	init(name: String, registerEvents: Bool = true)
    {
        self.name = name
		
		if registerEvents { EventManager.instance.registerHandler(handler: self) }
        print("Loaded \(self.name) and registered as an EventHandler.")
    }
	
	func callEvent(_ event: Event)
	{
		EventManager.instance.callEvent(event: event)
	}
	
	func eventHandlerName() -> String
	{
		return self.name
	}
	
	func eventHandlerTriggers() -> [String]
	{
		return []
	}
	
	func eventHandler(event: Event)
	{
		
	}
}
