//
//  TeamDeclarations.swift
//  Glancer
//
//  Created by Dylan Hanson on 11/4/17.
//  Copyright © 2017 BB&N. All rights reserved.
//

import Foundation

class TeamDeclarations
{
	static let values =
	[
		HEALTH_FITNESS,
		INSTRUCTIONAL_TENNIS,
		STRENGTH_CONDITIONING,
		STRENGTH_CONDITIONING_YOGA,
		YOGA,
		
		CROSS_COUNTRY_B_V,
		CROSS_COUNTRY_B_JV,
		CROSS_COUNTRY_G_V,
		CROSS_COUNTRY_G_JV,
		FIELD_HOCKEY_G_V,
		FIELD_HOCKEY_G_JV,
		FOOTBALL_B_V,
		FOOTBALL_B_JV,
		SOCCER_B_V,
		SOCCER_B_JV,
		SOCCER_B_3,
		SOCCER_G_V,
		SOCCER_G_JV,
		SOCCER_G_3,
		VOLLEYBALL_G_V,
		VOLLEYBALL_G_JV,
		
		BASKETBALL_B_V,
		BASKETBALL_B_JV,
		BASKETBALL_B_3,
		BASKETBALL_G_V,
		BASKETBALL_G_JV,
		FENCING_V,
		HOCKEY_B_V,
		HOCKEY_B_JV,
		HOCKEY_G_V,
		HOCKEY_G_JV,
		SQUASH_B_V,
		SQUASH_B_JV,
		SQUASH_G_V,
		SQUASH_G_JV,
		WRESTLING,
		
		BASEBALL_B_V,
		BASEBALL_B_JV,
		CREW_B_V,
		CREW_B_JV,
		CREW_G_V,
		CREW_G_JV,
		GOLF_C_V,
		GOLF_C_JV,
		LACROSSE_B_V,
		LACROSSE_G_V,
		LACROSSE_G_JV,
		SAILING,
		SOFTBALL_G_V,
		SOFTBALL_G_JV,
		TENNIS_B_V,
		TENNIS_B_JV,
		TENNIS_G_V,
		TENNIS_G_JV,
		TRACK_FIELD
	]
	
	//	ALL YEAR
	
	static let HEALTH_FITNESS = SportTeam(id: 206, .health_fitness, .year, .coed, .none)
	static let INSTRUCTIONAL_TENNIS = SportTeam(id: 207, .instructional_tennis, .year, .coed, .none)
	static let STRENGTH_CONDITIONING = SportTeam(id: 208, .strength_conditioning, .year, .coed, .none)
	static let STRENGTH_CONDITIONING_YOGA = SportTeam(id: 209, .strength_conditioning_yoga, .year, .coed, .none)
	static let YOGA = SportTeam(id: 205, .yoga, .year, .coed, .none)
	
	//	FALL
	
	static let CROSS_COUNTRY_B_V = SportTeam(id: 154, .cross_country, .fall, .male, .first)
	static let CROSS_COUNTRY_B_JV = SportTeam(id: 156, .cross_country, .fall, .male, .second)
	static let CROSS_COUNTRY_G_V = SportTeam(id: 155, .cross_country, .fall, .female, .first)
	static let CROSS_COUNTRY_G_JV = SportTeam(id: 157, .cross_country, .fall, .female, .second)

	static let FIELD_HOCKEY_G_V = SportTeam(id: 149, .field_hockey, .fall, .female, .first)
	static let FIELD_HOCKEY_G_JV = SportTeam(id: 150, .field_hockey, .fall, .female, .second)

	static let FOOTBALL_B_V = SportTeam(id: 145, .football, .fall, .male, .first)
	static let FOOTBALL_B_JV = SportTeam(id: 146, .football, .fall, .male, .second)
	
	static let SOCCER_B_V = SportTeam(id: 135, .soccer, .fall, .male, .first)
	static let SOCCER_B_JV = SportTeam(id: 137, .soccer, .fall, .male, .second)
	static let SOCCER_B_3 = SportTeam(id: 139, .soccer, .fall, .male, .third)

