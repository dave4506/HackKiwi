//
//  walk4VC.swift
//  Kiwi
//
//  Created by Dav Sun on 7/20/15.
//  Copyright (c) 2015 Plico. All rights reserved.
//

import Foundation
import Parse
class walk4VC: UIViewController {
    
    @IBOutlet weak var finish: UIButton!
    override func viewDidLoad() {
        finish.layer.cornerRadius = 28
    }
    @IBAction func finishAction(sender: AnyObject) {
        var user = PFUser.currentUser()!
        user["first"] = false;
        user.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
                ProgressHUD.showSuccess(nil)
                let main = UIStoryboard(name: "central", bundle: nil)
                let vc = main.instantiateViewControllerWithIdentifier("tabCon") as! UITabBarController
                self.showViewController(vc, sender: self)
            if error != nil {
                ProgressHUD.showError("Problem Connecting!")
            }
        }
    }
}