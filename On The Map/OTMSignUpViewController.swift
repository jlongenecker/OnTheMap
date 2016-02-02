//
//  OTMSignUpViewController.swift
//  On The Map
//
//  Created by John Longenecker on 2/2/16.
//  Copyright © 2016 John Longenecker. All rights reserved.
//

import UIKit

class OTMSignUpViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var webView: UIWebView!
    
    let request = NSURLRequest(URL: NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    // may need to add a completionHandler
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self

        self.navigationItem.title = "Sign Up for Udacity"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelAuth")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.webView.loadRequest(request)
    }
    
    func cancelAuth() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}

//MARK: OTMSignUpViewController: UIWebDelegate
extension OTMSignUpViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print("\(webView.request?.URL!.absoluteString)")
    }
    
    //Need the Udacity Website to work on finishing up sign up verification
}
