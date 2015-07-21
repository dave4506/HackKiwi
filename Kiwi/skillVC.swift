
//
//  File.swift
//  Kiwi
//
//  Created by Dav Sun on 7/21/15.
//  Copyright (c) 2015 Plico. All rights reserved.
//

import Foundation
import Parse

class skillVC: UIViewController,TagListViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var skills:NSMutableArray = []
    
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var skillSearch: UITextField!
    var skill:NSMutableArray = ["Full-stack","Back-end","Mobile","Game","Designer","iOS","pHp","Angular","Javascript","python","Parse","Firebase","C","C++","Obj-c","Swift","Ruby","Ruby on Rails","Java","MongoDB","SQL","NoSQP","MeteorJS","Android","Machine Learning","3-d","Myo","Oculus Rift","VR","Swag","HardWare","Arduino","Node.js","Django","Express.js","Couchbase","IBM Bluemix","Sparkpost","Linode","Autodesk","Dolby","Heroku","HTML","CSS","Go","Octave","Processing"]
    var search:NSMutableArray = [];

    @IBOutlet weak var taglistView: TagListView!
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        println("JERES")
        textField.resignFirstResponder();
        return true;
    }
    override func viewDidLoad() {
        taglistView.delegate = self;
        self.tableView.dataSource = self
        self.tableView.delegate = self
        skillSearch.addTarget(self, action:"change", forControlEvents:.EditingDidEnd);
        self.skillSearch.delegate = self
        self.done.layer.cornerRadius = 21;
    }
    override func viewWillAppear(animated: Bool) {
        self.setupTags()
        self.trim()
        search = skill
    }
    func trim(){
        skills = PFUser.currentUser()!["skills"] as! NSMutableArray
        for str in skills {
            var s = str as! String
            skill.removeObject(s)
        }
    }
    func change(){
        if skillSearch.text.isEmpty == true{
            search = skill;
        }else{
            search = [];
            for str in skill {
                var s = str as! String
                var query = self.skillSearch.text.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                if s.lowercaseString.rangeOfString(query) != nil {
                    search.addObject(s)
                }
            }
        }
        self.tableView.reloadData()
    }
    @IBAction func saveAction(sender: AnyObject) {
        var user = PFUser.currentUser()!
        user["skills"] = skills
        user.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            ProgressHUD.showSuccess(nil)
            self.dismissViewControllerAnimated(true, completion: nil)
            if error != nil {
                ProgressHUD.showError("Problem Connecting!")
            }
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        taglistView.addTag(search[indexPath.row] as! String)
        skills.addObject(search[indexPath.row] as! String)
        skill.removeObject(search[indexPath.row] as! String)
        change()
    }
    func setupTags() {
        self.taglistView.removeAllTags()
        skills = PFUser.currentUser()!["skills"] as! NSMutableArray
        for str in skills {
            var s = str as! String
            self.taglistView.addTag(s)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! skillTVC
        cell.skill.text = self.search[indexPath.row] as! String
        return cell;
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    @IBAction func dimissAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func tagPressed(title: String, sender: TagListView) {
        taglistView.removeTag(title)
        skills.removeObject(title)
        skill.addObject(title)
        change();
    }
}