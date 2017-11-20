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
	
	static func getTasks(userID: String, tableName: String, completion: @escaping (_ result: [Task]) -> Void){
		var tasks: [Task] = []
		
		rootRef.child(userID).child(tableName).observe(.value, with: { (snapshot) in
			if(snapshot.childrenCount == 0 ){
				print("no childern")
				return
			}

			for child in snapshot.children {
				let snap = child as! DataSnapshot
				
				let task = Task(snapshot: snap)
				
				tasks.append(task)
				
				DispatchQueue.main.async() {
					completion(tasks)
				}
			}
			
		})
		
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
	
	static func addUser(username: String){
		let user = Auth.auth().currentUser!
		rootRef.observeSingleEvent(of: .value, with: { (snapshot) in
			
			rootRef.child("users").child(user.uid).setValue(["email" : user.email!, "name" : username, "projects" : [user.uid : ["name" : "personal"]]])
		})
	}
	
	//NOT TESTED YET
	static func addProject(name: String){
		let user = Auth.auth().currentUser!
		rootRef.observeSingleEvent(of: .value, with: { (snapshot) in
			
			let project = rootRef.childByAutoId()
			let projectID = project.key
			
			project.setValue(["doTasks" : "", "doingTasks" : "", "doneTasks" : ""])
			rootRef.child("users").child(user.uid).child("projects").child(projectID).setValue(["name" : name])
			
		})
	}
	
	//NOT TESTED YET
	static func addUserToProject(email: String){
		let user = Auth.auth().currentUser!
		let usersRef = rootRef.child("users")
		usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
			
			
			
		})
	}
	
	
}
