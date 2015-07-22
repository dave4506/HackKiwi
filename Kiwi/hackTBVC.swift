//
//  hackTBVC.swift
//  Kiwi
//
//  Created by Dav Sun on 7/21/15.
//  Copyright (c) 2015 Plico. All rights reserved.
//

import Foundation
class hackTBVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        var storyboard = UIStoryboard(name: "exploreHacks", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier("hack") as! exploreHacksVC
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMoveToParentViewController(self)
    }
}