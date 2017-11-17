//
//  NewTaskViewController.swift
//  Chai_Leon_FinalProject
//
//  Created by Leon Chai on 2017-10-23.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

	@IBOutlet weak var taskNameTxtField: UITextField!
	@IBOutlet weak var dueDateField: UIDatePicker!
	@IBOutlet weak var descriptionField: UITextView!
	
	@IBOutlet weak var saveButton: UIBarButtonItem!
	var task: Task?
	var key: String = ""
	
	override func viewDidLoad() {
        super.viewDidLoad()

		taskNameTxtField.delegate = self
		descriptionField.delegate = self
		
		if let task = task {
			navigationItem.title = task.name
			taskNameTxtField.text = task.name
			dueDateField.date = task.dueDate
			descriptionField.text = task.description
			key = task.key
		}
		updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		// Disable the Save button while editing.
		saveButton.isEnabled = false
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		updateSaveButtonState()
		navigationItem.title = textField.text
	}
	
	private func updateSaveButtonState() {
		// Disable the Save button if the text field is empty.
		let text = taskNameTxtField.text ?? ""
		saveButton.isEnabled = !text.isEmpty
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}

	@IBAction func cancel(_ sender: UIBarButtonItem) {
		let isPresentingInAddTaskMode = presentingViewController is UINavigationController

		if (isPresentingInAddTaskMode){
			dismiss(animated: true, completion: nil)
		} else if let owningNaviController = navigationController{
			
			if (owningNaviController.popViewController(animated: true) == nil){
				dismiss(animated: true, completion: nil)
			}
		} else {
			fatalError("The NewTaskViewController is not inside a navigation controller.")
		}
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
		
		task = Task(name: name, description: description, dueDate: dueDate, key: key)
		
    }
	

}
