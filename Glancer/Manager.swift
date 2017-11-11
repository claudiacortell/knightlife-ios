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
	
	private(set) var modules: [String: IModule]
	
	init(name: String, registerEvents: Bool = true)
    {
        self.name = name
		self.modules = [:]
		
		if registerEvents { EventManager.instance.registerHandler(handler: self) }
        out("Loaded and registered as an EventHandler.")
    }
	
	func out(_ msg: String)
	{
		print("\(self.name): \(msg)")
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
	
    func registerModule(_ module: IModule)
	{
		self.modules[module.nameAbs] = module
	}
	
	func hasModule(_ name: String) -> Bool
	{
		return self.modules[name] != nil
	}
	
	func getModule(_ name: String) -> IModule?
	{
		return self.modules[name]
	}
    
    func hasPrefsModule() -> Bool
    {
        return self.getPrefsModule() != nil
    }
	
	func getPrefsModule() -> IModule?
	{
		for module in self.modules.values
        {
            if module is PreferenceHandler
            {
                return module
            }
        }
        return nil
	}
    
    func loadAllPrefHandlers()
    {
        for module in self.modules.values
        {
            if module is PreferenceHandler
            {
                self.loadPrefsHandler(handler: module as! PreferenceHandler)
            }
        }
    }
    
    func saveAllPrefHandlers()
    {
        for module in self.modules.values
        {
            if module is PreferenceHandler
            {
                savePrefsHandler(handler: module as! PreferenceHandler)
            }
        }
    }
    
    func loadPrefsHandler(handler: PreferenceHandler)
    {
        PrefsOverlord.instance.loadMod(handler)
    }
    
    func savePrefsHandler(handler: PreferenceHandler)
    {
        PrefsOverlord.instance.saveMod(handler)
    }
}
