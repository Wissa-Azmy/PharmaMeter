//
//  LoginController.swift
//  PharmaMeter
//
//  Created by Wissa Azmy on 6/8/16.
//  Copyright © 2016 Wissa Azmy. All rights reserved.
//

import UIKit

class LoginController: UIViewController {


    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    func displayAlert (title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginBtn(sender: UIButton) {
        // Check if the Fields are empty
        if usernameField.text == "" || passField.text == "" {
            displayAlert("Missing Field(s)", message: "Username and password are required")
        } else {
            let username = usernameField.text
            let password = passField.text
            
            print("Username: \(username)")
            print("Password: \(password)")
            
            // Request Configuration
            let url = NSURL(string: "http://localhost:8000/api/login")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            
            // Send the data in the request body
            let postString = "&password=\(password!)&username=\(username!)"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if error != nil{
                        self.displayAlert("Error", message: (error?.localizedDescription)!)
                    }
                    
                    do {
                        
                        // Parse the JSON retrieved Data
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                        
                        if let parseJSON = json {
                            let userId = parseJSON["uid"]
                            if userId != nil {
                                NSUserDefaults.standardUserDefaults().setObject(parseJSON["uid"], forKey: "userId")
                                NSUserDefaults.standardUserDefaults().setObject(parseJSON["token"], forKey: "token")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                
                                let userToken = parseJSON["token"]
                                print(userToken)
                                
                                self.displayAlert("Success", message: "You are Successfuly Logged In")

                                let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController")
                                let mainPageNav = UINavigationController(rootViewController: mainPage!)
                                let appDelegate = UIApplication.sharedApplication().delegate
                                appDelegate?.window??.rootViewController = mainPageNav
                                
                            } else {
                                self.displayAlert("Alert", message: "User doesn't exist")
                            }
                        }
                        
                    } catch {
                        print("bad things happened")
                    }
                    
                }
                
            }).resume()
            
        }
        
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