	static let SOCCER_G_V = SportTeam(id: 136, .soccer, .fall, .female, .first)
	static let SOCCER_G_JV = SportTeam(id: 138, .soccer, .fall, .female, .second)
	static let SOCCER_G_3 = SportTeam(id: 212, .soccer, .fall, .female, .third)

	static let VOLLEYBALL_G_V = SportTeam(id: 159, .volleyball, .fall, .female, .first)
	static let VOLLEYBALL_G_JV = SportTeam(id: 160, .volleyball, .fall, .female, .second)
	
	//	WINTER
	
	static let BASKETBALL_B_V = SportTeam(id: 171, .basketball, .winter, .male, .first)
	static let BASKETBALL_B_JV = SportTeam(id: 173, .basketball, .winter, .male, .second)
	static let BASKETBALL_B_3 = SportTeam(id: 175, .basketball, .winter, .male, .third)

	static let BASKETBALL_G_V = SportTeam(id: 172, .basketball, .winter, .female, .first)
	static let BASKETBALL_G_JV = SportTeam(id: 174, .basketball, .winter, .female, .second)

	static let FENCING_V = SportTeam(id: 185, .fencing, .winter, .coed, .first)

	static let HOCKEY_B_V = SportTeam(id: 165, .hockey, .winter, .male, .first)
	static let HOCKEY_B_JV = SportTeam(id: 167, .hockey, .winter, .male, .second)
	
	static let HOCKEY_G_V = SportTeam(id: 166, .hockey, .winter, .female, .first)
	static let HOCKEY_G_JV = SportTeam(id: 168, .hockey, .winter, .female, .second)
	
	static let SQUASH_B_V = SportTeam(id: 190, .squash, .winter, .male, .first)
	static let SQUASH_B_JV = SportTeam(id: 193, .squash, .winter, .male, .second)
	
	static let SQUASH_G_V = SportTeam(id: 192, .hockey, .winter, .female, .first)
	static let SQUASH_G_JV = SportTeam(id: 194, .hockey, .winter, .female, .second)
	
	static let WRESTLING = SportTeam(id: 163, .wrestling, .winter, .male, .none)
	
	// SPRING
	
	static let BASEBALL_B_V = SportTeam(id: 112, .baseball, .spring, .male, .first)
	static let BASEBALL_B_JV = SportTeam(id: 113, .baseball, .spring, .male, .second)
	
	static let CREW_B_V = SportTeam(id: 115, .crew, .spring, .male, .first)
	static let CREW_B_JV = SportTeam(id: 196, .crew, .spring, .male, .second)
	
	static let CREW_G_V = SportTeam(id: 116, .crew, .spring, .female, .first)
	static let CREW_G_JV = SportTeam(id: 197, .crew, .spring, .female, .second)
	
	static let GOLF_C_V = SportTeam(id: 117, .golf, .spring, .coed, .first)
	static let GOLF_C_JV = SportTeam(id: 200, .golf, .spring, .coed, .second)
	
	static let LACROSSE_B_V = SportTeam(id: 118, .lacrosse, .spring, .male, .first)
	
	static let LACROSSE_G_V = SportTeam(id: 119, .lacrosse, .spring, .female, .first)
	static let LACROSSE_G_JV = SportTeam(id: 121, .lacrosse, .spring, .female, .second)
	
	static let SAILING = SportTeam(id: 128, .sailing, .spring, .coed, .first)

	static let SOFTBALL_G_V = SportTeam(id: 125, .softball, .spring, .female, .first)
	static let SOFTBALL_G_JV = SportTeam(id: 126, .softball, .spring, .female, .second)
	
	static let TENNIS_B_V = SportTeam(id: 129, .tennis, .spring, .male, .first)
	static let TENNIS_B_JV = SportTeam(id: 131, .tennis, .spring, .male, .second)
	
	static let TENNIS_G_V = SportTeam(id: 130, .tennis, .spring, .female, .first)
	static let TENNIS_G_JV = SportTeam(id: 132, .tennis, .spring, .female, .second)
	
	static let TRACK_FIELD = SportTeam(id: 214, .track_field, .spring, .coed, .none)
}
