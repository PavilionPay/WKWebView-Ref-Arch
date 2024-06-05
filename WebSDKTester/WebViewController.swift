//
//  WebViewController.swift
//  WebSDKTester
//
//  Created by Ben Ion on 3/29/24.
//

import UIKit
import WebKit

/**
 A view controller that contains a simple WKWebView to host the VIP Connect SDK.
 
 The VIP SDK is agnostic to most of this code, and webview creation can be done however
 the consumer wishes to implement it in their own app.
 
 The only requirement is that the WKWebView must be assigned a WKUIDelegate that can
 handle requests to open new WebViews. For convenience, this example app uses this
 ViewController as the delegate.
 */
class WebViewController: UIViewController {
    
    var heldWebView: WKWebView? = nil
    var pageToLaunch: String? = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        let wkPrefs = WKPreferences()
        wkPrefs.javaScriptCanOpenWindowsAutomatically = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        config.preferences = wkPrefs
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.bounces = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        // Must set a UI Delegate for the webview to handle opening windows for banks like Chase
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            webView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            webView.widthAnchor.constraint(equalTo: view.widthAnchor),
            webView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
        
        heldWebView = webView
        if pageToLaunch != nil {
            webView.load(URLRequest(url: Bundle.main.url(forResource: pageToLaunch!, withExtension: "html")!))
        }
        
#if DEBUG
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
#endif
        
    }
}

extension WebViewController: WKUIDelegate {
    /**
     Delegte method that must be handled to open OAuth UIs like Chase Bank's that happen outside the app.
     See https://plaid.com/docs/link/oauth/#webview
     */
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        print("Attempting to open new window for \(navigationAction.request.url!)")
        guard let url = navigationAction.request.url else {
            return nil
        }
        
        // Open the external URL in Safari
        UIApplication.shared.open(url)
        return nil
    }
}

/// Implemented for debugging purposes
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        print(hash, navigationAction.request.url?.absoluteString ?? "nil")
        return .allow
    }
}
