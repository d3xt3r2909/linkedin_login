# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 3.1.3
### Fix iOS and Android issues

## 3.1.2
### Add iOS support

## 3.1.1
### Remove not needed dependency 

## 3.1.0 
### Move architecture to the federated plugin approach 
- https://docs.flutter.dev/packages-and-plugins/developing-packages#federated-plugins
- This will enable us in future to plan and introduce new platforms like web, desktop, etc.

## 3.0.5
### Reintroduce webview_flutter_android and webview_flutter_wkwebview dependencies

- These platform specific dependencies are reintroduced to fix the issue with not opening keyboard
on Android 13 devices

## 3.0.4
### Update dependencies

- Update dependencies

## 3.0.3
### Update dependencies

- Update dependencies

## 3.0.2
### Remove not needed code

- Publish automation

## 3.0.1
### Remove not needed code

- Remove iOS specific code that's not needed anymore which enable us to remove webview_flutter_android and webview_flutter_wkwebview dependencies

## 3.0.0
### Contains breaking change - see under 3.0.0-beta.1

- Migration to sign in with OpenId
- Upgrade dependencies to the latest versions
- Update minimum flutter and dart version

## 3.0.0-beta.1
### Contains breaking change - migration to sign in with OpenId

Since LinkedIn introduce new way of signing in with LinkedIn called "Sign In with LinkedIn using OpenID Connect"
and they are deprecating and removing "Sign In with LinkedIn" from product list (see LinkedIn console where you have created your app)
this library needs to have few breaking changes duo change of architecture. Sorry for that in advance.

