//
//  DetailTaskViewController.swift
//  Chai_Leon_DDD
//
//  Created by Leon Chai on 2017-11-11.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit

class DetailTaskViewController: UIViewController {

	@IBOutlet weak var nameLbl: UILabel!
	@IBOutlet weak var dateLbl: UILabel!
	@IBOutlet weak var descriptionLbl: UILabel!
	@IBOutlet weak var userLbl: UILabel!
	
	var task: Task?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		if let task = task {
			navigationItem.title = task.name
			
			nameLbl.text = task.name
			nameLbl.sizeToFit()
			
			dateLbl.text = Utils.dateToString(date: task.dueDate)
			dateLbl.sizeToFit()
			
			descriptionLbl.text = task.description
			descriptionLbl.sizeToFit()
			
			userLbl.text = task.user
			userLbl.sizeToFit()
		}

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func backButton(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
