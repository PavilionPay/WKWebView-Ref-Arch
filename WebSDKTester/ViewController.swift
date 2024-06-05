//
//  ViewController.swift
//  WebSDKTester
//
//  Created by Ben Ion on 3/29/24.
//

import UIKit

/**
 A shell ViewController that can launch specified WebViewControllers in a popup sheet.
 
 This screen exists mostly to provide a clear delineation between views that are native iOS code,
 and views that are being shown in WebViews.
 
 Views shown from this screen are displayed in WebViews that are presented in popup overlay sheets;
 the sheet can be dismissed by sliding down to close the WebView and return to this screen.
 */
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
