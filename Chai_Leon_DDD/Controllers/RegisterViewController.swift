//
//  RegisterViewController.swift
//  Chai_Leon_DDD
//
//  Created by Leon Chai on 2017-11-16.
//  Copyright © 2017 Leon Chai. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var usernameTxtField: UITextField!
	@IBOutlet weak var emailTxtField: UITextField!
	@IBOutlet weak var passwordTxtField: UITextField!
	@IBOutlet weak var confirmPasswordTxtField: UITextField!
	@IBOutlet weak var messageLbl: UILabel!
	@IBOutlet weak var registerBtn: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		usernameTxtField.delegate = self
		emailTxtField.delegate = self
		passwordTxtField.delegate = self
		confirmPasswordTxtField.delegate = self
		registerBtn.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if(usernameTxtField.text! == "" || emailTxtField.text! == "" || passwordTxtField.text! == "" || confirmPasswordTxtField.text! == ""){
			registerBtn.isEnabled = false
		} else {
			registerBtn.isEnabled = true
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
    
	@IBAction func signup(_ sender: UIButton) {
		SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
		SVProgressHUD.show()
		
		let email = emailTxtField.text
		let password = passwordTxtField.text
		
		if(password != confirmPasswordTxtField.text!){
			messageLbl.text = "Not the same passwords!"
			SVProgressHUD.dismiss()
			return
		}
		
		Auth.auth().createUser(withEmail: email!, password: password!) { (user,error) in
			if(email! == ""){
				self.messageLbl.text = "Enter An Email!"
				self.messageLbl.sizeToFit()
				self.messageLbl.center.x = self.view.center.x
				SVProgressHUD.dismiss()
				return
			}
			
			if error != nil {
				if(!self.checkPassword(password: password!)){
					self.messageLbl.text = "Password Too Short!"
				} else {
					self.messageLbl.text = "Email Already Exist!"
					
				}
				self.messageLbl.sizeToFit()
				self.messageLbl.center.x = self.view.center.x
				SVProgressHUD.dismiss()
				return
			} else if let user = user {
				let changeRequest  = user.createProfileChangeRequest()
				changeRequest.displayName = self.usernameTxtField.text!
				changeRequest.commitChanges(completion: { error in
					if error != nil {
						print("error in username")
					} else {
						print("username created")
					}
				})
			}
		
			
			self.messageLbl.text = "Registered!"
			self.messageLbl.sizeToFit()
			self.messageLbl.center.x = self.view.center.x
			print(email! + " has been registered")
			FirebaseDB.createNewUserTable()
			SVProgressHUD.dismiss()
			self.performSegue(withIdentifier: "startSegue", sender: self)
		}
			
		
	}
	
	private func checkPassword(password: String) -> Bool{
		if(password.count <= 5) {
			return false
		}
		return true
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
