//
//  StudentTableViewController.swift
//  On The Map
//
//  Created by John Longenecker on 2/4/16.
//  Copyright © 2016 John Longenecker. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
    
    var studentsInformationArray = OTMClient.sharedInstance().studentsArray
    
    let reuseIdentifier = "studentInformationCell"
    
    override func viewWillAppear(animated: Bool) {
        configureNavigationController()
        reloadData()
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
        OTMClient.sharedInstance().getStudentLocations() {(success, studentArray, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.studentsInformationArray = OTMClient.sharedInstance().studentsArray
                    self.testRefresh()
                })
            } else {
                print("Unable to get new data. StudentTableViewController")
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

    func testRefresh() {
        self.tableView.reloadData()
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
        
        //Sends the user to the information provided by the student in the JSON results.
        //Need to add an alert if URL provided does not work. 
        
        let student = studentsInformationArray[indexPath.row]
        
        let studentURL = NSURL(string: student.mediaURL)
        if let studentURL = studentURL {
                    UIApplication.sharedApplication().openURL(studentURL)
        }
    }


}
