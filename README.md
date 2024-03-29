#  VIP Connect Plaid Integration Test App

This app is a scaffold to quickly and simply test various configurations for Plaid OAuth account linking in the VIP Connect SDK in a native app.

This app contains only two views natively, but does contain some additional setup and configuration code that may be useful when debugging.

To get started quickly, launch the app, tap the \"Launch WebView for Existing User\" button, and then click \"Create Session & Launch SDK\"
in the WebView without changing any values from their defaults. This will take you to a Deposit flow in the VIP SDK. To test the Plaid integration,
try adding a new bank account by selecting the Bank Account dropdown and choosing \"Add New Funding Source\" to start the flow.

To learn more about other flows, see the VIP SDK Session options section below.

## App Structure

The WebSDKTester app launches with a simple native View containing a button to launch the VIP Connect web SDK.
When the button is clicked, a WKWebView view is created and popped up over the screen. The VIP Connect SDK is agnostic
to how its containing WKWebView is presented, but for purposes of this app is is displayed in a dismissable sheet so it
is easy to restart the flow again, and also to clearly see which views are native code and which are web views.

The first screen after launching the web view is a dummy operator screen whose purpose is to create and launch a valid
VIP Connect session. Default values are provided but can be modified.

If you have obtained a session id from somewhere outside the app, you may simply enter it in the provided field and launch
VIP Connect with that session.

Otherwise, you will need to create a session in-app. The landing screen in the web view provides a button that will
create a session based on the current values for the `apiBaseUrl` and `transactionAmount` in the form.

In both cases, a VIP Connect instance will be launched at the given `sdkBaseUrl` with the given `redirectUrl`.

The VIP Connect SDK will load the session into the webview and display a funding page. From here, the Plaid integration
to the VIP Connect SDK can be tested.

## Plaid Integration Explanation

VIP Connect uses Plaid to connect bank accounts as funding sources for your VIP Connect ledger. When a user needs to connect a new
bank account, VIP Connect establishes a Link session with the Plaid web SDK, which will launch its own UI within the same web view.
Plaid will gain credentials to the bank account through either a username/password combo, an in-app OAuth web view, an in-browser
OAuth web view, or by authorizing within another app, all depending on how the specific bank is configured and what options are available on the user\'s device.

Once credentials have been granted, Plaid will continue to give VIP Connect access to the chosen bank account, and then return to the
VIP Connect UI where transactions may continue.

## Plaid Redirect URL

Upon completion of the bank\'s OAuth UI, and Plaid has gotten the credentials it needs, the user will need to be put back into the Plaid UI to
complete the connection of the bank account. The `redirectUrl` provided should lead to a page that is capable of restoring the VIP SDK session;
the default url will do this automatically for the user so they are brought back to the Plaid UI after OAuth is complete.

## Handling OAuth Flows Outside of the WebView

Some banks will request to launch their OAuth flow in their own app, or in a new browser window. Additional native app code is needed to support these cases.
The WKWebView will need a WKUIDelegate that is able to open a new browser window in Safari; an example of how to implement this can be found
at [Plaid\'s documentation](https://plaid.com/docs/link/oauth/#webview). If the WKWebView does not have a delegate that can handle requests for
new browser windows, then the Plaid flow will not be able to continue when trying to authenticate with that bank. Currently, Chase Bank requires
this additional code, and more banks may require it in the future.

## Returning to your app through a Universal Link

For cases where the OAuth flow opens in a new browser, upon completion, the user will be left in the Safari app with a message to return
to your app. There will also be a quick link to return in the upper left corner of the phone. However, the process can be made automatic if
you register a Universal Link for your app. If your app has a Universal Link registered, then the OAuth flow can launch that url when it is complete,
which will cause Safari to automatically return to your app to continue the Plaid flow.

There are two main steps to adding a Universal Link to your app: you must have your app request access to urls at a domain, and that domain must
grant your app access to accept urls within it.

\[Work In Progress\] Pavilion will create a Universal Link for Plaid OAuth flows. You will need to provide your Apple Application Identifier Prefix, and the Bundle Identifier of your app to Pavilion. Both
of these values can be found in the Identifiers section of the [Apple Developer site](https://developer.apple.com/account/resources/identifiers/list).
For example, the Chase mobile app Prefix and Bundle Identifier are `88MPW8R88P` and `com.chase`.

Additionally, you will need to declare the Capability to receive urls from the associated domain within your app. Instructions for this can be found
at Apple\'s site [here](https://developer.apple.com/documentation/xcode/configuring-an-associated-domain). The domain you need to declare will be

    applinks:qa.api-gaming.paviliononline.io

Once these two steps are completed, then OAuth flows that occur outside your WebView will automatically return to your app once they are complete,
without any additional user interaction.

## VIP SDK Session options

This tester app has options to test various flavors and flows of Plaid integration with the VIP SDK. The quickest and easiest way to test
integration is to launch the WebView for an Existing User, then click \"Create Session & Launch SDK\" to automatically create a new
session as an existing user, who can then 
