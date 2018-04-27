//
//  FireBaseDB.swift
//  Chai_Leon_DDD
//
//  Created by Leon Chai on 2017-11-07.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import Foundation
import Firebase
import SVProgressHUD

class FirebaseDB{
	
	static let rootRef = Database.database().reference()
	
	// Add task to a given table to current user
	static func addTask(name: String, task: Task, groupID: String){
		let tasksRef = rootRef.child(groupID).child(name)
		
		if(task.key == ""){
			tasksRef.childByAutoId().setValue(task.toAnyObject())
		} else {
			tasksRef.child(task.key).setValue(task.toAnyObject())
		}
		
	}
	
	// Update an existing task in any table
	static func updateTask(name: String, task: Task){
		let taskRef = rootRef.child(name)
		
		let taskChild = taskRef.child(task.key)
		taskChild.updateChildValues(task.toAnyObject())
		
	}
	
	// Not really needed
	// Creates new user personal todo list tables
	static func createNewUserTable(){
		let user = Auth.auth().currentUser!

		rootRef.observeSingleEvent(of: .value, with: { (snapshot) in
			
			rootRef.child(user.uid).setValue(["doTasks" : "", "doingTasks" : "", "doneTasks" : ""])
		})
	}
	
	// Add new user to Firebase Database
	static func addUser(username: String){
		let user = Auth.auth().currentUser!
		rootRef.observeSingleEvent(of: .value, with: { (snapshot) in
			
			rootRef.child("users").child(user.uid).setValue(["email" : user.email!, "name" : username, "projects" : [user.uid : ["name" : "Personal", "users" : username]]])
		})
	}
	
	
	//creates a new todo list project
	static func createProject(name: String){
		let user = Auth.auth().currentUser!
		rootRef.observeSingleEvent(of: .value, with: { (snapshot) in
			
			let project = rootRef.childByAutoId()
			let projectID = project.key
			
			//project.setValue(["doTasks" : "", "doingTasks" : "", "doneTasks" : ""])
			rootRef.child("users").child(user.uid).child("projects").child(projectID).setValue(["name" : name, "users" : user.displayName!])
			
		})
	}
	
	//NOT TESTED YET
	static func addUserToProject(email: String){
		//let user = Auth.auth().currentUser!
		let usersRef = rootRef.child("users")
		usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
			
			if snapshot.hasChildren() {
				for child in snapshot.children {
					let snap = child as! DataSnapshot
					
 				}
			}
			
		})
	}
	
	
	
}
