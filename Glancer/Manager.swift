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
	static let defaults = UserDefaults.standard // File saving
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
	
	func saveData(key: String, data: Any)
	{
		Manager.defaults.set(data, forKey: "\(self.name).\(key)")
	}
	
	func loadData(key: String) -> Any?
	{
		return Manager.defaults.object(forKey: key)
	}
	
	func hasData(key: String) -> Bool
	{
		return loadData(key: key) != nil
	}
}
