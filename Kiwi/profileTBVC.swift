//
//  profileTBVC.swift
//  Kiwi
//
//  Created by Dav Sun on 7/20/15.
//  Copyright (c) 2015 Plico. All rights reserved.
//

import Foundation
import Parse
class profileTBVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var storyboard = UIStoryboard(name: "profile", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("profile") as! profileSVC
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
    }
}