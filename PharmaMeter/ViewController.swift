//
//  ViewController.swift
//  PharmaMeter
//
//  Created by Wissa Azmy on 6/8/16.
//  Copyright © 2016 Wissa Azmy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        
        
        if userId == nil{
                self.performSegueWithIdentifier("loginView", sender: self)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutBtn(sender: UIBarButtonItem) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userId")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let signInPage = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController")
        let signInNav = UINavigationController(rootViewController: signInPage!)
        let appDelegate = UIApplication.sharedApplication().delegate
        
        appDelegate!.window??.rootViewController = signInNav
    }
    
    @IBAction func profileBtn() {
        let profilePage = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileController")
        let profileNav = UINavigationController(rootViewController: profilePage!)
        let appDelegate = UIApplication.sharedApplication().delegate
        
        appDelegate!.window??.rootViewController = profileNav
        
    }
}

