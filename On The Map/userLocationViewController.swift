//
//  userLocationViewController.swift
//  On The Map
//
//  Created by John Longenecker on 2/5/16.
//  Copyright © 2016 John Longenecker. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class userLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var studentLocationTextField: UITextField!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    @IBOutlet weak var enterLocationLabel: UILabel!
    @IBOutlet weak var enterAURLToShare: UILabel!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var submitURLButton: UIButton!
    
    @IBOutlet weak var loadingSymbolView: UIView!
    @IBOutlet weak var loadingView: UIView!
    var latitude:Float = 0.0
    var longitude:Float = 0.0
    var stringLocation = ""
    
    let userInformation = OTMClient.sharedInstance().userID!
    let userID = OTMClient.sharedInstance().userID!
    let firstName = OTMClient.sharedInstance().firstName!
    let lastName = OTMClient.sharedInstance().lastName!
    var URL:String?
    
    
    //Cases for Alert View Controller
    let locationFromStringError = "Unable to get location from string."
    let unableToPostStudentLocation = "Unable to post student location."
    let blankURLField = "Blank URL Field"
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        mapView.delegate = self
        // Do any additional setup after loading the view.
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "dismissViewController")
        navigationItem.leftBarButtonItem = cancelButton
        self.tabBarController?.tabBar.hidden = true
    }

    func setupView() {
        mapView.hidden = true
        urlTextField.hidden = true
        enterAURLToShare.hidden = true
        submitURLButton.hidden = true
        loadingView.hidden = true
        loadingSymbolView.hidden = true
    }
    
    func getLocationFromString(completionHanlder: (success:Bool, errorString: String?)->Void ) {
        loadingAlert()
        locationServices().getLocationFromString(stringLocation) { sucess, coordinatesDictionary, errorString in
            if errorString != nil {
                print("userLocationViewController getLocationFromString errorstring \(errorString)")
                completionHanlder(success: false, errorString: "Unable to get location from string.")
                self.loadingSymbolView.hidden = true
                self.loadingView.hidden = true
            } else {
                self.loadingSymbolView.hidden = true
                self.loadingView.hidden = true
                self.latitude = coordinatesDictionary!["latitude"]! as Float
                self.longitude = coordinatesDictionary!["longitude"]! as Float
                print("Latitude \(self.latitude) Longitude \(self.longitude)")
                completionHanlder(success: true, errorString: nil)
                self.addStudentToMap()
                self.secondUI()
            }
        }
    }
    
    
    
    func secondUI() {
        mapView.hidden = false
        urlTextField.hidden = false
        enterAURLToShare.hidden = false
        submitURLButton.hidden = false
        studentLocationTextField.hidden = true
        submitButtonOutlet.hidden = true
        enterLocationLabel.hidden = true
    }
    
    func addStudentToMap() {
        let lat = CLLocationDegrees(latitude)
        let lon = CLLocationDegrees(longitude)
        let cooridnates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let annotation = MKPointAnnotation()
        annotation.coordinate = cooridnates
        
        let lanDelta = 0.075
        let longDelta = 0.075
        let span = MKCoordinateSpanMake(lanDelta, longDelta)
        let region = MKCoordinateRegion(center: cooridnates, span: span)
        self.mapView.addAnnotation(annotation)
        self.mapView.setRegion(region, animated: true)
    }

    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        
        stringLocation = studentLocationTextField.text!
        
        getLocationFromString() {success, errorString in
            if success == false {
                self.presentErrorAlert(errorString!)
            }
        }

    }
    
    
    @IBAction func submitURLButtonPressed(sender: AnyObject) {
        URL = urlTextField?.text
        
        if URL == "" {
            self.presentErrorAlert(self.blankURLField)
        } else {
            if let _ = URL {
                postData()
            } else {
                print("Please enter in a URL")
            }
        }

        
        
    }

    func postData() {
        let parameters = [String:AnyObject]()
        
        
        let jsonBody: [String:AnyObject] =  [
            "uniqueKey": userID,
            "firstName" : firstName,
            "lastName" : lastName,
            "mapString" : stringLocation,
            "mediaURL" : URL!,
            "latitude": latitude,
            "longitude" : longitude
        ]
        
        
        OTMClient.sharedInstance().taskForPostParseMethod("", platformURL: OTMClient.Constants.parseURL, parameters: parameters, jsonBody: jsonBody, addValueURL: OTMClient.AddValueNSMutableURLRequest.parseAddValueURL) {success, result, error in
            if success {

                if error == nil {
                    print("Result2 \(result)")
                    self.reloadData()
                }
            } else {
                print("Unable to Post Data")
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentErrorAlert(self.unableToPostStudentLocation)
                })
            }
        }
        
    }
    
    
    func reloadData() {
        OTMClient.sharedInstance().getStudentLocations() {(success, studentArray, errorString) in
            if success {
                OTMClient.sharedInstance().studentsArray = studentArray!
                dispatch_async(dispatch_get_main_queue(), {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                })
            } else {
                print("userLocationViewController: Unable to update students")
            }
        }
    }
    
    
    
    func dismissViewController() {
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    func loadingAlert() {
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: loadingSymbolView.frame)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        loadingIndicator.startAnimating()
        loadingSymbolView.addSubview(loadingIndicator)
        loadingSymbolView.hidden = false
        loadingView.hidden = false
    }
    
    //MARK: -Configure AlertViewController
    
    //Varibales for AlertViewController
    var alertViewControllerTitle = ""
    var alertViewControllerMessage = ""
    
    func presentErrorAlert(errorString: String) {
        
        switch errorString {
        case locationFromStringError:
            alertViewControllerTitle = "Location Error"
            alertViewControllerMessage = "Unable to find location. Please enter a geographic location."
        case unableToPostStudentLocation:
            alertViewControllerTitle = "Posting Error"
            alertViewControllerMessage = "Unable to post your location submission. Please try again later"
        case blankURLField:
            alertViewControllerTitle = "Blank URL"
            alertViewControllerMessage = "Please enter a URL before submitting your post."
        default:
            alertViewControllerTitle = "Error"
            alertViewControllerMessage = "An unknown error has occurred. Please try again. If the problem persists please contact support."
        }
        
        let alertController = UIAlertController(title: alertViewControllerTitle, message: alertViewControllerMessage, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: -MKMapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.orangeColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        
        return pinView
    }
    
}


