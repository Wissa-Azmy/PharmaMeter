//
//  SignupController.swift
//  PharmaMeter
//
//  Created by Wissa Azmy on 6/9/16.
//  Copyright © 2016 Wissa Azmy. All rights reserved.
//

import UIKit

class SignupController: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    
    
    
    func displayAlert (title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        if title == "Success" {
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                action in self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }else {
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signUpBtn(sender: UIButton) {
        
        if firstNameField.text == "" || lastNameField.text == "" || usernameField.text == "" || emailField.text == "" || phoneField.text == "" || passField.text == "" || confirmPassField.text == "" {
            displayAlert("Missing Field(s)", message: "All Fields are required")
            
        } else if passField.text != confirmPassField.text {
            displayAlert("Invalid Passwowrd", message: "Password fields do not match")
            
        } else {
            let firstName = firstNameField.text
            let lastName = lastNameField.text
            let username = usernameField.text
            let email = emailField.text
            let phone = phoneField.text
            let password = passField.text
            
            // Request Configuration
            let url = NSURL(string: "http://localhost:8000/api/signup")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            
            // Send the data in the request body
            let postString = "email=\(email!)&password=\(password!)&mobile_number=\(phone!)&first_name=\(firstName!)&last_name=\(lastName!)&username=\(username!)"
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
                            let msg = parseJSON["msg"] as? String
                            if msg == "added successfully" {
//                                let msg = parseJSON["message"] as? String
                                self.displayAlert("Success", message: msg!)
                            } else {
//                                let msg = parseJSON["message"] as? String
                                self.displayAlert("Error", message: msg!)
                            }
                        }
                        
                    } catch {
                        self.displayAlert("Error", message: "Bad things happened")
                    }
                    
                }
                
            }).resume()
            
        }

    }

 
    @IBAction func loginViewBtn(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
