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
    
    let usernameAndPasswordDictionary = ["username": "longenecker@me.com", "password": "iFjPqp3j4sFWw4vTZ"]
    
    let deviceOffline = "The Internet connection appears to be offline."
    var alertViewControllerTitle = ""
    var alertViewControllerMessage = ""
    let unableToDownloadData = "Unable to download data"
    
    //var usernameAndPasswordDictionary = ["username": "", "password": ""]
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextBox: UITextField!
    
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
    
    override func viewWillAppear(animated: Bool) {
        hideLabels()
    }

    func hideLabels() {
        resultsLabel.hidden = true
        parseResultsLabel.hidden = true
        udacitySignUpCompleteLabel.hidden = true
    }
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonPressed(sender: AnyObject) {

        let username = usernameTextBox.text
        let password = passwordTextField.text
//        usernameAndPasswordDictionary["username"] = username
//        usernameAndPasswordDictionary["password"] = password
        
        loadingAlert()
        
        OTMClient.sharedInstance().authenticateWithViewController(usernameAndPasswordDictionary, viewController: self) {(success, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.resultsLabel.text = "sucess"
                    self.resultsLabel.hidden = false
                    self.dismissViewControllerAnimated(false, completion: nil)
                    })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    if let errorString = errorString {
                        self.presentErrorAlert(errorString)
                    }
                    })
                print("asdfjlkasdfl;adjsf \(errorString)")
            }
        }
        
    }

    func loadingAlert() {
        
        //Code from: http://stackoverflow.com/questions/27960556/loading-an-overlay-when-running-long-tasks-in-ios
        let alert = UIAlertController(title: nil, message: "Logging in, please wait", preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(1, 5, 50, 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true, completion: nil)
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
    
    func presentErrorAlert(errorString: String) {
        
        switch errorString {
        case deviceOffline:
            alertViewControllerTitle = "Internet Connection"
            alertViewControllerMessage = "Your device is not connected to the Internet. Please reconnect to the Internet and try again."
            
        case unableToDownloadData:
            alertViewControllerTitle = "Location Data Error"
            alertViewControllerMessage = "We were unable to download the location data. Please contact support if error persists."
            
        default :
            alertViewControllerTitle = "Login Error"
            alertViewControllerMessage = "Please enter the correct username and password."
        }

        
        
        let alertController = UIAlertController(title: alertViewControllerTitle, message: alertViewControllerMessage, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

