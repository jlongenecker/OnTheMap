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
    @IBOutlet weak var parseResultsLabel: UILabel!
    @IBOutlet weak var signUpForUdacityOutlet: UIButton!
    
    @IBOutlet weak var udacitySignUpCompleteLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        session = NSURLSession.sharedSession()
        hideLabels()
        
    }

    func hideLabels() {
        resultsLabel.hidden = true
        parseResultsLabel.hidden = true
        udacitySignUpCompleteLabel.hidden = true
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

    
    @IBAction func parseGetButtonPressed(sender: AnyObject) {
        OTMClient.sharedInstance().getStudentLocations() {(success, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.parseResultsLabel.text = "Parse Results Sucess"
                    self.parseResultsLabel.hidden = false
                })
            } else {
                print("Parse Error String: \(errorString)")
            }
        
        }
        
    }
 
    @IBAction func signUpForUdacityButtonPressed(sender: AnyObject) {
        OTMClient.sharedInstance().signUpForUdacity(self) {(success, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.signUpForUdacityOutlet.hidden = true
                    self.udacitySignUpCompleteLabel.text = "Congrats on signing up with Udacity. Enter your credentials to begin."
                    self.udacitySignUpCompleteLabel.hidden = false
                })
            }

        }
    }
    
    
    
}

