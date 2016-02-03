//
//  studentLocations.swift
//  On The Map
//
//  Created by John Longenecker on 2/3/16.
//  Copyright © 2016 John Longenecker. All rights reserved.
//

//MARK: - OTMStudents

struct OTMStudent {
    
    //MARK: Properties
    var createdAt = ""
    var firstName = ""
    var lastName = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var mapString = ""
    var mediaURL = ""
    var objectId = ""
    var uniqueKey = ""
    var updatedAt = ""
    
    //MARK: Initializers
    init(dictionary: [String:AnyObject]) {
        createdAt = dictionary[OTMClient.JSONResponseKeys.createdAt] as! String
        firstName = dictionary[OTMClient.JSONResponseKeys.firstName] as! String
        lastName = dictionary[OTMClient.JSONResponseKeys.lastName] as! String
        latitude = (dictionary[OTMClient.JSONResponseKeys.latitude] as! Double)
        longitude = (dictionary[OTMClient.JSONResponseKeys.longitude] as! Double)
        mapString = dictionary[OTMClient.JSONResponseKeys.mapString] as! String
        mediaURL = dictionary[OTMClient.JSONResponseKeys.mediaURL] as! String
        objectId = dictionary[OTMClient.JSONResponseKeys.objectId] as! String
        uniqueKey = dictionary[OTMClient.JSONResponseKeys.uniqueKey] as! String
        updatedAt = dictionary[OTMClient.JSONResponseKeys.updatedAt] as! String
        //checkStudents()
    }
    
    func checkStudents() {
        print("Created At: \(createdAt)")
        print("First Name At: \(firstName)")
        print("Last Name at: \(lastName)")
        print("Latitude at \(latitude)")
        print("Longitude at \(longitude)")
        print("MapString at \(mapString)")
        print("MediaURl at \(mediaURL)")
        print("objectID at \(objectId)")
        print("uniqueKey at \(uniqueKey)")
        print("updateAt at \(updatedAt)")
        print("")
    }
    
    static func studentsFromResults(results: [[String: AnyObject]]) -> [OTMStudent] {
        var studentsArray = [OTMStudent]()
        
        for student in results {
            studentsArray.append(OTMStudent(dictionary: student))
        }
        
        
        return studentsArray
        
    }
    
}
