//
//  ScheduleManager.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/3/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class ScheduleManager: Manager
{	
	static let instance = ScheduleManager()
	
	private(set) var patchHandler: GetPatchResourceHandler!
	private(set) var templateHandler: GetTemplateResourceHandler!
	private(set) var variationModule: ScheduleVariationPrefsModule!
	
	init()
	{
		super.init(name: "Schedule Manager")

		self.patchHandler = GetPatchResourceHandler(self)
		self.templateHandler = GetTemplateResourceHandler(self)
		self.variationModule = ScheduleVariationPrefsModule(self, name: "variation")
		
		self.registerModule(self.variationModule)
	}
	
	func getVariation(_ day: DayID) -> Int
	{
		return self.variationModule.getItem(day) ?? 0
	}
	
	func getVariation(_ date: EnscribedDate) -> Int
	{
		return self.variationModule.getItem(date.dayOfWeek) ?? 0
	}
	
	func reloadAllSchedules()
	{
		self.templateHandler.reloadTemplate()
		self.patchHandler.reloadLocalPatches()
	}
}
