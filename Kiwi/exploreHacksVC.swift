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
import Parse

class exploreHacksVC:UIViewController {
    var eventList:NSMutableArray = []
    override func viewDidLoad() {
        self.updateHacks()
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func updateHacks(){
        println()
        println()
        println()
        Alamofire.request(.GET, "https://www.eventbriteapi.com/v3/events/search?token=IK3UBM46PPY6TW6ITVSV", parameters: ["q": "hackathons", "sort_by" : "best", "venue.region": "CA"])
            .responseJSON { (_, _, JSON, _) in
                //println(JSON)
                
                let json = JSON as! NSDictionary
                let events: AnyObject = json["events"]!
                self.eventList = events as! NSMutableArray
                for var i = 0; i < self.eventList.count; i++ {
                    let firstHack: NSDictionary = self.eventList[i] as! NSDictionary //first event in brite call
                    
                    
                    let nameDic: NSDictionary = (firstHack["name"] as? NSDictionary)!
                    let name = nameDic["text"] as! String
                    
                    var parseStore = PFObject(className:"Hackathons")
                    
                    parseStore["Name"] = name
                    parseStore.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            ProgressHUD.showSuccess(nil)
                            
                        } else {
                            ProgressHUD.showError(nil)
                        }
                    }
                    
                    
                }
        }
    }
}