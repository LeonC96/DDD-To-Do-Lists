//
//  NewTaskViewController.swift
//  Chai_Leon_FinalProject
//
//  Created by Leon Chai on 2017-10-23.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController {

	@IBOutlet weak var taskNameTxtField: UITextField!
	@IBOutlet weak var dueDateField: UIDatePicker!
	@IBOutlet weak var descriptionField: UITextView!
	
	@IBOutlet weak var saveButton: UIBarButtonItem!
	var task: Task?
	
	override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		super.prepare(for: segue, sender: sender)
		
		guard let button = sender as? UIBarButtonItem, button === saveButton else {
			print("Save button was not press. Canceling new task.")
			return
		}
		
		let name = taskNameTxtField.text ?? ""
		let description = descriptionField.text
		let dueDate = dueDateField.date
		
		task = Task(name: name, description: description, dueDate: dueDate)
		
		print("this is " + (task?.dueDate.description)!)
    }
	

}
