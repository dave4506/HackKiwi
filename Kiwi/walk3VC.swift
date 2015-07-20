//
//  walk3VC.swift
//  Kiwi
//
//  Created by Dav Sun on 7/20/15.
//  Copyright (c) 2015 Plico. All rights reserved.
//

import Foundation
import UIKit
import Parse

class walk3VC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, TagListViewDelegate  {

    @IBOutlet weak var tagView: TagListView!
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var skills: UITextField!

    var personal:NSMutableArray = []
    
    var skill:NSMutableArray = ["Full-stack","Back-end","Mobile","Game","Designer","iOS","pHp","Angular","Javascript","python","Parse","Firebase","C","C++","Obj-c","Swift","Ruby","Ruby on Rails","Java","MongoDB","SQL","NoSQP","MeteorJS","Android","Machine Learning","3-d","Myo","Oculus Rift","VR","Swag","HardWare","Arduino","Node.js","Django","Express.js","Couchbase","IBM Bluemix","Sparkpost","Linode","Autodesk","Dolby","Heroku","HTML","CSS","Go","Octave","Processing"]
    var search:NSMutableArray = [];
    
    override func viewDidLoad() {
        self.tagView.delegate = self;
        self.tableView.dataSource = self
        self.tableView.delegate = self
        skills.addTarget(self, action:"change", forControlEvents:.EditingDidEnd);
        self.skills.delegate = self
        self.done.layer.cornerRadius = 28;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        println("JERES")
        textField.resignFirstResponder();
        return true;
    }
    
    func change(){
        if skills.text.isEmpty == true{
            search = skill;
        }else{
            search = [];
            for str in skill {
                var s = str as! String
                var query = self.skills.text.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                if s.lowercaseString.rangeOfString(query) != nil {
                    search.addObject(s)
                }
            }
        }
        self.tableView.reloadData()
    }
    override func viewWillAppear(animated: Bool) {
        search = skill
    }

    @IBAction func doneAction(sender: AnyObject) {
        var user = PFUser.currentUser()!
        user["skills"] = personal
        user.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            ProgressHUD.showSuccess(nil)
                self.performSegueWithIdentifier("walk", sender: self)
            if error != nil {
                ProgressHUD.showError("Problem Connecting!")
            }
        }

    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tagView.addTag(search[indexPath.row] as! String)
        personal.addObject(search[indexPath.row] as! String)
        skill.removeObject(search[indexPath.row] as! String)
        change()
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! walkSkillTVC
        cell.skill.text = self.search[indexPath.row] as! String
        return cell;
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search.count
    }
    
    func tagPressed(title: String, sender: TagListView) {
        tagView.removeTag(title)
        skill.addObject(title)
        personal.removeObject(title)
        change()
    }
}