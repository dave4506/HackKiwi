//
//  profileVC.swift
//  Kiwi
//
//  Created by Dav Sun on 7/20/15.
//  Copyright (c) 2015 Plico. All rights reserved.
//

import Foundation
import Parse
class profileVC: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate, TagListViewDelegate {
    
    @IBOutlet weak var usernameBlock: UIView!
    @IBOutlet weak var nameBlock: UIView!
    @IBOutlet weak var infoBlock: UIView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var coverButton: UIButton!
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var taglistView: TagListView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var blirb: UITextView!
    
    @IBOutlet weak var works: UITextView!
    
    var camera = 0;
    
    var colors = [UIColor(red: 38/255, green: 166/255, blue: 91/255, alpha: 1),UIColor(red: 144/255, green: 198/255, blue: 149/255, alpha: 1),UIColor(red: 135/255, green: 211/255, blue: 124/255, alpha: 1),UIColor(red: 104/255, green: 195/255, blue: 163/255, alpha: 1),UIColor(red: 27/255, green: 188/255, blue: 155/255, alpha: 1),UIColor(red: 27/255, green: 163/255, blue: 156/255, alpha: 1),UIColor(red: 102/255, green: 204/255, blue: 153/255, alpha: 1),UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1),UIColor(red: 22/150255, green: 160/255, blue: 133/255, alpha: 1),UIColor(red: 63/255, green: 195/255, blue: 128/255, alpha: 1),UIColor(red: 1/255, green: 152/255, blue: 117/255, alpha: 1),UIColor(red: 3/255, green: 166/255, blue: 120/255, alpha: 1)]
    
    override func viewDidLoad() {
        self.randomColor()
        self.coverImage.clipsToBounds = true;
        self.profile.clipsToBounds = true;
        self.profile.layer.borderColor = UIColor.whiteColor().CGColor
        self.profile.layer.borderWidth = 2
        self.taglistView.delegate = self
        //self.usernameBlock.layer.borderWidth = 1;
        //self.usernameBlock.layer.borderColor = UIColor.whiteColor().CGColor
    }
    @IBAction func editSkillAction(sender: AnyObject) {
        self.performSegueWithIdentifier("skill", sender: self)
    }
    override func viewWillAppear(animated: Bool) {
        self.randomColor()
        self.setupText()
        self.setupImage()
        self.setupSkills()
        var name = PFUser.currentUser()!["name"] as! String
        self.name.text = name.uppercaseString
        var username = PFUser.currentUser()!.username
        self.username.text = username!.uppercaseString
    }
    override func viewDidLayoutSubviews() {
        profile.layoutIfNeeded()
        self.profile.layer.cornerRadius = profile.frame.size.height/2 + 1
    }
    
    func setupSkills(){
        self.taglistView.removeAllTags()
        var skills = PFUser.currentUser()!["skills"] as! NSArray
        for str in skills {
            var s = str as! String
            self.taglistView.addTag(s)
        }
    }
    func setupText(){
        if let blirbText = PFUser.currentUser()!["blirb"] as? String {
            self.blirb.text = blirbText;
        }
        if let workText = PFUser.currentUser()!["work"] as? String {
            self.works.text = workText;
        }
    }
    func setupImage(){
        let userImageFile = PFUser.currentUser()!["profilepic"] as! PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    self.profile.image = image
                }
            }else{
                println(error)
            }
        }
    }
    

    @IBAction func editAction(sender: AnyObject) {
        var str = self.editButton.titleLabel?.text
        if str == "Edit" {
            self.editButton.setTitle("Save", forState: .Normal)
            self.blirb.editable = true;
            self.works.editable = true;
            
        }else if str == "Save" {
            self.editButton.setTitle("Edit", forState: .Normal)
            self.blirb.editable = false;
            self.works.editable = false;
            var user = PFUser.currentUser()!
            user["blirb"] = self.blirb.text;
            user["work"] = self.works.text;
            ProgressHUD.show(nil, interaction: false)
            user.saveInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if error != nil {
                    ProgressHUD.showError("Problem Connecting!")
                }else{
                    ProgressHUD.showSuccess(nil)
                }
            }
        }
    }
    
    @IBAction func coverAction(sender: AnyObject) {
        camera = 2;
        self.actionSheet()
    }
    @IBAction func profileAction(sender: AnyObject) {
        camera = 1;
        self.actionSheet()
    }
    func actionSheet(){
        var ActionSheet = UIActionSheet(title: "Image", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle:nil, otherButtonTitles: "Take a picture")
        ActionSheet.addButtonWithTitle("Choose a picture")
        ActionSheet.delegate = self
        ActionSheet.showInView(self.view)
    }
    
    func actionSheet(myActionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int){
        if buttonIndex == 1 {
            ShouldStartCamera(self, true)
        }
        if buttonIndex == 2 {
            ShouldStartPhotoLibrary(self, true)
        }
    }
    func randomColor(){
        println("here!")
        var randomNumber : Int = Int(rand()) % (colors.count - 1)
        println(randomNumber)
        coverImage.backgroundColor = colors[randomNumber]
        if let userImageFile = PFUser.currentUser()!["coverpic"] as? PFFile {
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        self.coverImage.image = image
                    }
                }else{
                    println(error)
                }
            }
        }
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        var file:PFFile = PFFile(name: "picture.jpeg", data: UIImageJPEGRepresentation(image, 0.6));
        var user = PFUser.currentUser()!
        if camera == 1 {
            user["profilepic"] = file;
            self.profile.image = image;
        }else if camera == 2 {
            user["coverpic"] = file;
            self.coverImage.image = image;
        }
        user.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error != nil {
                ProgressHUD.showError("Problem Connecting!")
            }else{
                ProgressHUD.showSuccess(nil)
            }
            self.camera = 0;
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}