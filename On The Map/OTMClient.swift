//
//  OTMClient.swift
//  On The Map
//
//  Created by John Longenecker on 1/29/16.
//  Copyright © 2016 John Longenecker. All rights reserved.
//

import Foundation

//MARK: - OTMClient: NSOBJECT

class OTMClient: NSObject {
    //MARK: Properties
    
    /* Shared Session */
    var session: NSURLSession
    
    /* Authentication state */
    var sessionID: String? = nil
    var userID : Int? = nil
    
    //MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    
    func taskForPostMethod(method: String, platformURL: String, parameters: [String: AnyObject], jsonBody: [String:AnyObject], addValueURL: [String:AnyObject], completeHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        /* 1. Set the parameters */
        var mutableParameters = parameters
        
        let urlString = platformURL + method + escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue(addValueURL["ApplicationIDOne"] as! String, forHTTPHeaderField: addValueURL["forHTTPHeaderFieldApplicationOne"] as! String)
        request.addValue(addValueURL["ApplicationIDTwo"] as! String, forHTTPHeaderField: addValueURL["forHTTPHeaderFieldApplicationOne"] as! String)
        
        
        
    }
    
    
    
    
    
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
}