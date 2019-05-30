# linkedin_login

- A Flutter library for  [LinkedIn](https://docs.microsoft.com/en-us/linkedin/consumer/integrations/self-serve/sign-in-with-linkedin?context=linkedin/consumer/context) OAuth 2.0 APIs .

- This library is using new way of authorization on [LinkedIn](https://engineering.linkedin.com/blog/2018/12/developer-program-updates)

## Installation

- See the [installation instructions on pub](https://pub.dartlang.org/packages/linkedin_login#-installing-tab-)

## Important 

You should replace this values
    
    final String redirectUrl = 'YOUR-REDIRECT-URL';
    final String clientId = 'YOUR-CLIENT-ID';
    final String clientSecret = 'YOUR-CLIENT-SECRET';

`Note: clientSecret field is required just for LinkedInUserWidget`

To get these values you need to create App on the [LinkedIn](https://www.linkedin.com/developers/apps/new).

## Samples

You can see full example under this [project](https://github.com/d3xt3r2909/linkedin_login/tree/master/example).

Call LinkedIn authorization and get user object:
```dart
    LinkedInUserWidget(
       redirectUrl: redirectUrl,
       clientId: clientId,
       clientSecret: clientSecret,
       onGetUserProfile:
           (LinkedInUserModel linkedInUser) {
                print('Access token ${linkedInUser.token.accessToken}');
                print('First name: ${linkedInUser.firstName.localized.label}');
                print('Last name: ${linkedInUser.lastName.localized.label}');
       },
       catchError: (LinkedInErrorObject error) {
         print(
             'Error description: ${error.description},'
             ' Error code: ${error.statusCode.toString()}');
        },
    )
```

Or you can just fetch authorization code (clientSecret is not required in this widget):
```dart
    LinkedInAuthCodeWidget(
        redirectUrl: redirectUrl,
        clientId: clientId,
        onGetAuthCode:
            (AuthorizationCodeResponse response) {
                print('Auth code ${response.code}');
                print('State: ${response.state}');
            },
    ),
```
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

## Properties that are available after call for LinkedInAuthCodeWidget

```dart
  String code; // authorization code
  String state;
```

## Widgets

Standard LinkedIn button for login. This widget is modifiable.

    LinkedInButtonStandardWidget(onTap: () {});
