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
    
    
    //MARK: Authentication (Methods)
    
    func authenticateWithViewController(hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?)-> Void) {
        getAccountInformation() {( success, accountInformation, sessionInformation, errorString) in
            if success {
                self.verifyIfRegistered(accountInformation!) {(success, accountKey, errorString) in
                    if success {
                        self.getSessionID(sessionInformation!) {(success, sessionID, errorString) in
                            if let sessionID = sessionID {
                                self.sessionID = sessionID
                                completionHandler(success: true, errorString: nil)
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
    
    
    func getAccountInformation(completionHandler: (success: Bool, accountInformation: [String:AnyObject]?, sessionInformation: [String:AnyObject]?, errorString: String?) -> Void) {
        let parameters = [String:AnyObject]()
        let jsonBody: [String:[String:AnyObject]] = ["udacity":
            ["username":"longenecker@me.com",
                "password":"Iay$D1kI8TPPj1Gdi"
            ]]
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
            print("Account Information \(accountInformation)")
            if accountRegistered {
                print("Account Registered \(accountRegistered)")
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
    
    
    
}