//
//  DoTableViewController.swift
//  Chai_Leon_FinalProject
//
//  Created by Leon Chai on 2017-10-07.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class DoTableViewController: UITableViewController {

	let tableName = "doTasks"
	
	var group: Group = Group()
	
	var doTasks: [Task] = []
	var handle: AuthStateDidChangeListenerHandle?
	var rootRef: DatabaseReference = Database.database().reference()
	let user: User = Auth.auth().currentUser!
	
    override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let tabBar = self.tabBarController as! TabBarContoller
		if tabBar.group == nil{
			self.group = Group(key: user.uid, users: user.displayName!)
			tabBar.group = self.group
		} else {
			self.group = tabBar.group!
		}
		getTasks()
		handle = Auth.auth().addStateDidChangeListener{ (auth, user) in
			
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		Auth.auth().removeStateDidChangeListener(handle!)
	}
	
	func getTasks(){
		
		SVProgressHUD.setDefaultMaskType(.black)
		SVProgressHUD.show(withStatus: "Loading...")
		rootRef.child(group.key).child(tableName).observe(.value, with: { (snapshot) in
			self.doTasks = []
			if(snapshot.childrenCount == 0 ){
				print("no childern")
				DispatchQueue.main.async() {
					self.tableView.reloadData()
				}
				return
			}
			for child in snapshot.children {
				let snap = child as! DataSnapshot
				let task = Task(snapshot: snap)
					
				self.doTasks.append(task)

				DispatchQueue.main.async() {
					self.tableView.reloadData()
				}
			}

		})
		SVProgressHUD.dismiss()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func addUser(_ sender: UIBarButtonItem) {
		let addUserAlert = UIAlertController(title: "Add User", message: "Enter User's Email:", preferredStyle: .alert)
		
		addUserAlert.addTextField(configurationHandler: { (textField: UITextField) -> Void in
			textField.placeholder = "Name"
		})
		
		let add = UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
			self.rootRef.child("users").observeSingleEvent(of: .value, with: { (snapshot) in				
				var found = false
				for child in snapshot.children {
					let snap = child as! DataSnapshot
					let snapshotValue = snap.value as! [String: AnyObject]
					let snapshotEmail = snapshotValue["email"] as! String
					
					if(snapshotEmail == addUserAlert.textFields![0].text!){
						let userName = snapshotValue["name"] as! String
						self.group.users += ", \(userName)"
						self.rootRef.child("users").child(snap.key).child("projects").child(self.group.key).child("name")
							.setValue(self.group.name)
						self.rootRef.child("users").child(snap.key).child("projects").child(self.group.key).child("users")
							.setValue(self.group.users)
						self.rootRef.child("users").child(self.user.uid).child("projects").child(self.group.key).child("users")
							.setValue(self.group.users)
						found = true
						break
					}
					
				}
				
				if(!found){
					let errorAlert = UIAlertController(title: "ERROR", message: "User Does Not Exist", preferredStyle: .alert)
					let ok = UIAlertAction(title: "OK", style: .cancel) { (action) -> Void in
						print("Cancel button tapped")
					}
					
					errorAlert.addAction(ok)
					self.present(errorAlert, animated: true, completion: nil)
				}
				
			})
			
			print("Ok, Adding User")
		})
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
			print("Cancel button tapped")
		}
		
		addUserAlert.addAction(add)
		addUserAlert.addAction(cancel)
		self.present(addUserAlert, animated: true, completion: nil)
	}
	
	
	@IBAction func unwindToDoTaskList(sender: UIStoryboardSegue){
		if let sourceViewController = sender.source as? NewTaskViewController, let updatedTask = sourceViewController.task {
			
			if let selectedIndexPath = tableView.indexPathForSelectedRow {
				// Update an existing task.
				let dotaskChild = rootRef.child(group.key).child(tableName).child(updatedTask.key)
				
				dotaskChild.updateChildValues(updatedTask.toAnyObject())
				
				tableView.reloadRows(at: [selectedIndexPath], with: .none)
			} else {
				FirebaseDB.addTask(name: tableName, task: updatedTask, groupID: group.key)
				getTasks()
			}
		}
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doTasks.count
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// Table view cells are reused and should be dequeued using a cell identifier.
		let cellIdentifier = "DoCell"
		
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TaskTableViewCell

		// Fetches the appropriate task for the data source layout.
		let doTask = doTasks[indexPath.row]
		cell.task = doTask
		
		if(Utils.isOverDue(date: doTask.dueDate)){
			cell.backgroundColor = UIColor(red:0.99, green:0.28, blue:0.28, alpha:1.0)
		} else {
			cell.backgroundColor = UIColor.white
		}
		
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

	
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			
            // Delete the row from the data source
			let task = doTasks[indexPath.row]
			doTasks.remove(at: indexPath.row)
			
            tableView.deleteRows(at: [indexPath], with: .fade)
			task.ref?.removeValue()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
	
	override func tableView(_ tableView: UITableView,
	               leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
	{
		let closeAction = UIContextualAction(style: .normal, title:  "Doing",
							 handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
			print("OK, marked as Doing")
			var task = self.doTasks[indexPath.row]
			task.user = self.user.displayName!
			task.userId = self.user.uid
			self.doTasks.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
			task.ref?.removeValue()
			FirebaseDB.addTask(name: "doingTasks", task: task, groupID: self.group.key)
			success(true)
		})
		closeAction.backgroundColor = UIColor(red: 1, green: 0.79, blue: 0.06, alpha: 1)
		
		return UISwipeActionsConfiguration(actions: [closeAction])
		
	}

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
		
		switch(segue.identifier ?? ""){
			case "AddTask":
				print("Adding new task")
			
			case "ShowDetail":
				guard let taskDetailViewController = segue.destination as? NewTaskViewController else {
					fatalError("Unexpected destination: \(segue.destination)")
				}
				
				guard let selectedTaskCell = sender as? TaskTableViewCell else {
					fatalError("Unexpected sender: \(String(describing: sender))")
				}
				
				guard let indexPath = tableView.indexPath(for: selectedTaskCell) else {
					fatalError("The selected cell is not being displayed by the table")
				}
				
				let selectedTask = doTasks[indexPath.row]
				taskDetailViewController.task = selectedTask
			
			default:
				fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
		}
    }
	
}
