//
//  userLocationViewController.swift
//  On The Map
//
//  Created by John Longenecker on 2/5/16.
//  Copyright © 2016 John Longenecker. All rights reserved.
//

import UIKit
import CoreLocation

class userLocationViewController: UIViewController {

    @IBOutlet weak var studentLocationTextField: UITextField!
    
    var lattitude:Float = 0.0
    var longitude:Float = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "dismissViewController")
        navigationItem.leftBarButtonItem = cancelButton
        getLocationFromString()
       
    }

    
    func getLocationFromString() {
        let location = "Davenport, IA"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) {(placemarks, error) -> Void in
            if((error) != nil) {
                print("Error", error)
            } else {
                let placemark:CLPlacemark = placemarks![0]
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                self.lattitude = Float(coordinates.latitude)
                self.longitude = Float(coordinates.longitude)
                print("\(self.lattitude)")
                print("Added annotation to map view")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        postData()
    }

    func postData(/*completionHandler: (success:Bool, errorString: String?)->Void*/) {
        let parameters = [String:AnyObject]()
        let userInformation = OTMClient.sharedInstance()
        let userID = userInformation.userID!

        
        let jsonBody: [String:AnyObject] =  [
            "uniqueKey": userID,
            "firstName" : "John",
            "lastName" : "Longenecker",
            "mapString" : "Davenport, IA",
            "mediaURL" : "www.google.com",
            "latitude": lattitude,
            "longitude" : longitude
        ]
        
        
        OTMClient.sharedInstance().taskForPostParseMethod("", platformURL: OTMClient.Constants.parseURL, parameters: parameters, jsonBody: jsonBody, addValueURL: OTMClient.AddValueNSMutableURLRequest.parseAddValueURL) {result, error in
            
            if error == nil {
                print("Result \(result)")
            }
            
        }
        
    }
    
    
    func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
