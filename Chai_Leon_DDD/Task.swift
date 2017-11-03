//
//  Task.swift
//  Chai_Leon_FinalProject
//
//  Created by Leon Chai on 2017-10-07.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit

/*
struct Task {
	var name: String
	var description: String?
}
*/

class Task {
	
	var name: String
	var description: String?
	var dueDate: Date
	//var isOverDue: Bool
	
	init?(name: String, description: String?, dueDate: Date?) {
		
		if(name.isEmpty) {
			self.name = "NONE"
		}
		self.name = name
		self.description = description
		
		if(dueDate != nil){
			self.dueDate = dueDate!
		} else {
			self.dueDate = Date.init()
		}
		
		/*
		self.dueDate = dueDate
		if(dueDate <= Date()){
			self.isOverDue = true
		} else {
			self.isOverDue = false
		}
		*/
	}
	
}

