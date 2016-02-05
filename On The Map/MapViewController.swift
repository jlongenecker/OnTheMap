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

    @IBOutlet weak var refreshButton: UIBarButtonItem!

    @IBOutlet weak var mapView: MKMapView!
    
    var studentsInformation: [OTMStudent]?
    
    override func viewDidLoad() {
        addStudentsToMap()
        //getLocationFromString()
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
    

//    func getLocationFromString() {
//        let location = "1 Infinity Loop, Cupertino, CA"
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(location) {(placemarks, error) -> Void in
//            if((error) != nil) {
//                print("Error", error)
//            } else {
//                let placemark:CLPlacemark = placemarks![0]
//                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
//                
//                let lattitude = coordinates.latitude
//                print("\(lattitude)")
//                print("Added annotation to map view")
//            }
//        }
//    }
    
    @IBAction func reloadData(sender: AnyObject) {
        OTMClient.sharedInstance().getStudentLocations() {(success, studentArray, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.addStudentsToMap()
                })
            } else {
                print("MapViewController: Unable to get students")
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
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    


}
