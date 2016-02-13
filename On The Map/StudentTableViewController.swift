//
//  StudentTableViewController.swift
//  On The Map
//
//  Created by John Longenecker on 2/4/16.
//  Copyright © 2016 John Longenecker. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
    
    
    var studentsInformationArray = OTMStudent.studentsArray
    let reuseIdentifier = "studentInformationCell"
    
    //Returnable Errors
    let unableToGetStudents = "Unable to get students"
    let invalidURL = "Invalid URL"
    
    override func viewWillAppear(animated: Bool) {
        configureNavigationController()
        refreshTable()

    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsInformationArray.count
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
    
    func reloadData() {
        loadingAlert("Refreshing Data")
        OTMClient.sharedInstance().getStudentLocations() {(success, studentArray, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.studentsInformationArray = OTMStudent.studentsArray
                    self.refreshTable()
                    self.dismissViewControllerAnimated(false, completion: nil)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(),{
                    self.dismissViewControllerAnimated(false, completion: nil)
                    self.presentErrorAlert(self.unableToGetStudents)
                    print("Unable to get new data. StudentTableViewController")
                })

            }
        }
    }
    
    func studentLocation() {
        addStudentLocation(self)
    }
    
    func addStudentLocation(viewController: UIViewController) {
        let locationViewController = viewController.storyboard?.instantiateViewControllerWithIdentifier("userLocationViewController") as! userLocationViewController
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationController?.pushViewController(locationViewController, animated: true)
            
        })
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

    func refreshTable() {
        studentsInformationArray = OTMStudent.studentsArray
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        let student = studentsInformationArray[indexPath.row]
        
        //set the name
        cell.textLabel!.text = student.firstName + " " + student.lastName
        cell.detailTextLabel!.text = student.mediaURL
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let student = studentsInformationArray[indexPath.row]
        let studentURL = NSURL(string: student.mediaURL)
        if let studentURL = studentURL {
            let result = UIApplication.sharedApplication().openURL(studentURL)
            if result == false {
                presentErrorAlert(invalidURL)
            }
        }
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
    

}
