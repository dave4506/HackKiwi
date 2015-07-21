//
//  profileSVC.swift
//  Kiwi
//
//  Created by Dav Sun on 7/21/15.
//  Copyright (c) 2015 Plico. All rights reserved.
//

import Foundation

class profileSVC: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = containerView.frame.size
        scrollView.addSubview(containerView)
        // Do any additional setup after loading the view.
    }
}