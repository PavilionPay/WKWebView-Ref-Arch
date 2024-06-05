#  VIP Connect Plaid Integration Test App

This app is a scaffold to quickly and simply test various configurations for Plaid OAuth account linking in the VIP Connect SDK in a native app.
The app can quickly create and launch sessions in test environments to aid in development and debugging; to create sessions, you will need
a valid operator token that can be provided on request and placed in the html files.

### Steps to get your app working:
 - [x] Add native code to handle OAuth flows that happen outside the app
 - [x] Register your app with Pavilion to be added to our AASA for Universal Links
 - [x] Declare the specified Universal Links Capability within your app
 
## App Structure

The WebSDKTester app launches with a simple native View containing some buttons to launch the VIP Connect web SDK in various flavors.
When the button is clicked, a WKWebView is created and popped up over the screen. The VIP Connect SDK is agnostic
to how its containing WKWebView is presented, but for purposes of this app is is displayed in a dismissable sheet so it
is easy to restart the flow again, and also to clearly see which views are native code and which are web views.

The first screen after launching the web view is a dummy operator screen whose purpose is to create a valid VIP Connect session and use
that session to launch the SDK. This screen provides default values for the SDK Base URL, which launches the SDK, and the API Base URL, which
is used when creating the session. The button on the screen will create a session and launch the SDK within the same WKWebView, showing the landing
funding page.

From the funding page, the Plaid flow can be launched by tapping the Bank Account dropdown, selecting "Add New Funding Source", and then tapping
"Connect Your Bank Account". Each VIP Connect account may only have 4 banks connected at once, so if the "Add New Funding Source" option is not
available because there are too many banks, you can use the "Manage Funding Source" option to remove some linked bank accounts.

## Plaid Integration Explanation

VIP Connect uses Plaid to connect bank accounts as funding sources for your VIP Connect ledger. When a user needs to connect a new
bank account, VIP Connect establishes a Link session with the Plaid web SDK, which will launch its own UI within the same webview.
Plaid will gain credentials to the bank account through either a username/password combo, an in-app OAuth web view, an in-browser
OAuth web view, or by authorizing within another app, all depending on how the specific bank is configured and what options are available on the user\'s device.

Once credentials have been granted, Plaid will continue to give VIP Connect access to the chosen bank account, and then return to the
VIP Connect UI where transactions may continue.

## Handling OAuth Flows Outside of the WebView

Some banks, like Chase Bank, will request to launch their OAuth flow in their own app, or in a new browser window. Additional native app code is
needed to support these cases. The WKWebView will need a WKUIDelegate that is able to open a new browser window in Safari; an example of how to
implement this can be found at [Plaid\'s documentation](https://plaid.com/docs/link/oauth/#webview), and is implemented by the WebViewController in
this example project. If the WKWebView does not have a delegate that can handle requests for new browser windows, then the Plaid flow will
not be able to continue when trying to authenticate with that bank.

## Returning to your app through a Universal Link

For cases where the OAuth flow opens in a new browser or another app, the user needs to be returned to the initial app that contains the VIP Connect SDK.
This is accomplished through the use of a Universal Link that apps must declare to handle, and will be registered with Pavilion Payments.

If you would like a Universal Link setup for your app, you can need to provide your Apple Application Identifier Prefix, and the Bundle Identifier
of each app to Pavilion. Both of these values can be found in the Identifiers section of the
[Apple Developer site](https://developer.apple.com/account/resources/identifiers/list). A sample AAIP might look like `88MPW8R88P`, and
a Bundle Identifier will look like `org.example.testapp`. Pavilion will add your app and the associated Universal Links to our hosted [AASA file](https://developer.apple.com/documentation/xcode/supporting-associated-domains),
which will enable the Universal Links the SDK will use to return after an OAuth flow.

Additionally, you will need to declare the Capability to receive urls from the associated domain within your app. Instructions for this can be found
at Apple\'s site [here](https://developer.apple.com/documentation/xcode/configuring-an-associated-domain), and this example app also declares them in
its entitlements file for reference. The domains you need to declare will be

    applinks:qa.api-gaming.paviliononline.io
    applinks:cert.api-gaming.paviliononline.io

Once these two steps are completed, then OAuth flows that occur outside your WebView will automatically return to your app once they are complete,
without any additional user interaction.

## VIP SDK Session options

This tester app has options to test various flavors and flows of Plaid integration with the VIP SDK. The quickest and easiest way to test
integration is to launch the WebView for an Existing VIP Prefered User, then click \"Create Session & Launch SDK\" to automatically create a new
session. Other options, like a New User experience and the VIP Online session, are provided to aid in testing and debugging, but are fundamentally
the same and should all treat Plaid linking the same.
