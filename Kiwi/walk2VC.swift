//
//  walk2VC.swift
//  Kiwi
//
//  Created by Dav Sun on 7/20/15.
//  Copyright (c) 2015 Plico. All rights reserved.
//

import Foundation
import Parse

class walk2VC: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var picker: UIButton!
    @IBOutlet weak var next: UIButton!
    
    var verify = false;
    
    @IBAction func pickerAction(sender: AnyObject) {
        self.actionSheet()
    }
    
    func actionSheet(){
        var ActionSheet = UIActionSheet(title: "Image", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle:nil, otherButtonTitles: "Take a picture")
        ActionSheet.addButtonWithTitle("Choose a picture")
        ActionSheet.delegate = self
        ActionSheet.showInView(self.view)
    }
    
    @IBAction func nextAction(sender: AnyObject) {
        if verify == true && self.name.text.isEmpty == false {
            var user = PFUser.currentUser()!
            user["name"] = self.name.text;
            user.saveInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                ProgressHUD.showSuccess(nil)
                self.performSegueWithIdentifier("skill", sender: self)
                if error != nil {
                    ProgressHUD.showError("Problem Connecting!")
                }
            }
        }else{
            ProgressHUD.showError("You missed something!")
        }
    }
    
    func actionSheet(myActionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int){
        if buttonIndex == 1 {
            ShouldStartCamera(self, true)
        }
        if buttonIndex == 2 {
            ShouldStartPhotoLibrary(self, true)
        }
    }
    
    override func viewDidLoad() {
        self.next.layer.cornerRadius = 28
        profile.layoutIfNeeded()
        self.profile.layer.cornerRadius = profile.frame.size.height/2
        self.profile.clipsToBounds = true;
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.profile.image = image;
        var file:PFFile = PFFile(name: "picture.jpeg", data: UIImageJPEGRepresentation(image, 0.6));
        var user = PFUser.currentUser()!
        user["profilepic"] = file;
        user.saveInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            ProgressHUD.showSuccess(nil)
            self.verify = true;
            if error != nil {
                ProgressHUD.showError("Problem Connecting!")
            }
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}