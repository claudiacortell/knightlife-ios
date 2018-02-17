//
//  FetchError
//  Glancer
//
//  Created by Dylan Hanson on 1/11/18.
//  Copyright © 2018 Dylan Hanson. All rights reserved.
//

import Foundation

struct FetchError
{
	let cause: FetchErrorCause
	let message: String?
	
	init(_ cause: FetchErrorCause, _ message: String?)
	{
		self.cause = cause
		self.message = message
	}
}

enum FetchErrorCause
{
	case
	call,
	remote,
	parse,
	unknown
}
