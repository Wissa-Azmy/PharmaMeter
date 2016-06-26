//
//  ProfileController.swift
//  PharmaMeter
//
//  Created by Wissa Azmy on 6/11/16.
//  Copyright © 2016 Wissa Azmy. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        let token = NSUserDefaults.standardUserDefaults().stringForKey("token")
        
        // Request Configuration
        let url = NSURL(string: "http://localhost:8000/api/profile/\(userId!)/?token=\(token!)")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        
 
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            // Extract the TOKEN from the Response HEADER
            let httpResponse = response as? NSHTTPURLResponse
            let tokenField = httpResponse!.allHeaderFields["Authorization"] as? String
            let clearToken = tokenField!.substringWithRange(Range<String.Index>(start: tokenField!.startIndex.advancedBy(7), end: tokenField!.endIndex))
            
//            print("Response Header: \(httpResponse!)\n")
//            print("Response Token: \(tokenField!)\n")
            print("Response Clear Token: \(clearToken)")
            
            dispatch_async(dispatch_get_main_queue()) {
                
                if error != nil{
//                    self.displayAlert("Error", message: (error?.localizedDescription)!)
                }
                
                do {
                    
                    // Parse the JSON retrieved Data
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    
//                    print(json)
                    
                    if let parseJSON = json {
                        let userId = parseJSON["id"]
//                        print(parseJSON["first_name"])

                        if userId != nil {
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON["first_name"], forKey: "firstname")
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON["last_name"], forKey: "lastname")
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON["mobile_number"], forKey: "phone")
                            NSUserDefaults.standardUserDefaults().setObject(clearToken, forKey: "token")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            
                            let firstname = NSUserDefaults.standardUserDefaults().stringForKey("firstname")
                            let lastname = NSUserDefaults.standardUserDefaults().stringForKey("lastname")
                            let phone = NSUserDefaults.standardUserDefaults().stringForKey("phone")
                            
                            
                            self.usernameLbl.text = firstname! + " " + lastname! ?? " "
                            self.phoneLbl.text = phone
                            
//                            self.displayAlert("Success", message: "You are Successfuly Logged In")
                            
                            
                            
                        } else {
//                            self.displayAlert("Alert", message: "User doesn't exist")
                        }
                    }
                    
                } catch {
                    print("bad things happened")
                }
                
            }
            
        }).resume()

    }

    @IBAction func profileBackBtn() {
        let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController")
        let mainPageNav = UINavigationController(rootViewController: mainPage!)
        let appDelegate = UIApplication.sharedApplication().delegate
        appDelegate?.window??.rootViewController = mainPageNav
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
