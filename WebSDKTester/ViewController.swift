//
//  ViewController.swift
//  WebSDKTester
//
//  Created by Ben Ion on 3/29/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func launchWebViewExistingUser() {
        launchWebView(with: "sessionCreationExistingUser")
    }
    
    @IBAction func launchWebViewNewUser() {
        launchWebView(with: "sessionCreationNewUser")
    }
    
    @IBAction func vipOnlineExistingUser() {
        launchWebView(with: "vipOnlineExistingUser")
    }
    
    @IBAction func vipOnlineNewUser() {
        launchWebView(with: "vipOnlineNewUser")
    }
    
    
    
    private func launchWebView(with pageName: String) {
        let viewControllerToPresent = WebViewController()
        viewControllerToPresent.pageToLaunch = pageName
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(viewControllerToPresent, animated: true, completion: nil)
    }
}
