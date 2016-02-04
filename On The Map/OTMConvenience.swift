//
//  OTMConvenience.swift
//  On The Map
//
//  Created by John Longenecker on 2/1/16.
//  Copyright © 2016 John Longenecker. All rights reserved.
//
import UIKit
import Foundation

//MARK: - OTPClient (Convenient Resource Methods)

extension OTMClient {
    
    
    //MARK: Authentication Udacity (Methods)
    
    func authenticateWithViewController(usernameAndPasswordDictionary: [String:String], viewController: ViewController, completionHandler: (success: Bool, errorString: String?)-> Void) {
        getAccountInformation(usernameAndPasswordDictionary) {( success, accountInformation, sessionInformation, errorString) in
            if success {
                
                self.verifyIfRegistered(accountInformation!) {(success, accountKey, errorString) in
                    if success {
                        self.userID = accountKey
                        self.getSessionID(sessionInformation!) {(success, sessionID, errorString) in
                            if let sessionID = sessionID {
                                self.sessionID = sessionID
                                completionHandler(success: true, errorString: nil)
                                self.completeLogin(viewController)
                            } else {
                                completionHandler(success: success, errorString: errorString)
                            }
                         }
                    } else {
                        completionHandler(success: success, errorString: errorString)
                    }
                }
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
    }
    
    
    func getAccountInformation(usernameAndPasswordDictionary: [String:String], completionHandler: (success: Bool, accountInformation: [String:AnyObject]?, sessionInformation: [String:AnyObject]?, errorString: String?) -> Void) {
        let parameters = [String:AnyObject]()
        
        let jsonBody: [String:[String:AnyObject]] = ["udacity": usernameAndPasswordDictionary
            ]
        taskForPostMethod("", platformURL: Constants.udacityURL, parameters: parameters, jsonBody: jsonBody, addValueURL: AddValueNSMutableURLRequest.udacityAddValueURL) {( JSONResult, error) in
            if let error = error {
                print(error)
                completionHandler(success: false, accountInformation: nil, sessionInformation: nil, errorString: "Login Failed AccountInformation")
            } else {
                if let accountInformation = JSONResult[OTMClient.JSONResponseKeys.account] as? [String:AnyObject], sessionInformation = JSONResult[OTMClient.JSONResponseKeys.session] as? [String:AnyObject]{
                    completionHandler(success: true, accountInformation: accountInformation, sessionInformation: sessionInformation, errorString: nil)
                } else {
                    print("Could not find \(OTMClient.JSONResponseKeys.account) in \(JSONResult)")
                    completionHandler(success: false, accountInformation: nil, sessionInformation: nil, errorString: "Login Failed Account Information")
                }
            }
        
        }
    }
    
    func verifyIfRegistered(accountInformation: [String:AnyObject], completionHandler: (success: Bool, accountKey: Int?, errorString: String?) -> Void) {
        if let accountRegistered = accountInformation[JSONResponseKeys.accountRegistered] as? Bool {
            if accountRegistered {
                print("OTMConvenience Account Information \(accountInformation)")
                if let accountKey = accountInformation["key"] as? String {
                    completionHandler(success: true, accountKey: Int(accountKey), errorString: nil)
                } else {
                    completionHandler(success: false, accountKey: nil, errorString: "Login failed. Unable to find account key in \(accountInformation)")
                }
            } else {
                completionHandler(success: false, accountKey: nil, errorString: "Login failed. Unable to find account registration in \(accountInformation)")
            }
        }
        
    }

    func getSessionID(sessionInfomration: [String:AnyObject], completionHandler: (success: Bool, sessionID: String?, errorString: String?)-> Void) {
        if let sessionID = sessionInfomration[JSONResponseKeys.sessionID] as? String {
            completionHandler(success: true, sessionID: sessionID, errorString: nil)
        } else {
            completionHandler(success: false, sessionID: nil, errorString: "(Could not complete login. Unable to find SessionID in \(sessionInfomration)")
        }
        
    }
    
    //MARK: Get user data from Parse
    
    func getStudentLocations(completionHandler: (success: Bool, studentArray: [OTMStudent]?, errorString: String?)-> Void) {
            //TO DO 1. Set Parameters for Get Method
        let parameters: [String:AnyObject] = [
            "limit":"100",
            "order":"-updatedAt"
        ]
        taskForGetMethod("", platformURL: Constants.parseURL, parameters: parameters, addValueURL: AddValueNSMutableURLRequest.parseAddValueURL) {(JSONResult, error) in
            if let error = error {
                completionHandler(success: false, studentArray: nil, errorString: "Get Student Locations from Parse Failed \(error)")
            } else {
                //print("JSONResult \(JSONResult)")
                let parseArray = JSONResult["results"] as? [[String:AnyObject]]
                
                if let parseArray = parseArray {
                    self.studentsArray = OTMStudent.studentsFromResults(parseArray)
                    completionHandler(success: true, studentArray: self.studentsArray, errorString: nil)
                }
            }
            
        }
    }
    


    //MARK: Sign Up For Udacity
    func signUpForUdacity(viewController: ViewController, completionHanlder: (success: Bool, errorString: String?)->Void) {
        let signUpForUdacityViewController = viewController.storyboard!.instantiateViewControllerWithIdentifier("OTMSignUpViewController") as! OTMSignUpViewController
        signUpForUdacityViewController.completionHandler = completionHanlder
        
        let signUpUdacityNavigationController = UINavigationController()
        signUpUdacityNavigationController.pushViewController(signUpForUdacityViewController, animated: false)
        
        dispatch_async(dispatch_get_main_queue(), {
            viewController.presentViewController(signUpUdacityNavigationController, animated: true, completion: nil)
        })
    }
    
    
    
    //MARK: Complete Login
    func completeLogin(viewController: ViewController) {
        getStudentLocations() {(success, studentArray, errorString) in
            if success {
                self.launchMapView(viewController)
            }
        }
    }
    
    func launchMapView(viewController: ViewController) {
        let studentInformationTabBarController = viewController.storyboard!.instantiateViewControllerWithIdentifier("studentNavigationViewController") as! UINavigationController
        dispatch_async(dispatch_get_main_queue(), {
            viewController.presentViewController(studentInformationTabBarController, animated: true, completion: nil)
        })
        
    }
    
}