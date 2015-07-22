//
//  exploreHacksVC.swift
//  Kiwi
//
//  Created by Dav Sun on 7/21/15.
//  Copyright (c) 2015 Plico. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class exploreHacksVC:UIViewController {
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.updateHacks()
    }
    
    func updateHacks(){
        println("_____________________________________________________")
        Alamofire.request(.GET, "https://www.eventbriteapi.com/v3/events/search/", parameters: ["q": "hack"])
            .responseJSON { _, _, json, _ in
                var obj = JSON(json!)
                println(obj)
                if obj["status_code"] == 401 {
                    var url = NSURL(string: "https://www.eventbrite.com/oauth/authorize?response_type=code&client_id=FZXO4OPBM7EJVCFJP3")
                    UIApplication.sharedApplication().openURL(url!)
                }
        }
    }
}