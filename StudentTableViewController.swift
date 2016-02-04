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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studentsInformationArray.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        let student = studentsInformationArray[indexPath.row]
        
        
        //set the name
        cell.textLabel!.text = student.firstName + " " + student.lastName
        cell.detailTextLabel!.text = student.mediaURL
        
        //Compensates for the navigationBar, tab bar and status bar heights for the table.
        tableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight((navigationController?.navigationBar.frame)!) + UIApplication.sharedApplication().statusBarFrame.size.height, 0, CGRectGetHeight(self.tabBarController!.tabBar.frame), 0)
        
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
