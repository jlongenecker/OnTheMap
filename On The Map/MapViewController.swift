//
//  MapViewController.swift
//  On The Map
//
//  Created by John Longenecker on 2/3/16.
//  Copyright © 2016 John Longenecker. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    @IBOutlet weak var loginSuccessLabel: UILabel!
    
    var studentsInformation: [OTMStudent]?
    
    override func viewDidLoad() {
        studentsInformation = OTMClient.sharedInstance().studentsArray
        
        if studentsInformation != nil {
            loginSuccessLabel.text = "Woot Woot It worked!"
        }
    }

}
