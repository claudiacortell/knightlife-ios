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
	loaded,
	loading,
	failed,
	dead // No action is being taken right now
}

enum ResourceOrigin
{
	case
	remote,
	local
}

class RemoteResource<Data>
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
