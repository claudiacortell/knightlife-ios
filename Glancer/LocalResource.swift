//
//  LocalResource.swift
//  Glancer
//
//  Created by Dylan Hanson on 12/13/17.
//  Copyright © 2017 Dylan Hanson. All rights reserved.
//

import Foundation

enum ResourceStatus
{
	case
	success,
	loading,
	failure,
	dead // No action is being taken right now
}

class LocalResource<Data>
{
	let status: ResourceStatus
	let data: Data?
	
	var hasData: Bool
	{
		return self.data != nil
	}
	
	init(_ status: ResourceStatus, _ data: Data?)
	{
		self.status = status
		self.data = data
	}
}
