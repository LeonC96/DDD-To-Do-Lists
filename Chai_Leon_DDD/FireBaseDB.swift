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
		
		if(task.key == ""){
			tasksRef.childByAutoId().setValue(task.toAnyObject())
		} else {
			tasksRef.child(task.key).setValue(task.toAnyObject())
		}
		
	}
	
	static func updateTask(name: String, task: Task){
		let taskRef = rootRef.child(name)
		
		let taskChild = taskRef.child(task.key)
		taskChild.updateChildValues(task.toAnyObject())
		
	}
	
	static func createNewUserTable(){
		let user = Auth.auth().currentUser!

		rootRef.observeSingleEvent(of: .value, with: { (snapshot) in
			
			rootRef.child(user.uid).setValue(["doTasks" : "", "doingTasks" : "", "doneTasks" : ""])
		})
	}
	
	
}
