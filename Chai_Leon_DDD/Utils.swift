//
//  Utils.swift
//  Chai_Leon_DDD
//
//  Created by Leon Chai on 2017-11-08.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import Foundation

class Utils {
	
	static func stringToDate(date: String) -> Date {
		let dateFormatter = DateFormatter()
		let dateFormat = "MM/dd/yyyy"
		dateFormatter.dateFormat = dateFormat
		
		return dateFormatter.date(from: date)!
	}
	
	static func dateToString(date: Date) -> String {
		let dateFormatter = DateFormatter()
		let dateFormat = "MM/dd/yyyy"
		dateFormatter.dateFormat = dateFormat
		
		return dateFormatter.string(from: date)
	}
	
	static func isOverDue(date: Date) -> Bool{
		let todayDate = Date()
		
		if(todayDate > date){
			return true
		} else {
			return false
		}
		
	}
	
}
