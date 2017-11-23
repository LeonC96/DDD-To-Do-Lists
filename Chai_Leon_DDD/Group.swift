//
//  Group.swift
//  Chai_Leon_DDD
//
//  Created by Leon Chai on 2017-11-23.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit
import Firebase

struct Group {
	
	let key: String
	var name: String
	var users: String
	var numberOfTasks: Int
	let ref: DatabaseReference?
	
	init(key: String = "", name: String, users: String, numberOfTasks: Int = 0){
		self.key = key
		self.name = name
		self.users = users
		self.numberOfTasks = numberOfTasks
		self.ref = nil
	}
	
	init(snapshot: DataSnapshot, numberOfTasks: Int = 0){
		self.key = snapshot.key
		
		let snapshotValue = snapshot.value as! [String: AnyObject]
		
		self.name = snapshotValue["name"] as! String
		self.users = snapshotValue["users"] as! String
		self.numberOfTasks = numberOfTasks
		
		self.ref = snapshot.ref
	}
}
