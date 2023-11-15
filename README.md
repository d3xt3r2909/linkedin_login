# linkedin_login

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/76c714e1e1194d0e9d8652f332d3fd5d)](https://app.codacy.com/manual/d3xt3r2909/linkedin_login?utm_source=github.com&utm_medium=referral&utm_content=d3xt3r2909/linkedin_login&utm_campaign=Badge_Grade_Dashboard) [![codecov](https://codecov.io/gh/d3xt3r2909/linkedin_login/branch/master/graph/badge.svg?token=AX9dWsdz1H)](https://codecov.io/gh/d3xt3r2909/linkedin_login)

-   (Implemented in version of 3.0.0 of this library) A Flutter library for  [LinkedIn](https://learn.microsoft.com/en-us/linkedin/consumer/integrations/self-serve/sign-in-with-linkedin-v2) OAuth 2.0 APIs .
-   (Deprecated from LinkedIn and removed from this library after v3.0.0) A Flutter library for  [LinkedIn](https://docs.microsoft.com/en-us/linkedin/consumer/integrations/self-serve/sign-in-with-linkedin?context=linkedin/consumer/context) OAuth 2.0 APIs .
-   This library is using authorization from [LinkedIn API](https://engineering.linkedin.com/blog/2018/12/developer-program-updates)

#### ⭐⭐⭐⭐ Star ⭐⭐⭐⭐ a repo if you like project. Your support matters to us.⭐⭐⭐⭐

## Installation

-   See the [installation instructions on pub](https://pub.dartlang.org/packages/linkedin_login#-installing-tab-)

## Important 

You should replace this values
    
    final String redirectUrl = 'YOUR-REDIRECT-URL';
    final String clientId = 'YOUR-CLIENT-ID';
    final String clientSecret = 'YOUR-CLIENT-SECRET';

`Note: clientSecret field is required just for LinkedInUserWidget`

## Hybrid Composition vs Virtual displays (Android only)
To get these values you need to create App on the [LinkedIn](https://www.linkedin.com/developers/apps/new).

- Please check your `minSdkVersion` for different setup:
-- If you are using `Hybrid Composition` (default from version 2.1.0) your `minSdkVersion` should be at least 19
-- If you want to use `Virtual displays` (default **before** version 2.1.0) your `minSdkVersion` should be at least 20
  
To read more why this lib needs to use one of these two modes please visit docs of [webview_flutter](https://pub.dev/packages/webview_flutter)

## Migration from 2.x.x library to 3.x.x

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

## Samples

You can see full example under this [project](https://github.com/d3xt3r2909/linkedin_login/tree/master/example).

Call LinkedIn authorization and get user object:
```dart
    LinkedInUserWidget(
       redirectUrl: redirectUrl,
       clientId: clientId,
       clientSecret: clientSecret,
       onGetUserProfile:
           (UserSucceededAction linkedInUser) {
                print('Access token ${linkedInUser.user.token}');
                print('First name: ${linkedInUser.user.givenName}');
                print('Last name: ${linkedInUser.user.familyName}');
       },
       onError: (UserFailedAction e) {
                print('Error: ${e.toString()}');
       },
    )
```

Or you can just fetch authorization code (clientSecret is not required in this widget):
```dart
    LinkedInAuthCodeWidget(
        redirectUrl: redirectUrl,
        clientId: clientId,
        onGetAuthCode:
            (AuthorizationSucceededAction response) {
                print('Auth code ${response.codeResponse.code}');
                print('State: ${response.codeResponse.state}');
            },
        onError: (AuthorizationFailedAction e) {
                print('Error: ${e.toString()}');
             },
    ),
```

If you want to logout user (to clear session from webview) all you need is to forward ```true``` value
to property ```destroySession```  in ```LinkedInUserWidget``` or ```LinkedInAuthCodeWidget```. Please don't forget to destroy your data in your local storage for this user. Currently, LinkedIn doesn't have API point on OAuth 2 which will destroy access token.

## Properties that are available after call for LinkedInUserWidget

```dart
  String name;
  String familyName;
  String givenName;
  bool isEmailVerified;
  String sub;
  String accessToken;
  int expiresIn;
  String picture;
  String email;
  LinkedInPreferredLocal locale; (from version 0.1.)
```
## Projection - No longer used duo deprecation and migration to OpenId
### Available from version 1.2.x

## Scopes - Enables you to define whatever scope you are needed
### Available from version 2.3.1

`r_emailaddress` and `r_liteprofile` scopes will be removed from LinkedIn after 30 of November and they are removed from library after 3.x.x version.

Now you should add under "Products" -> "Sign In With LinkedIn using OpenID Connect"

https://www.linkedin.com/developers/apps/{REPLACE_WITH_ID_OF_YOUR_APP}/products

OpenId is requiring openid scope with in combination of at least Email or Profile scope, but by default this library is adding three scopes

```dart
  final scopes = const [
    OpenIdScope(),
    EmailScope(),
    ProfileScope(),
  ],
```

You are also able to create custom scopes by extending `Scope` class

```dart
class CustomScope extends Scope {
  const CustomScope() : super('whatever_scope_of_name_to_map_with_linkedin_api');
}
```

However please take in consideration limitations of this library under section `known limitations`
inside this file.

## Properties that are available after call for LinkedInAuthCodeWidget

```dart
  String code; // authorization code
  String state;
```

## Widgets

Standard LinkedIn button for login. This widget is modifiable.

    LinkedInButtonStandardWidget(onTap: () {});

## Contribution

- To regenerate mocks and generated files please run:

```dart
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Known Limitations

#### Login scopes mostly related to `w_member_social`

- Best and shortest explanation why library is not supporting this is hidden behind this (comment)[https://github.com/d3xt3r2909/linkedin_login/issues/28#issuecomment-673357716]
- If you have (access)[https://stackoverflow.com/a/57979607/6074443] to (developer partner program)[https://linkedin.zendesk.com/hc/en-us] I would really appreciate if you could submit pull request on this feature.

#### Firebase

- As Firebase is not supporting LinkedIn out of the box this is not implemented inside the library and its heavy consuming time to implement custom solution, anyhow if someone is willing to submit PR I would really love to approve it

#### Web

- Web is still not supported at it requires a lot of JS work, as LinkedIn doesn't allow that their API is injected into iFrame
