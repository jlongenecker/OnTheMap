//
//  ViewController.swift
//  On The Map
//
//  Created by John Longenecker on 1/28/16.
//  Copyright © 2016 John Longenecker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var transparencyLoadingView: UIView!
    @IBOutlet weak var alertMessageView: UIView!
    @IBOutlet weak var alertLabel: UILabel!
    
    
    
    let deviceOffline = "The Internet connection appears to be offline."
    var alertViewControllerTitle = ""
    var alertViewControllerMessage = ""
    let unableToDownloadData = "Unable to download data"
    
    var usernameAndPasswordDictionary = ["username": "", "password": ""]
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextBox: UITextField!
    
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var signUpForUdacityOutlet: UIButton!
    
    @IBOutlet weak var udacitySignUpCompleteLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        hideLabels()
        udacitySignUpCompleteLabel.hidden = true
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    //AlertViewController Possible Alerts
    let blankUsernameOrPassword = "Blank Username Or Password"
    
    
    override func viewDidDisappear(animated: Bool) {
        hideLabels()
        signUpForUdacityOutlet.hidden = false
        passwordTextField.text = ""
        usernameTextBox.text = ""
    }

    func hideLabels() {
        transparencyLoadingView.hidden = true
        resultsLabel.hidden = true
        udacitySignUpCompleteLabel.hidden = true
    }
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        dismissKeyboard()
        let username = usernameTextBox.text
        let password = passwordTextField.text
        if password == "" || username == "" {
            presentErrorAlert(blankUsernameOrPassword)
        } else {
            usernameAndPasswordDictionary["username"] = username
            usernameAndPasswordDictionary["password"] = password
            loadingAlertTwo()
            
            OTMClient.sharedInstance().authenticateWithViewController(usernameAndPasswordDictionary, viewController: self) {(success, errorString) in
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.udacitySignUpCompleteLabel.hidden = true
                        self.resultsLabel.hidden = false
                        self.transparencyLoadingView.hidden = true
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        if let errorString = errorString {
                            self.presentErrorAlert(errorString)
                            self.transparencyLoadingView.hidden = true
                        }
                    })
                }
            }
        }
    }

    func loadingAlertTwo() {
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: alertMessageView.frame)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        loadingIndicator.startAnimating()
        alertMessageView.addSubview(loadingIndicator)
        alertMessageView.hidden = false
        transparencyLoadingView.hidden = false
    }
 
    @IBAction func signUpForUdacityButtonPressed(sender: AnyObject) {
        OTMClient.sharedInstance().signUpForUdacity(self) {(success, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.signUpForUdacityOutlet.hidden = true
                    self.udacitySignUpCompleteLabel.hidden = false
                    self.udacitySignUpCompleteLabel.text = "Please use your new \nUdacity account to sign in."
                    
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
        
        case blankUsernameOrPassword:
            alertViewControllerTitle = "Login Error"
            alertViewControllerMessage = "The username or password field was left blank."
            
            
        default :
            alertViewControllerTitle = "Login Error"
            alertViewControllerMessage = "Please enter the correct username and password."
        }

        
        let alertController = UIAlertController(title: alertViewControllerTitle, message: alertViewControllerMessage, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

