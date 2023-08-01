# linkedin_login

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/76c714e1e1194d0e9d8652f332d3fd5d)](https://app.codacy.com/manual/d3xt3r2909/linkedin_login?utm_source=github.com&utm_medium=referral&utm_content=d3xt3r2909/linkedin_login&utm_campaign=Badge_Grade_Dashboard) [![codecov](https://codecov.io/gh/d3xt3r2909/linkedin_login/branch/master/graph/badge.svg?token=AX9dWsdz1H)](https://codecov.io/gh/d3xt3r2909/linkedin_login)

-   A Flutter library for  [LinkedIn](https://docs.microsoft.com/en-us/linkedin/consumer/integrations/self-serve/sign-in-with-linkedin?context=linkedin/consumer/context) OAuth 2.0 APIs .
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
                print('Access token ${linkedInUser.user.token.accessToken}');
                print('First name: ${linkedInUser.user.firstName.localized.label}');
                print('Last name: ${linkedInUser.user.lastName.localized.label}');
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
  String firstName;
  String lastName;
  String accessToken;
  int expiresIn;
  String profilePicture;
  String email;
  String userId; (from version 0.1.)
```
## Projection - which properties of user account will be accessible via LinkedIn API
### Available from version 1.2.x

You can control projection, by providing array of strings to projection property of widget 
`LinkedInUserWidget`. By default these properties are included: 

```dart
  static const String id = "id";
  static const String localizedLastName = "localizedLastName";
  static const String firstName = "firstName";
  static const String lastName = "lastName";
  static const String localizedFirstName = "localizedFirstName";
```

You can include also `profilePicture` to get URL of user profile image. If you change this property
to some custom value you will override default values, and you need to add every of these manually
to array. For more info see example project.

## Scopes - Enables you to define whatever scope you are needed
### Available from version 2.3.1

You can control scope that you want to get from LinkedIn. By default you will have `r_emailaddress`
and `r_liteprofile` but you can change it anytime if you use `scope` property inside `LinkedInUserWidget`
or inside of `LinkedInAuthCodeWidget`.

```dart
  final scopes = const [
    EmailAddressScope(),
    LiteProfileScope(),
  ],
```

You are also able to create custom scopes by extending `Scope` class

```dart
class CustomScope extends Scope {
  const CustomScope() : super('r_emailaddress');
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
