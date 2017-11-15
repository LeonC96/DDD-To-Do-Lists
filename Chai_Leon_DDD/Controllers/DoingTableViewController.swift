//
//  DoingTableViewController.swift
//  Chai_Leon_FinalProject
//
//  Created by Leon Chai on 2017-10-07.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class DoingTableViewController: UITableViewController {

	let tableName = "doingTasks"
	var doingTasks: [Task] = []
	
	var rootRef: DatabaseReference = Database.database().reference()
	let user = Auth.auth().currentUser!

    override func viewDidLoad() {
        super.viewDidLoad()

		getTasks()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
	
	override func viewWillAppear(_ animated: Bool) {

	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func getTasks(){
		
		SVProgressHUD.setDefaultMaskType(.black)
		SVProgressHUD.show(withStatus: "Loading...")
		rootRef.child(user.uid).child(tableName).observe(.value, with: { (snapshot) in
			if(snapshot.childrenCount == 0 ){
				print("no childern")
				return
			}
			if self.doingTasks.count != 0 {
				self.doingTasks = []
			}
			for child in snapshot.children {
				let snap = child as! DataSnapshot
				let task = Task(snapshot: snap)
				
				self.doingTasks.append(task)
				
				DispatchQueue.main.async() {
					self.tableView.reloadData()
				}
			}
			
		})
		SVProgressHUD.dismiss()
	}
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return doingTasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoingCell", for: indexPath) as! DoingTaskTableViewCell

        let task = doingTasks[indexPath.row]
        
        cell.task = task
		
		if(Utils.isOverDue(date: task.dueDate)){
			cell.backgroundColor = UIColor(red:0.99, green:0.28, blue:0.28, alpha:1.0)
		} else {
			cell.backgroundColor = UIColor.white
		}

        return cell
    }
	
	override func tableView(_ tableView: UITableView,
	               leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
	{
		let doneAction = UIContextualAction(style: .normal, title:  "Done", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
			print("OK, marked as Done")
			let task = self.doingTasks[indexPath.row]
			self.doingTasks.remove(at: indexPath.row)
			
			tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
			task.ref?.removeValue()
			FirebaseDB.addTask(name: "doneTasks", task: task)
			success(true)
		})
		
		doneAction.backgroundColor = UIColor(red:0.05, green:0.85, blue:0.08, alpha:1.0)
		
		return UISwipeActionsConfiguration(actions: [doneAction])
		
	}
	
	override func tableView(_ tableView: UITableView,
	               trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
	{
		let doAction = UIContextualAction(style: .normal, title:  "Do", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
			print("Moved back to Do")
			let task = self.doingTasks[indexPath.row]
			self.doingTasks.remove(at: indexPath.row)
			
			tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
			task.ref?.removeValue()
			FirebaseDB.addTask(name: "doTasks", task: task)
			success(true)
		})

		doAction.backgroundColor = .blue
		
		return UISwipeActionsConfiguration(actions: [doAction])
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
		

		guard let naviViewController = segue.destination as? UINavigationController else {
			fatalError("Unexpected destination: \(segue.destination)")
		}
		
		guard let taskDetailViewController = naviViewController.viewControllers.first as? DetailTaskViewController else {
			fatalError("Unexpected sender: \(sender)")
		}
		
		guard let selectedTaskCell = sender as? DoingTaskTableViewCell else {
			fatalError("Unexpected sender: \(sender)")
		}
			
		guard let indexPath = tableView.indexPath(for: selectedTaskCell) else {
			fatalError("The selected cell is not being displayed by the table")
		}
			
		let selectedTask = doingTasks[indexPath.row]
		taskDetailViewController.task = selectedTask

    }
	

}
