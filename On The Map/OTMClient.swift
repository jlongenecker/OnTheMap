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
        let mutableParameters = parameters
        
        let urlString = platformURL + method + OTMClient.escapedParameters(mutableParameters)
        print("URLString: \(urlString)")
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue(addValueURL["ApplicationIDOne"] as! String, forHTTPHeaderField: addValueURL["forHTTPHeaderFieldApplicationOne"] as! String)
        request.addValue(addValueURL["ApplicationIDTwo"] as! String, forHTTPHeaderField: addValueURL["forHTTPHeaderFieldApplicationTwo"] as! String)
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
//        print("Request: \(request) AddValueOne: \(addValueURL["ApplicationIDOne"] as! String), \(addValueURL["forHTTPHeaderFieldApplicationOne"] as! String)")
//        print("Request: \(request) AddValueTwo: \(addValueURL["ApplicationIDTwo"] as! String), \(addValueURL["forHTTPHeaderFieldApplicationOne"] as! String)")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            /*GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
           /*Parse the data and use the data (happens in completion handler) */
            OTMClient.pasreJSONCompletionHandler(data, completionHandler: completeHandler)
            
            
        }
        task.resume()

        
        return task
    }
    
    
    
    
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
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
    
    /* Helper Function: Given a raw JSON, resturn a usable Foundation Object */
    class func pasreJSONCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?)->Void) {
    
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data.subdataWithRange(NSMakeRange(5, data.length-5)), options: NSJSONReadingOptions.AllowFragments) as? [String:AnyObject]
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            print("\(userInfo)")
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
            
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
}