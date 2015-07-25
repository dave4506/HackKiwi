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
import CoreLocation
import UIKit

class exploreHacksVC:UIViewController, CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var tabsView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationNow: UILabel!
    let locationManager = CLLocationManager()
    var city = ""
    var search = false;
    var arr = NSMutableArray();
    var name = ""
    var file = PFFile()
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var goto:String = ""
    
    var buttons = ["Popular","Around You","Search","Popular on Kiwi"]
    
    var eventList:NSMutableArray = []
    var parseList:NSMutableArray = []
    var nameList:NSMutableArray = []
    var finalList:NSMutableArray = []
    var isEqualName:Bool = true
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tabsView.dataSource = self
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        
        self.updateHacks()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:HackCollectionTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! HackCollectionTableViewCell
            var obj = arr[indexPath.row] as! PFObject
            cell.icon.layer.cornerRadius = 20;
            cell.icon.clipsToBounds = true;
            cell.name.text = obj["Name"] as? String
            //var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(50, 10, 37, 37)) as UIActivityIndicatorView
            //loadingIndicator.startAnimating()
            //loadingIndicator.center = cell.icon.center
            //cell.contentView.addSubview(loadingIndicator)
        if let url = obj["logoUrl"] as? String {
            cell.icon.downloadImage(url)
        }
        
        return cell
    }

    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Error: " + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Error with the data.")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        
        self.locationManager.stopUpdatingLocation()
        
        city = placemark.administrativeArea
        
        locationNow.text = "\(placemark.locality), \(city)"
        
    }
    
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: " + error.localizedDescription)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: tabCVC = tabsView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! tabCVC
        var obj = self.buttons[indexPath.item] as! String
        cell.name.text = obj;
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func updateHacks(){
        ProgressHUD.show(nil)
        self.arr = [];
        Alamofire.request(.GET, "https://www.eventbriteapi.com/v3/events/search?token=IK3UBM46PPY6TW6ITVSV", parameters: ["q": "hackathons", "sort_by" : "best", "venue.region": city])
            .responseJSON { (_, _, JSON, _) in
                
                let json = JSON as! NSDictionary
                let events: AnyObject = json["events"]!
                
                self.eventList = events as! NSMutableArray
                var query = PFQuery(className: "Hackathons")
                query.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    if error == nil {
                        if let objects = objects as? [PFObject] {
                            var arr = [] as! NSMutableArray
                            for var i = 0; i < self.eventList.count; i++ {
                                var found = -1;
                                var obj = PFObject(className: "Hackathon")
                                for object in objects {
                                    if i != self.eventList.count {
                                        let firstHack: NSDictionary = self.eventList[i] as! NSDictionary //first event in brite call
                                        let nameDic: NSDictionary = (firstHack["name"] as? NSDictionary)!
                                        let name = nameDic["text"] as! String
                                        if object["Name"] as! String == name {
                                            found = i;
                                            obj = object;
                                        }
                                    }
                                }
                                if found == -1 {
                                            let firstHack: NSDictionary = self.eventList[i] as! NSDictionary //first event in brite call
                                            let url: String  = (firstHack["url"] as? String)!
                                            let nameDic: NSDictionary = (firstHack["name"] as? NSDictionary)!
                                            let name = nameDic["text"] as! String
                                            let start: NSDictionary = (firstHack["start"] as? NSDictionary)!
                                            let end: NSDictionary = (firstHack["end"] as? NSDictionary)!
                                            let dateFormatter = NSDateFormatter()
                                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                                            let start_utc = dateFormatter.dateFromString(start["utc"] as! String)
                                            let end_utc = dateFormatter.dateFromString(end["utc"] as! String)
                                    
                                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                                            let start_loc = dateFormatter.dateFromString(start["local"] as! String)
                                            let end_loc = dateFormatter.dateFromString(end["local"] as! String)
                                            
                                            var hackathonsParse = PFObject(className: "Hackathons")
                                            
                                            if let logo: NSDictionary = firstHack["logo"] as? NSDictionary {
                                                let logoUrl: String = logo["url"] as! String
                                                hackathonsParse["logoUrl"] = logoUrl
                                            }
                                            hackathonsParse["utcStart"] = start_utc
                                            hackathonsParse["utcEnd"] = end_utc
                                            hackathonsParse["locStart"] = start_loc
                                            hackathonsParse["locEnd"] = end_loc
                                            hackathonsParse["Name"] = name
                                            hackathonsParse["url"] = url
                                            arr.addObject(hackathonsParse)
                                            self.arr.addObject(hackathonsParse)
                                            
                                } else {
                                    self.arr.addObject(obj)
                                }
                            }
                                self.tableView.reloadData()
                                PFObject.saveAllInBackground(arr as [AnyObject]){
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                        ProgressHUD.dismiss()
                                        println("Saved event")
                                        // The object has been saved.
                                    } else {
                                    println(error)
                                    // There was a problem, check error.description
                                    }
                                }
                        }
                }
            }
        }
    }
}
