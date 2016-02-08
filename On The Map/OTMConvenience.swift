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
        
        let jsonBody: [String:[String:AnyObject]] = ["udacity": usernameAndPasswordDictionary] 
        taskForUdacityPostMethod("", platformURL: Constants.udacityLoginURL, parameters: parameters, jsonBody: jsonBody, addValueURL: AddValueNSMutableURLRequest.udacityAddValueURL) {( JSONResult, error) in
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
    
    func verifyIfRegistered(accountInformation: [String:AnyObject], completionHandler: (success: Bool, accountKey: String?, errorString: String?) -> Void) {
        if let accountRegistered = accountInformation[JSONResponseKeys.accountRegistered] as? Bool {
            if accountRegistered {
                print("OTMConvenience Account Information \(accountInformation)")
                if let accountKey = accountInformation[OTMClient.JSONResponseKeys.accountKey] as? String {
                    completionHandler(success: true, accountKey: accountKey, errorString: nil)
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
            print("SessionID at Login: \(sessionID)")
            completionHandler(success: true, sessionID: sessionID, errorString: nil)
        } else {
            completionHandler(success: false, sessionID: nil, errorString: "(Could not complete login. Unable to find SessionID in \(sessionInfomration)")
        }
        
    }
    
    //MARK: Get public user data from Udacity
    
    func getUserDatafromUdacity(completionHandler: (success:Bool, errorString: String?) -> Void) {
        
        let url = OTMClient.Constants.udacityPublicDataURL
        let userID = OTMClient.sharedInstance().userID
        
        if let userID = userID {
            taskForUdacityGetMethod(userID, platformURL: url) {result, error in
                if error != nil {
                    print("OTMConvenience: Unable to get public user data due to \(error)")
                    completionHandler(success: false, errorString: "Unable to get public user data due to \(error)")
                } else {
                    let userPublicData = result[JSONResponseKeys.user] as? [String:AnyObject]
                    if let userPublicData = userPublicData {
                        self.firstName = userPublicData[JSONResponseKeys.publicDataFirstName] as? String
                        self.lastName = userPublicData[JSONResponseKeys.publicDataLastName] as? String
                        print("FirstName: \(self.firstName!) LastName: \(self.lastName!)")
                        completionHandler(success: true, errorString: nil)
                    } else {
                        completionHandler(success: false, errorString: "Unable to parseJSON")
                    }
                }
            }
        } else {
            print("OTMConvenience: UserID was not set. Unable to get data")
            completionHandler(success: false, errorString: "UserID was not set. Unable to get data")
        }
        

        
    
    }
    
    
    //MARK: Get user data from Parse
    
    func getStudentLocations(completionHandler: (success: Bool, studentArray: [OTMStudent]?, errorString: String?)-> Void) {
            //TO DO 1. Set Parameters for Get Method
        let parameters: [String:AnyObject] = [
            "limit":"100",
            "order":"-updatedAt"
        ]
        taskForParseGetMethod("", platformURL: Constants.parseURL, parameters: parameters, addValueURL: AddValueNSMutableURLRequest.parseAddValueURL) {(JSONResult, error) in
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
        getUserDatafromUdacity() {success, errorString in
            if success {
                self.getStudentLocations() {(success, studentArray, errorString) in
                    if success {
                        self.launchMapView(viewController)
                    } else {
                        print("CompleteLogin getStudentLocations \(errorString)")
                    }
                }
            } else {
                print("CompleteLogin getUserDataFromUdacity \(errorString)")
            }

        }
        
    }
    
    func launchMapView(viewController: ViewController) {
        let studentInformationTabBarController = viewController.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController

        dispatch_async(dispatch_get_main_queue(), {
            viewController.presentViewController(studentInformationTabBarController, animated: true, completion: nil)
        })
        
    }
    
    
    //MARK: Logout
    func logout(completionHandler: (success: Bool, errorString: String?)->Void) {
        OTMClient.sharedInstance().taskForDeleteMethod() {result, error in
            if error != nil {
                completionHandler(success: false, errorString: "Unable to complete logout, \(error)")
            } else {
                print("JSONResult from Logout: \(result)")
                completionHandler(success: true, errorString: nil)
            }
        }
        
    }
    
}