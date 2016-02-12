//
//  OTMSignUpViewController.swift
//  On The Map
//
//  Created by John Longenecker on 2/2/16.
//  Copyright © 2016 John Longenecker. All rights reserved.
//

import UIKit
import WebKit

class OTMSignUpViewController: UIViewController {
    
    //MARK: Properties

    
    let request = NSURLRequest(URL: NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    // may need to add a completionHandler
    var completionHandler:((success: Bool, errorString: String?)->Void)? = nil
    
    let webView = WKWebView()
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        self.view = webView

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
extension OTMSignUpViewController: WKNavigationDelegate {
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        let currentURL = webView.URL?.absoluteString
        if let currentURL = currentURL {
            if currentURL == "https://www.udacity.com/me#!/" {
                completionHandler!(success: true, errorString: nil)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }

        print("\(webView.URL?.absoluteString)")
    }
    
}
