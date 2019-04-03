import 'package:flutter/material.dart';
import 'package:linkedin_login/linkedin_login.dart';

void main() => runApp(MyApp());

// @TODO IMPORTANT - you need to change variable values below
// You need to add your own data from LinkedIn application
// From: https://www.linkedin.com/developers/
// Please read step 1 from this link https://developer.linkedin.com/docs/oauth2
final String redirectUrl = 'YOUR-REDIRECT-URL';
final String clientId = 'YOUR-CLIENT-ID';
final String clientSecret = 'YOUR-CLIENT-SECRET';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter LinkedIn demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LinkedInExamplePage(),
    );
  }
}

class LinkedInExamplePage extends StatefulWidget {
  @override
  State createState() => _LinkedInExamplePageState();
}

class _LinkedInExamplePageState extends State<LinkedInExamplePage> {
  UserObject user;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('LinkedIn login'),
        ),
        body: Center(
          child: Container(
              child: user == null
                  ? LinkedInButtonStandardWidget(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                LinkedInUserWidget(
                                  redirectUrl: redirectUrl,
                                  clientId: clientId,
                                  clientSecret: clientSecret,
                                  onGetUserProfile:
                                      (LinkedInUserModel linkedInUser) {
                                    print(
                                        'Access token ${linkedInUser.token.accessToken}');

                                    user = UserObject(
                                      firstName: linkedInUser
                                          .firstName.localized.label,
                                      lastName:
                                          linkedInUser.lastName.localized.label,
                                      email: linkedInUser.email.elements[0]
                                          .handleDeep.emailAddress,
                                    );

                                    Navigator.pop(context);

                                    setState(() {});
                                  },
                                  catchError: (LinkedInErrorObject error) {
                                    print(
                                        'Error description: ${error.description},'
                                        ' Error code: ${error.statusCode.toString()}');
                                    Navigator.pop(context);
                                  },
                                ),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                    )
                  : Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('First: ${user.firstName} '),
                          Text('Last: ${user.lastName} '),
                          Text('Email: ${user.email}'),
                        ],
                      ),
                    )),
        ),
      );
}

class UserObject {
  String firstName, lastName, email;

  UserObject({this.firstName, this.lastName, this.email});
}
