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
	var user: String
	let ref: DatabaseReference?
	//var isOverDue: Bool
	
	init(name: String, description: String?, dueDate: Date = Date.init(), key: String = "", user: String = "") {
		
		self.key = key
		self.name = name
		self.description = description
		self.dueDate = dueDate
		self.user = user
		
		self.ref = nil
	}
	
	init(snapshot: DataSnapshot) {
		key = snapshot.key
		let snapshotValue = snapshot.value as! [String: AnyObject]
		name = snapshotValue["name"] as! String
		description = snapshotValue["description"] as? String

		let dateString = snapshotValue["dueDate"] as! String
		dueDate = Utils.stringToDate(date: dateString)
		
		if(snapshotValue["user"] != nil){
			user = snapshotValue["user"] as! String
		} else {
			user = ""
		}
		ref = snapshot.ref
	}
	
	public func toAnyObject() -> [AnyHashable : Any]{
		
		return ["name" : name,
		        "description" : description!,
		        "dueDate" : Utils.dateToString(date: dueDate),
				"user" : user]
	}
	
}

