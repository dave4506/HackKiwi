//
//  signUpVC.swift
//  Kiwi
//
//  Created by Dav Sun on 7/20/15.
//  Copyright (c) 2015 Plico. All rights reserved.
//

import Foundation
import Parse

class signUpVC: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passCode: UITextField!
    @IBOutlet weak var repeat: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signUpButton.layer.cornerRadius = 28
        self.signUpButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.signUpButton.layer.borderWidth = 1
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signUpAction(sender: AnyObject) {
        var user:PFUser = PFUser()
        //user.email = emailTextField.text
        var pass = true;
        if passCode.text == repeat.text {
            user.password = passCode.text
        }else{
            pass = false;
            ProgressHUD.showError("Passwords don't match!")
        }
        user.username = userName.text
        user["first"] = true;
        if pass == true {
            ProgressHUD.show(nil)
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo?["error"] as? NSString
                    ProgressHUD.showError("Sign Up Invalid.")
                    // Show the errorString somewhere and let the user try again.
                } else {
                    ProgressHUD.showSuccess("Sign Up is Valid!")
                    self.dismissViewControllerAnimated(true, completion:nil)
                    //self.performSegueWithIdentifier("signupgood", sender: nil)
                    
                }
            }
        }
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
