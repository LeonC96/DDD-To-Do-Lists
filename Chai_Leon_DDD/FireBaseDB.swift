//
//  FireBaseDB.swift
//  Chai_Leon_DDD
//
//  Created by Leon Chai on 2017-11-07.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import Foundation
import Firebase


class FirebaseDB{
	
	static let rootRef = Database.database().reference()
	
	static func getTasks(name: String) -> [Task]{
		
		var tasks: [Task] = []
		
		let tasksRef = rootRef.child(name)
		
		tasksRef.observe(.value, with: { (snapshot) in
			for child in snapshot.children {
				let snap = child as! DataSnapshot
				
				let task = Task(snapshot: snap)
				tasks.append(task)
			}
		})
		
		return tasks
	}
	
	static func addTask(name: String, task: Task){
		let tasksRef = rootRef.child(name)
		
		
		tasksRef.childByAutoId().setValue(["name" : task.name, "description" : task.description, "dueDate" : Utils.dateToString(date: task.dueDate)])
		
		
	}
	
	
}
