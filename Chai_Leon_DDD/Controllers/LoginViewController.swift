//
//  LoginViewController.swift
//  Chai_Leon_DDD
//
//  Created by Leon Chai on 2017-11-06.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var emailTxtField: UITextField!
	@IBOutlet weak var passwordTxtField: UITextField!
	@IBOutlet weak var messageLbl: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.tabBarController?.tabBar.isHidden = true
		self.navigationController?.navigationBar.isHidden = true
		
		emailTxtField.delegate = self
		passwordTxtField.delegate = self
		
		
        // Do any additional setup after loading the view.
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
    
	@IBAction func login(_ sender: UIButton) {
		
		SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
		SVProgressHUD.show()
		
		let email = emailTxtField.text
		let password = passwordTxtField.text
		
		Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
			if error != nil {
				self.messageLbl.text = "Wrong Email or Password. Try Agian."
				self.messageLbl.sizeToFit()
				self.messageLbl.center.x = self.view.center.x
				
				SVProgressHUD.dismiss()
				return
			}
			
			self.messageLbl.text = "Login!"
			self.messageLbl.sizeToFit()
			self.messageLbl.center.x = self.view.center.x
			print("Successfully Login")
			SVProgressHUD.dismiss()
			self.performSegue(withIdentifier: "startSegue", sender: self)

		}
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
