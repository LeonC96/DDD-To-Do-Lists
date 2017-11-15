//
//  DoneTableViewController.swift
//  Chai_Leon_FinalProject
//
//  Created by Leon Chai on 2017-10-23.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class DoneTableViewController: UITableViewController {

	let tableName = "doneTasks"
	var doneTasks: [Task] = []
	
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func getTasks(){
		
		SVProgressHUD.setDefaultMaskType(.black)
		SVProgressHUD.show(withStatus: "Loading...")
		rootRef.child(user.uid).child(tableName).observe(.value, with: { (snapshot) in
			if(snapshot.childrenCount == 0 ){
				print("no children")
				return
			}
			if self.doneTasks.count != 0 {
				self.doneTasks = []
			}
			for child in snapshot.children {
				let snap = child as! DataSnapshot
				let task = Task(snapshot: snap)
				
				self.doneTasks.append(task)
				
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
        return doneTasks.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoneCell", for: indexPath) as! DoneTableViewCell

        // Configure the cell...
		let task = doneTasks[indexPath.row]
		
		cell.task = task


        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

	override func tableView(_ tableView: UITableView,
	               trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
	{
		let doingAction = UIContextualAction(style: .normal, title:  "Doing", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
			print("Moved back to Doing")
			
			let task = self.doneTasks[indexPath.row]
			self.doneTasks.remove(at: indexPath.row)
			
			tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
			task.ref?.removeValue()
			FirebaseDB.addTask(name: "doingTasks", task: task)
			
			success(true)
		})

		doingAction.backgroundColor = UIColor(red: 1, green: 0.79, blue: 0.06, alpha: 1)
		
		return UISwipeActionsConfiguration(actions: [doingAction])
	}
	
	override func tableView(_ tableView: UITableView,
	               leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
	{
		let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
			print("OK, marked as Delete")
			
			let task = self.doneTasks[indexPath.row]
			self.doneTasks.remove(at: indexPath.row)
			
			tableView.deleteRows(at: [indexPath], with: .fade)
			task.ref?.removeValue()
			
			success(true)
		})
		deleteAction.backgroundColor = .red
		
		return UISwipeActionsConfiguration(actions: [deleteAction])
		
	}
	
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
		
		guard let selectedTaskCell = sender as? DoneTableViewCell else {
			fatalError("Unexpected sender: \(sender)")
		}
		
		guard let indexPath = tableView.indexPath(for: selectedTaskCell) else {
			fatalError("The selected cell is not being displayed by the table")
		}
		
		let selectedTask = doneTasks[indexPath.row]
		taskDetailViewController.task = selectedTask

    }
	

}
