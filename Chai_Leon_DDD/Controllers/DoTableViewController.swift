//
//  DoTableViewController.swift
//  Chai_Leon_FinalProject
//
//  Created by Leon Chai on 2017-10-07.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit

class DoTableViewController: UITableViewController {

	var doTasks: [Task] = Data.generateTaskData()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		//loadTasks()
		self.tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "cell")
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func unwindToDoTaskList(sender: UIStoryboardSegue){
		if let sourceViewController = sender.source as? NewTaskViewController, let task = sourceViewController.task {
			let newIndexPath = IndexPath(row: doTasks.count, section: 0)
			
			doTasks.append(task)
			tableView.insertRows(at: [newIndexPath], with: .automatic)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}