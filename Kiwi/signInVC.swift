//
//  signInVC.swift
//  Kiwi
//
//  Created by Dav Sun on 7/20/15.
//  Copyright (c) 2015 Plico. All rights reserved.
//

import Foundation
import Parse
class signInVC: UIViewController {

    @IBOutlet weak var passcode: UITextField!
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func signInAction(sender: AnyObject) {
        ProgressHUD.show("Please Wait...", interaction: false)
        
        PFUser.logInWithUsernameInBackground(username.text, password:passcode.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
               ProgressHUD.showSuccess(nil)
            } else {
                ProgressHUD.showError("Login Invalid.")
            }
        }

    }
    
    override func viewDidLoad() {
        self.signInButton.layer.cornerRadius = 28
        self.signInButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.signInButton.layer.borderWidth = 1
    }
}