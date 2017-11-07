//
//  DoTableViewController.swift
//  Chai_Leon_FinalProject
//
//  Created by Leon Chai on 2017-10-07.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit
import Firebase

class DoTableViewController: UITableViewController {

	var doTasks: [Task] = Data.generateTaskData()
	var handle: AuthStateDidChangeListenerHandle?
	var rootRef: DatabaseReference = Database.database().reference()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		addTask()
		getTasks()
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		handle = Auth.auth().addStateDidChangeListener{ (auth, user) in
			
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		Auth.auth().removeStateDidChangeListener(handle!)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func unwindToDoTaskList(sender: UIStoryboardSegue){
		if let sourceViewController = sender.source as? NewTaskViewController, let task = sourceViewController.task {
			
			if let selectedIndexPath = tableView.indexPathForSelectedRow {
				// Update an existing meal.
				doTasks[selectedIndexPath.row] = task
				tableView.reloadRows(at: [selectedIndexPath], with: .none)
			} else {
			
				let newIndexPath = IndexPath(row: doTasks.count, section: 0)
			
				doTasks.append(task)
				tableView.insertRows(at: [newIndexPath], with: .automatic)
			}
		}
	}
	
	func addTask(){
		let tasksRef = rootRef.child("doTasks")
		
		tasksRef.childByAutoId().setValue(["name" : "test1", "description" : "TESTING"])
	}
	
	func getTasks(){
		let tasksRef = rootRef.child("doTasks")
		//let userId = Auth.auth().currentUser?.uid
		
		//tasksRef.childByAutoId().setValue(["name" : "HELLO"])
		
		tasksRef.observeSingleEvent(of: .value, with: { (snapshot) in
			for child in snapshot.children {
				let snap = child as! DataSnapshot
				let key = snap.key
				let value = snap.value
				
				for v in snap.children{
					let test = v as! DataSnapshot
					
					print("\(test.key) = \(test.value!) ")
					
				}
				print("nxt child")
				//print("key = \(key)  value = \(value!)")
			}
		})
		
	
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

		// Fetches the appropriate meal for the data source layout.
		let doTask = doTasks[indexPath.row]
		
		cell.task = doTask
		
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
			//let task = doTasks[indexPath.row]
			doTasks.remove(at: indexPath.row)
			
			
            tableView.deleteRows(at: [indexPath], with: .fade)
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
			self.doTasks.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
			//DoingTableViewController.doingTask
												
			success(true)
		})
		//closeAction.image = UIImage(named: "tick")
		closeAction.backgroundColor = UIColor(red: 1, green: 0.79, blue: 0.06, alpha: 1)
		
		return UISwipeActionsConfiguration(actions: [closeAction])
		
	}

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

	
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
					fatalError("Unexpected sender: \(sender)")
				}
				
				guard let indexPath = tableView.indexPath(for: selectedTaskCell) else {
					fatalError("The selected cell is not being displayed by the table")
				}
				
				let selectedTask = doTasks[indexPath.row]
				taskDetailViewController.task = selectedTask
			
			default:
			fatalError("Unexpected Segue Identifier; \(segue.identifier)")
		}
    }
	

}
