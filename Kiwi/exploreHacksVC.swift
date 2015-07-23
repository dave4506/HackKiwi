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

class exploreHacksVC:UIViewController, CLLocationManagerDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var locationNow: UILabel!
    @IBOutlet weak var collectView: UICollectionView!
    @IBOutlet weak var searchButton: UIButton!
    let locationManager = CLLocationManager()
    var city = ""
    var search = false;
    var arr = NSMutableArray();
    var name = ""
    var file = PFFile()
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var goto:String = ""
    
    
    var eventList:NSMutableArray = []
    var parseList:NSMutableArray = []
    var nameList:NSMutableArray = []
    var finalList:NSMutableArray = []
    var isEqualName:Bool = true
    override func viewDidLoad() {
        
        self.collectView.delegate = self
        self.collectView.dataSource = self
        self.collectView.alwaysBounceVertical = true

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        
        self.updateHacks()
        self.loadData()
        
    }
    func loadData(){
        var query = PFQuery(className: "Hackathons")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.arr.addObject(object)
                    }
                }
                self.collectView.reloadData()
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    
    }
    @IBAction func search(sender: AnyObject) {
        if search == false {
            arr = [];
            let alertController = UIAlertController(title: "Search", message: nil, preferredStyle: .Alert)
            
            let changeAction = UIAlertAction(title: "Search", style: .Default) { (_) in
                let loginTextField = alertController.textFields![0] as! UITextField
                if loginTextField.text != "" {
                    var word = loginTextField.text.lowercaseString
                    var query = PFQuery(className: "Hackathons")
                    query.whereKey("Name", containsString: word)
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            // The find succeeded.
                            println("Successfully retrieved \(objects!.count) scores.")
                            // Do something with the found objects
                            if let objects = objects as? [PFObject] {
                                for object in objects {
                                    self.arr.addObject(object)
                                }
                            }
                            self.searchButton.titleLabel!.text = "Cancel"
                            self.search = true;
                            self.collectView.reloadData()
                        } else {
                            // Log details of the failure
                            println("Error: \(error!) \(error!.userInfo!)")
                        }
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive) { (_) in }
            
            alertController.addTextFieldWithConfigurationHandler { (textField) in
                textField.placeholder = "Search Hacks"
            }
            alertController.addAction(changeAction)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            arr = [];
            var query = PFQuery(className: "Hackathons")
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    println("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            self.arr.addObject(object)
                        }
                    }
                    self.searchButton.titleLabel!.text = "Search"
                    self.search = false;
                    self.collectView.reloadData()
                } else {
                    // Log details of the failure
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }
        }
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:HackCollectionViewCell = collectView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! HackCollectionViewCell
        var obj = arr[indexPath.row] as! PFObject
        
        cell.name.text = obj["Name"] as? String
        //cell.location.text = obj["location"] as! String
        //let startDate:NSDate = NSDate()
        //let endDate:NSDate = obj.createdAt!
       // let cal = NSCalendar.currentCalendar()
        //let unit:NSCalendarUnit = .CalendarUnitDay
        //hours = obj["Hours"] as! Int
        //let components = cal.components(unit, fromDate: startDate, toDate: endDate, options: nil)
        //cell.date.text = "\(components.day) days till"
        /*
        let userImageFile = obj["image"] as! PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    cell.image.image = image
                }
            }
        }
        */
        //cell.image.image = UIImage(named: "kiwi")
        //cell.image.layer.cornerRadius = 39;
       // cell.image.clipsToBounds = true
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var obj = arr[indexPath.row] as! PFObject
        //goto = obj.objectId!
        name = obj["Name"] as! String
        //file = obj["image"] as! PFFile
        
        self.performSegueWithIdentifier("hack", sender: self)
        
    }
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
    }
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
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
        //println(placemark.locality)
        //println(placemark.postalCode)
        //println(placemark.administrativeArea)
        //println(placemark.country)
        
        city = placemark.administrativeArea
        
        locationNow.text = "\(placemark.locality), \(city)"
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: " + error.localizedDescription)
    }
    
    
    func updateHacks(){
        println()
        println()
        println()
        Alamofire.request(.GET, "https://www.eventbriteapi.com/v3/events/search?token=IK3UBM46PPY6TW6ITVSV", parameters: ["q": "hackathons", "sort_by" : "best", "venue.region": city])
            .responseJSON { (_, _, JSON, _) in
                
            let json = JSON as! NSDictionary
            let events: AnyObject = json["events"]!
                
            self.eventList = events as! NSMutableArray
            for var i = 0; i < self.eventList.count; i++ {
                let firstHack: NSDictionary = self.eventList[i] as! NSDictionary //first event in brite call
                    
                    
                let nameDic: NSDictionary = (firstHack["name"] as? NSDictionary)!
                let name = nameDic["text"] as! String
                

                
                var query = PFQuery(className: "Hackathons")
                query.findObjectsInBackgroundWithBlock {
                    (objects: [AnyObject]?, error: NSError?) -> Void in
                    if error == nil {
                        if let objects = objects as? [PFObject] {
                            for object in objects {
                                if (object["Name"] as? String == name)  {
                                    self.isEqualName = false
                                }
                            }
                            if(self.isEqualName){
                                var hackathonsParse = PFObject(className: "Hackathons")
                                hackathonsParse["Name"] = name
                               // hackathonsParse["Picture"] = UIImage(data: NSData(contentsOfURL: NSURL(string:parseImage)!)!)
                                hackathonsParse.saveInBackgroundWithBlock {
                                    (success: Bool, error: NSError?) -> Void in
                                    if (success) {
                                        // The object has been saved.
                                    } else {
                                        // There was a problem, check error.description
                                    }
                                }
                                self.isEqualName = true
                            }
                                
                        }
                    }
                    else{
                        println("Error when querying")
                    }
                }
                
            }
        }
        self.loadData()
    }
    
}
