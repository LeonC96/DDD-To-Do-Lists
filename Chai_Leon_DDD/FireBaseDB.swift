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
	
	static func addTask(name: String, task: Task){
		let user = Auth.auth().currentUser!
		let tasksRef = rootRef.child(user.uid).child(name)
			
		tasksRef.childByAutoId().setValue(["name" : task.name, "description" : task.description, "dueDate" : Utils.dateToString(date: task.dueDate)])
		
	}
	
	static func updateTask(task: Task){
		let taskRef = rootRef.child("doTasks")
		
		let taskChild = taskRef.child(task.key)
		taskChild.updateChildValues(["name" : task.name, "description" : task.description!, "dueDate" : task.dueDate])
		
	}
	
	static func createNewUserTable(){
		//rootRef.child(user.uid)
		let user = Auth.auth().currentUser!
		
		rootRef.observeSingleEvent(of: .value, with: { (snapshot) in
			
			rootRef.child(user.uid).setValue(["doTasks" : "", "doingTasks" : "", "doneTasks" : ""])
			//rootRef.child(user.uid).child("doTasks").childByAutoId().setValue(["name" : "test"])
		})
	}
	
}