- Projection property no longer exists since `/me` API is removed and from now on library is using `/userinfo` [docs](https://learn.microsoft.com/en-us/linkedin/consumer/integrations/self-serve/sign-in-with-linkedin-v2)
- Previous scopes are removed (r_emailaddress, r_liteprofile) and introduces new ones: `openid`, `email`, `profile`
- All fields on user response are flatten (see example project) and some are not existing anymore
- Response that you can get from LinkedIn with new API looks like this

```json
{
    "sub": "xxxx",
    "email_verified": true,
    "name": "xxxx",
    "locale": {
        "country": "US",
        "language": "en"
    },
    "given_name": "xxxx",
    "family_name": "xxxx",
    "email": "xxxx",
    "picture": "xxxx"
}
```

For more details about this change you can navigate to this [issue](https://github.com/d3xt3r2909/linkedin_login/issues/91)

More references:

- [O-Auth]https://learn.microsoft.com/en-gb/linkedin/shared/authentication/authorization-code-flow?tabs=HTTPS1
- [Sign In With OpenID](https://learn.microsoft.com/en-us/linkedin/consumer/integrations/self-serve/sign-in-with-linkedin-v2)
- [Deprecation note - Since Aug. 1. 2023](https://learn.microsoft.com/en-us/linkedin/consumer/integrations/self-serve/sign-in-with-linkedin)

## 2.3.1
### Support change of scopes

- Support changing scopes for authentication, thanks to [kgeorgek](https://github.com/kgeorgek)
- Usage is mentioned inside README.md under `Scopes` section
- Please have in mind that there are still limitations regarding this, more inside `Known Limitations` section

## 2.3.0
### Update dependencies

- Migrate dart version - support just null safety from now on
- Upgrade packages versions
- Migrate 2.2.2-beta.1 to stable
- Update example to null safety

## 2.2.2-beta.1
### Update dependencies

- Upgrade web controller to v4 from v3
- Editable background color for `LinkedInButtonStandardWidget`, Thanks to, [mdbollman](https://github.com/mdbollman)

## 2.2.1
### Update dependencies

-   Update project dependencies to the last once

## 2.2.0
### New linter

-   Move lint from [analyzer](https://pub.dev/packages/analyzer) to the [flutter_lints](https://pub.dev/packages/flutter_lints)
-   Enforce recommend lint rules

## 2.1.0
### Happy new year

-   Change platform mode to use `Hybrid Composition` by default [docs](https://pub.dev/packages/webview_flutter)
-   Add possibility to use `Virtual displays`
-   Update dependencies    
-   Cleaning a code

## 2.0.1
### Library refactor

-   Min SDK version is set to 19
-   Dart 2.13.3 - last stable

## 2.0.0
### Library refactor

-   Migrated to null safety
-   Update dependencies
-   Breaking changes inside `2.0.0-dev.3 (see release on 22-02-2021 & example)`

## 2.0.0-dev.4 - 24-03-2021
### Library refactor

-   Migrated to null safety

## 2.0.0-dev.3 - 22-02-2021
### Library refactor

-   remove redux, there is no so much contributors for this package anymore
-   *BREAKING CHANGE*: callbacks now have different types, please see readme file
-   *BREAKING CHANGE*: catchError is replaced by onError property, method will give you any exception or error which happened deep down in plugin with complete stacktrace
-   update dependencies

## 2.0.0-dev.2 - 03-12-2020
### Library refactor

-   test code coverage >90
-   remove catchError callback *BREAKING CHANGE*, issues needs to be fixed before releasing
-   improved logging errors, exceptions and steps inside debug mode

## 2.0.0-dev.1 - 03-12-2020
### Library refactor

-   switch to new web view plugin
-   cover code with tests
-   add logging errors and steps
-   deprecated error callback, from now on console error will be only shown
-   introduce Redux, Graph for better transfer data between screens
-   enable CI via Github actions and test coverage 

## 1.3.1 - 02-11-2020
### Files restructure 

-   restructure code and prepare it for updating to new webview plugin

## 1.3.0 - 31-10-2020
### upgrade android embedding to v2

-   from Flutter version > v1.23.* embedding v1 is deprecated
-   introduce null safety based on flutter version v1.23

## 1.2.2 - 13-08-2020
### remove assert check for appBar widget

-   remove assert check for appBar widget, you can send null value

## 1.2.1 - 16-07-2020
### formatted according to dartfmt

-   formatted according to dartfmt

## 1.2.0 - 16-07-2020
### Add possibility to control projection of LinkedIn API

-   Add property `projection` to a LinkedInUserWidget widget

## 1.1.6 - 16-07-2020
### Version updated to v1.1.6

-   Update API documentation

## v1.1.5 - 31-05-2020
### Version updated to v1.1.5

-   Replace AppBar with PreferredSizeWidget. Thanks for contribution [@ricardonior29](https://github.com/ricardonior29)
-   Fix lint messages
-   Increase Dart SDK version

## v1.1.3 - 09-05-2020
### Resolve [#23](https://github.com/d3xt3r2909/linkedin_login/issues/23)

-   Replace AppBar with PreferredSizeWidget. Thanks for contribution [@ricardonior29](https://github.com/ricardonior29)

## v1.1.2 - 28-04-2020
### Fix [#12](https://github.com/d3xt3r2909/linkedin_login/issues/12)

-   Fix issue with fetching locals [#12](https://github.com/d3xt3r2909/linkedin_login/issues/12). Thanks to [@JavierDuarteC](https://github.com/JavierDuarteC)

## v1.1.1 - 22-01-2020
### Version update to v1.1.1

-   Version updated

## v1.1.0 - 22-01-2020
### Change error parsing issue

-   [500 <=> 401 issue](https://github.com/d3xt3r2909/linkedin_login/issues/12)
 
## v1.0.0 - 20-01-2020
### Support for web

-   Added support for web
-   Update dependency versions

## v0.2.0 - 12-08-2019
### Possibility to clean cache and logout a user

-   Possibility to log out user from linkedIn - from now you can change account as should

## v0.1.8 - 05-08-2019
### Expose frontendRedirectUrl property

-   Expose frontendRedirectUrl field

## v0.1.7 - 05-08-2019
### Add frontendRedirectUrl property in case of frontend redirection

-   It can be case that URL route from redirect is redirecting to some other field
-   in that case you can use property "frontendRedirectUrl" so that you still can use redirect URL
-   of LinkedIn, but also handle if frontend redirect that link to some other site

## v0.1.6 - 05-07-2019
### Added new widget - possibility to add custom app bar

-   Add possibility to add app bar into webview as parameter

## v0.1.4 - 30-05-2019
### Added new widget - fetch only authorization code

-   Fetch just authorization code
-   Use widget without sending client secret code

## v0.1.3 - 03-05-2019
### Added new field into user model

-   UserId in LinkedInUserModel class
-   Fix bugs if there is not existing images

## v0.1.1 - 03-04-2019
### Version upgrade

-   Upgrade version of libraries that this package is using

## v0.1.0 - 01-23-2019
### Added

-   Login with LinkedIn support to Android and IOS using pure dart
-   LinkedIn default button
-   Retrieve basic user information from linked login with email and token
