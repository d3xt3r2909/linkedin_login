# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v0.1.0 - 2019-01-23
### Added

-   Login with LinkedIn support to Android and IOS using pure dart
-   LinkedIn default button
-   Retrieve basic user information from linked login with email and token

## v0.1.1 - 2019-04-03
### Version upgrade

-   Upgrade version of libraries that this package is using

## v0.1.3 - 2019-05-03
### Added new field into user model

-   UserId in LinkedInUserModel class
-   Fix bugs if there is not existing images

## v0.1.4 - 2019-05-30
### Added new widget - fetch only authorization code

-   Fetch just authorization code
-   Use widget without sending client secret code

## v0.1.6 - 2019-07-5
### Added new widget - possibility to add custom app bar

-   Add possibility to add app bar into webview as parameter

## v0.1.7 - 2019-08-5
### Add frontendRedirectUrl property in case of frontend redirection

-   It can be case that URL route from redirect is redirecting to some other field
-   in that case you can use property "frontendRedirectUrl" so that you still can use redirect URL
-   of LinkedIn, but also handle if frontend redirect that link to some other site

## v0.1.8 - 2019-08-5
### Expose frontendRedirectUrl property

-   Expose frontendRedirectUrl field

## v0.2.0 - 2019-08-12
### Possibility to clean cache and logout a user

-   Possibility to log out user from linkedIn - from now you can change account as should
 
## v1.0.0 - 2020-01-20
### Support for web

-   Added support for web
-   Update dependency versions
 
## v1.1.0 - 2020-01-22
### Change error parsing issue

-   [500 <=> 401 issue](https://github.com/d3xt3r2909/linkedin_login/issues/12)

## v1.1.1 - 2020-01-22
### Version update to v1.1.1

-   Version updated
 
## v1.1.2 - 2020-04-28
### Fix [#12](https://github.com/d3xt3r2909/linkedin_login/issues/12)

-   Fix issue with fetching locals [#12](https://github.com/d3xt3r2909/linkedin_login/issues/12). Thanks to [@JavierDuarteC](https://github.com/JavierDuarteC)

## v1.1.3 - 2020-05-09
### Resolve [#23](https://github.com/d3xt3r2909/linkedin_login/issues/23)

-   Replace AppBar with PreferredSizeWidget. Thanks for contribution [@ricardonior29](https://github.com/ricardonior29)

## v1.1.5 - 2020-05-31
### Version updated to v1.1.5

-   Replace AppBar with PreferredSizeWidget. Thanks for contribution [@ricardonior29](https://github.com/ricardonior29)
-   Fix lint messages
-   Increase Dart SDK version

## 1.1.6 - 2020-07-16
### Version updated to v1.1.6

- Update API documentation

## 1.2.0 - 2020-07-16
### Add possibility to control projection of LinkedIn API

- Add property `projection` to a LinkedInUserWidget widget 