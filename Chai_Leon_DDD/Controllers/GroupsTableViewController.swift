//
//  GroupsTableViewController.swift
//  Chai_Leon_DDD
//
//  Created by Leon Chai on 2017-11-21.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class GroupsTableViewController: UITableViewController {
	
	let tableName = "projects"
	
	var groups: [Group] = []
	let user: User = Auth.auth().currentUser!
	var rootRef: DatabaseReference = Database.database().reference()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		getGroups()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func getGroups(){
		SVProgressHUD.setDefaultMaskType(.black)
		SVProgressHUD.show(withStatus: "Loading...")
		
		rootRef.child("users").child(user.uid).child(tableName).observe(.value, with: { (snapshot) in
			self.groups = []
			for child in snapshot.children {
				let snap = child as! DataSnapshot
				
				let group = Group(snapshot: snap)
				
				self.groups.append(group)
				
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
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let tabBar = self.tabBarController as! TabBarContoller
		tabBar.group = nil
		let group = groups[indexPath.row]
		tabBar.group = group
		
		tabBar.selectedIndex = 1
		
		
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups.count
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupTableViewCell
		
		// Configure the cell...
		let group = groups[indexPath.row]
		cell.group = group
		
		return cell
	}
	
	@IBAction func addNewGroup(_ sender: UIBarButtonItem) {
		let createGroup = UIAlertController(title: "Create Group", message: "Please Name Group:", preferredStyle: .alert)
		
		createGroup.addTextField(configurationHandler: { (textField: UITextField) -> Void in
			textField.placeholder = "Name"
		})
		
		let create = UIAlertAction(title: "Create", style: .default, handler: { (action) -> Void in
			print("Ok, Creating group")
			FirebaseDB.createProject(name: createGroup.textFields![0].text!)
		})
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
			print("Cancel button tapped")
		}
		
		createGroup.addAction(create)
		createGroup.addAction(cancel)
		self.present(createGroup, animated: true, completion: nil)
	}
	
	@IBAction func signOut(_ sender: UIBarButtonItem) {
		let signOutConfirm = UIAlertController(title: "Confirm", message: "Are you sure you want to log out?", preferredStyle: .alert)
		
		let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
			print("Ok, Signing Out..")
			try! Auth.auth().signOut()
			if self.storyboard != nil {
				let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
				self.navigationController?.pushViewController(vc, animated: true)
			}
		})
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
			print("Cancel button tapped")
		}
		
		signOutConfirm.addAction(yes)
		signOutConfirm.addAction(cancel)
		
		// Present dialog message to user
		self.present(signOutConfirm, animated: true, completion: nil)
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
			
			let group = groups[indexPath.row]
			
			if(group.key == user.uid){
				let alert = UIAlertController(title: "Error", message: "Cannot Delete Personal ToDo List", preferredStyle: UIAlertControllerStyle.alert)
				alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
				self.present(alert, animated: true, completion: nil)
				return
			}
			
			groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
			group.ref?.removeValue()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
	/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
		
		guard let naviViewController = segue.destination as? UINavigationController else {
			fatalError("Unexpected destination: \(segue.destination)")
		}
		
		guard let doTableViewController = naviViewController.viewControllers.first as? DoTableViewController else {
			fatalError("Unexpected sender: \(String(describing: sender))")
		}
		
		guard let selectedGroupCell = sender as? GroupTableViewCell else {
			fatalError("Unexpected sender: \(String(describing: sender))")
		}
		
		guard let indexPath = tableView.indexPath(for: selectedGroupCell) else {
			fatalError("The selected cell is not being displayed by the table")
		}
		
		let selectedGroup = groups[indexPath.row]
		doTableViewController.group = selectedGroup
    }
	*/

}
