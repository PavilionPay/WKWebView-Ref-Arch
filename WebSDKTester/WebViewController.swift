//
//  WebViewController.swift
//  WebSDKTester
//
//  Created by Ben Ion on 3/29/24.
//

import UIKit
import WebKit

/**
 A view controller that demonstrates completing the OAuth flow within the same browser, and redirecting to
 a page that can restore the VIP and Plaid sessions.
 
 The VIP SDK uses Plaid for some operations, like connecting new bank accounts to the user's VIP account. Plaid in turn may use
 OAuth to gain credentials it can use to perform the bank Linking operation. Since all these actions take place in webviws,
 additional steps are needed to ensure the user is returned to their VIP flow after completing a bank's OAuth flow.
 
 The VIP SDK achieves this by redirecting to a specific page that can relaunch and restore the user's previous VIP and Plaid sessions.
 This redirect page is able to store and retrieve information needed to identify the user's session, and will restore the VIP flow
 to the state where the user last left it, if possible.
 
 There is no additional app code needed for this option for most banks; the redirect page handles all of the session restoration and
 navigation by itself. For this option, the redirect url cannot be chosen by the operator, and must use a url that is able to perform
 all the necessary redirects.
 
 Also note that there may still be app code needed to handle certain banks, like Chase; see the link on the function below for more info.
 
 While there is additional JavaScript messaging code in this class, it is used only for original session creation and is not necessary
 to implement in apps that use the VIP SDK.
 */
class WebViewController: UIViewController {
    
    var heldWebView: WKWebView? = nil
    var pageToLaunch: String? = nil
    
    /*
     Creates a simple Webview and displays it as the primary view in this view controller.
     The VIP SDK is agnostic to most of this code, and webview creation can be done however
     the consumer wishes to implement it in their own app.
     */
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
     Delegte method that must be handled to open Chase OAuth UIs.
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
