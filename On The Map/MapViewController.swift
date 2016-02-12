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


    @IBOutlet weak var mapView: MKMapView!
    
    var studentsInformation: [OTMStudent]?
    
    
    override func viewWillAppear(animated: Bool) {
        configureNavigationController()
        addStudentsToMap()
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
        OTMClient.sharedInstance().logout() { success, errorString in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
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
        loadingAlert()
        
        OTMClient.sharedInstance().getStudentLocations() {(success, studentArray, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.addStudentsToMap()
                    self.dismissViewControllerAnimated(false, completion: nil)
                })
            } else {
                print("MapViewController: Unable to get students")
                self.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }
    
    func addStudentsToMap() {
        studentsInformation = OTMClient.sharedInstance().studentsArray
        
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
        
        self.mapView.addAnnotations(annotations)
    }
    
    
    func loadingAlert() {
        let alert = UIAlertController(title: nil, message: "Refreshing Data", preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func presentErrorAlert() {
        let alertViewControllerTitle = "Invalid URL"
        let alertViewControllerMessage = "Invalid URL. Please select another user."
        
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
            pinView!.pinTintColor = UIColor.purpleColor()
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
                        presentErrorAlert()
                    }
                }
            }
        }
    }

}
