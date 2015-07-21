//
//  profileVC.swift
//  Kiwi
//
//  Created by Dav Sun on 7/20/15.
//  Copyright (c) 2015 Plico. All rights reserved.
//

import Foundation
import Parse
class profileVC: UIViewController {
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    
    var colors = [UIColor(red: 38/255, green: 166/255, blue: 91/255, alpha: 1),UIColor(red: 144/255, green: 198/255, blue: 149/255, alpha: 1),UIColor(red: 135/255, green: 211/255, blue: 124/255, alpha: 1),UIColor(red: 104/255, green: 195/255, blue: 163/255, alpha: 1),UIColor(red: 27/255, green: 188/255, blue: 155/255, alpha: 1),UIColor(red: 27/255, green: 163/255, blue: 156/255, alpha: 1),UIColor(red: 102/255, green: 204/255, blue: 153/255, alpha: 1),UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1),UIColor(red: 22/150255, green: 160/255, blue: 133/255, alpha: 1),UIColor(red: 63/255, green: 195/255, blue: 128/255, alpha: 1),UIColor(red: 1/255, green: 152/255, blue: 117/255, alpha: 1),UIColor(red: 3/255, green: 166/255, blue: 120/255, alpha: 1)]
    
    override func viewDidLoad() {
        self.randomColor()
        self.coverImage.clipsToBounds = true;
        self.profile.clipsToBounds = true;
        self.setupImage()
    }
    override func viewDidLayoutSubviews() {
        profile.layoutIfNeeded()
        self.profile.layer.cornerRadius = profile.frame.size.height/2 + 1
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
    
    func randomColor(){
        println("here!")
        var randomNumber : Int = Int(rand()) % (colors.count - 1)
        println(randomNumber)
        coverImage.backgroundColor = colors[randomNumber]

    }
}