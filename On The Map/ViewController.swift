//
//  ViewController.swift
//  On The Map
//
//  Created by John Longenecker on 1/28/16.
//  Copyright © 2016 John Longenecker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var session: NSURLSession!
    let usernameAndPasswordDictionary = ["username":"longenecker@me.com","password":"Iay$D1kI8TPPj1Gdi"]
    @IBOutlet weak var resultsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        session = NSURLSession.sharedSession()
        resultsLabel.hidden = true
    }

    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonPressed(sender: AnyObject) {

        OTMClient.sharedInstance().authenticateWithViewController(usernameAndPasswordDictionary) {(success, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.resultsLabel.text = "succss"
                    self.resultsLabel.hidden = false
                    })
            } else  {
                print("\(errorString)")
            }
        }
        
    }

    
//    func taskForGetMethodUdacityLogin() {
//        let methodArguments = [
//            "limit":"100",
//        ]
//        
//        let url = NSURL(string: "https://api.parse.com/1/classes/StudentLocation" + escapedParameters(methodArguments))!
//        /* 2/3. Build the URL and configure the request */
//        let request = NSMutableURLRequest(URL: url)
//        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//        
//        
//        /* 4. Make the request */
//        let task = session.dataTaskWithRequest(request) { (data, response, error) in
//            
//            /* GUARD: Was there an error? */
//            guard (error == nil) else {
//                print("There was an error with your request: \(error)")
//                return
//            }
//            
//            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                if let response = response as? NSHTTPURLResponse {
//                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
//                } else if let response = response {
//                    print("Your request returned an invalid response! Response: \(response)!")
//                } else {
//                    print("Your request returned an invalid response!")
//                }
//                return
//            }
//            
//            /* GUARD: Was there any data returned? */
//            guard let data = data else {
//                print("No data was returned by the request!")
//                return
//            }
//            
//            var parsedResult: AnyObject!
//            do {
//                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [String:AnyObject]
//                print("Parsed Result from ParseGet: \(parsedResult)")
//            } catch {
//                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
//                print("\(userInfo)")
//                
//            }
//            
//            if let parsedResult = parsedResult {
//                let account = parsedResult["account"] as? [String:AnyObject]
//                if let account = account {
//                    let loginResult = account["registered"] as? Bool
//                    if let loginResult = loginResult {
//                        if loginResult {
//                            dispatch_async(dispatch_get_main_queue()) {
//                                self.resultsLabel.text = "Success!"
//                                self.resultsLabel.hidden = false
//                            }
//                        }
//                    }
//                }
//            }
//            
//            
//        }
//        task.resume()
//    }

    
 
    
}

