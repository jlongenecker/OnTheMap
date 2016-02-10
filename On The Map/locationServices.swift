//
//  locationServices.swift
//  On The Map
//
//  Created by John Longenecker on 2/8/16.
//  Copyright © 2016 John Longenecker. All rights reserved.
//

import Foundation
import CoreLocation

class locationServices {
    
    
    func getLocationFromString(location: String, completionHandler: (success:Bool, coordinatesDictionary: [String:Float]?, errorString: String?)->Void) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) {(placemarks, error) -> Void in
            if((error) != nil) {
                print("Error", error)
                completionHandler(success: false, coordinatesDictionary: nil, errorString: "\(error)")
            } else {
                let placemark:CLPlacemark = placemarks![0]
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                let latitutde = Float(coordinates.latitude)
                let longitude = Float(coordinates.longitude)
                
                let coordinatesDictionary = [
                    "latitude": latitutde,
                    "longitude": longitude
                ]
                completionHandler(success: true, coordinatesDictionary: coordinatesDictionary, errorString: nil)
            }
        }
    }
}