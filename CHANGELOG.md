# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v0.1.0 - 2019-01-23
### Added

 - Login with LinkedIn support to Android and IOS using pure dart
 - LinkedIn default button
 - Retrieve basic user information from linked login with email and token

## v0.1.1 - 2019-04-03
### Version upgrade

 - Upgrade version of libraries that this package is using

## v0.1.3 - 2019-05-03
### Added new field into user model

 - UserId in LinkedInUserModel class
 - Fix bugs if there is not existing images

## v0.1.4 - 2019-05-30
### Added new widget

 - Fetch just authorization code
 - Use widget without sending client secret code

## v0.1.6 - 2019-07-5
### Added new widget

 - Add possibility to add app bar into webview as parameter

## v0.1.7 - 2019-08-5
### Added new widget

 - It can be case that URL route from redirect is redirecting to some other field
 - in that case you can use property "frontendRedirectUrl" so that you still can use redirect URL
 - of LinkedIn, but also handle if frontend redirect that link to some other site

## v0.1.8 - 2019-08-5
### Added new widget

 - Expose frontendRedirectUrl field

## v0.2.0 - 2019-08-12
### Added new widget

 - Possibility to log out user from linkedIn - from now you can change account as should


