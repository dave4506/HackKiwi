//
//  ViewController.swift
//  Kiwi
//
//  Created by Dav Sun on 7/20/15.
//  Copyright (c) 2015 Plico. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signUpButton.layer.cornerRadius = 28
        self.signUpButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.signUpButton.layer.borderWidth = 1
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func signUpAction(sender: AnyObject) {
        var storyboard = UIStoryboard(name: "signIn:Up", bundle: nil)
        var controller = storyboard.instantiateViewControllerWithIdentifier("signUp") as! signUpVC
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func logInAction(sender: AnyObject) {
        let main = UIStoryboard(name: "signIn:Up", bundle: nil)
        let vc = main.instantiateViewControllerWithIdentifier("navCon") as! UINavigationController
        self.showViewController(vc, sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

