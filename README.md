# OneHubOAuth

An OAuth2 example for Mac OS X & iOS (Cocoa & Cocoa touch) in Objective C to obtain access token from OneHub.

# Description

This example is based on the OAuth2 spec. It implements the native application profile and supports the end-user authorization endpoint via an internal or an external user-agent. Furthermore it also supports the user credentials flow by prompting the end-user for their username and password and use them directly to obtain an access token from OneHub. 

# Getting started

Here is the basic implementation of this example. You just need to update ViewController.m file as below:

 #define TOKEN_URL @"https://ws-api.onehub.com/oauth/token" // already defined <br />
 #define CLIENT_ID @"ENTER CLIENT ID HERE" // enter your client id <br />
 #define CLIENT_SECRET @"ENTER CLIENT SECRET HERE" // enter your client secret <br />
 #define USERNAME @"ENTER USERNAME HERE" // enter your username/email <br />
 #define PASSWORD @"ENTER PASSWORD HERE" // enter your password <br />
 #define REDIRECT_URI @"https://localhost" // already defined <br />
 #define GRANT_TYPE @"password" // already defined <br />
