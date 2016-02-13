//
//  MapViewController.swift
//  On The Map
//
//  Created by John Longenecker on 2/3/16.
//  Copyright © 2016 John Longenecker. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var transparencyLoadingView: UIView!
    @IBOutlet weak var alertMessageView: UIView!
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var studentsInformation: [OTMStudent]?
    
    //Returnable Errors
    let unableToGetStudents = "Unable to get students"
    let invalidURL = "Invalid URL"
    
    
    override func viewWillAppear(animated: Bool) {
        configureNavigationController()
        addStudentsToMap()
        transparencyLoadingView.hidden = true
        alertMessageView.hidden = true
  
    }
    
    func configureNavigationController() {
        var navigationButtons = [UIBarButtonItem]()
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: Selector("reloadData"))
        let postLocationButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "studentLocation")
        navigationItem.title = "On The Map"
        navigationButtons.append(refreshButton)
        navigationButtons.append(postLocationButton)
        self.navigationItem.rightBarButtonItems = navigationButtons
        self.tabBarController?.tabBar.hidden = false
    }
    
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        loadingAlert("Logging Out")
        
        OTMClient.sharedInstance().logout() { success, errorString in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                print(errorString)
            }
            
        }
     }
    
    func studentLocation() {
        addStudentLocation(self)
    }
    
    func addStudentLocation(viewController: UIViewController) {
        let locationViewController = viewController.storyboard!.instantiateViewControllerWithIdentifier("userLocationViewController") as! userLocationViewController

        dispatch_async(dispatch_get_main_queue(), {
                  self.navigationController?.pushViewController(locationViewController, animated: true)

        })

    }

    
    func reloadData() {
        loadingAlertTwo()
        
        OTMClient.sharedInstance().getStudentLocations() {(success, studentArray, errorString) in
            if success {
                self.studentsInformation = OTMStudent.studentsArray
                dispatch_async(dispatch_get_main_queue(), {
                    self.addStudentsToMap()
                    self.transparencyLoadingView.hidden = true
                    self.alertMessageView.hidden = true
                })
            } else {
                print("MapViewController: Unable to get students")
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentErrorAlert(self.unableToGetStudents)
                    self.transparencyLoadingView.hidden = true
                    self.alertMessageView.hidden = true
                })
            }
        }
    }
    
    func addStudentsToMap() {

        studentsInformation = OTMStudent.studentsArray
        
        var annotations = [MKPointAnnotation]()
        
        for studentLocation in studentsInformation! {
            let lat = CLLocationDegrees(studentLocation.latitude)
            let lon = CLLocationDegrees(studentLocation.longitude)
            
            let cooridnates = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            let first = studentLocation.firstName
            let last = studentLocation.lastName
            let mediaURL = studentLocation.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = cooridnates
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
    }
    
    
    func loadingAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func loadingAlertTwo() {
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: alertMessageView.frame)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        loadingIndicator.startAnimating()
        alertMessageView.addSubview(loadingIndicator)
        alertMessageView.hidden = false
        transparencyLoadingView.hidden = false
    }
    
    func presentErrorAlert(errorString: String) {
        var alertViewControllerTitle = ""
        var alertViewControllerMessage = ""
        
        switch errorString {
        case unableToGetStudents:
             alertViewControllerTitle = "Error"
             alertViewControllerMessage = "Unable to get student locations, please check your internet connection and try again."
        case invalidURL:
             alertViewControllerTitle = "Invalid URL"
             alertViewControllerMessage = "Invalid URL. Please select another user."
        default:
            alertViewControllerTitle = "Unknown Error"
            alertViewControllerMessage = "An unknown error has occurred. Please contact support if the error persists."
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
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                if let url = NSURL(string: toOpen) {
                    if app.openURL(url) == false {
                        presentErrorAlert(invalidURL)
                    }
                }
            }
        }
    }

}
