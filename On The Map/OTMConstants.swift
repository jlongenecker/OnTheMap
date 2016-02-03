//
//  File.swift
//  On The Map
//
//  Created by John Longenecker on 1/29/16.
//  Copyright © 2016 John Longenecker. All rights reserved.
//

import Foundation

//MARK: - OTMClient (Constants)

extension OTMClient {
    struct Constants {
        //MARK: URLs
        static let udacityURL = "https://www.udacity.com/api/session"
        static let parseURL = "https://api.parse.com/1/classes/StudentLocation"
    }
    
    struct Methods {
        
        //Mark: Account
        static let udacityPublicUserData = "users/<user id>"
        
    }
    
    struct URLKeys {
        static let UserID = "id"
    }
    
    struct ParameterKeys {
        static let parseLimit = "limit"
        static let parseSkip = "skip"
        static let parseOrder = "order"
        static let userID = "userID"
    }
    
    struct JSONBodyKeys {
        static let parseUniqueKey = "uniqueKey"
        static let parseFirstName = "firstName"
        static let parseLastname = "lastName"
        static let parseMapString = "mapString"
        static let parseMediaURL = "mediaURL"
        static let parseLatitude = "latitude"
        static let parseLongitude = "longitude"
        static let udacityUserName = "username"
        static let udacityPassword = "password"
    }
    
    struct AddValueNSMutableURLRequest {
        static let parseAddValueURL = [
            "ApplicationIDOne":"QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", //Parse Application ID
            "ApplicationIDTwo":"QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", //REST API Key
            "forHTTPHeaderFieldApplicationOne":"X-Parse-Application-Id",
            "forHTTPHeaderFieldApplicationTwo":"X-Parse-REST-API-Key"
        ]
        
        static let udacityAddValueURL = [
            "ApplicationIDOne":"application/json", //Udacity ID
            "ApplicationIDTwo":"application/json", //Udacity ID
            "forHTTPHeaderFieldApplicationOne":"Accept",
            "forHTTPHeaderFieldApplicationTwo":"Content-Type"
        ]
    }
    
    struct JSONResponseKeys {
        //MARK: General
        static let statusMessage = "status_message"
        static let statusCode = "status_code"
        
        
        //MARK: Authorization
        static let accountRegistered = "registered"
        
        //MARK: Account
        static let account = "account"
        static let accountKey = "key"
        static let session = "session"
        static let sessionID = "id"
        
        //Will need more keys as I dig into the JSON and what we need
        //MARK: Parse Result Keys
        static let createdAt = "createdAt"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let updatedAt = "updatedAt"
        
    }
    
    
}
