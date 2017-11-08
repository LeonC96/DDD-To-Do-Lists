//
//  Task.swift
//  Chai_Leon_FinalProject
//
//  Created by Leon Chai on 2017-10-07.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit
import Firebase

struct Task {
	
	let key: String
	var name: String
	var description: String?
	var dueDate: Date
	let ref: DatabaseReference?
	//var isOverDue: Bool
	
	init(name: String, description: String?, dueDate: Date = Date.init(), key: String = "") {
		
		self.key = key
		self.name = name
		self.description = description
		self.dueDate = dueDate
		
		self.ref = nil
		/*
		self.dueDate = dueDate
		if(dueDate <= Date()){
			self.isOverDue = true
		} else {
			self.isOverDue = false
		}
		*/
	}
	
	init(snapshot: DataSnapshot) {
		key = snapshot.key
		let snapshotValue = snapshot.value as! [String: AnyObject]
		name = snapshotValue["name"] as! String
		description = snapshotValue["description"] as? String
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/dd/yyyy"
		let dateString = snapshotValue["dueDate"] as! String
		dueDate = dateFormatter.date(from: dateString)!
		
		ref = snapshot.ref
	}
	
}

