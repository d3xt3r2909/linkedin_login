import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:linkedin_login/src/linked_in_auth_response_wrapper.dart';

/// Class which has responsibility to keep all users information on one place
/// Note: You will not get an profile URL with this model. The library is still
/// not supporting this, but as work around you should call this API
/// https://api.linkedin.com/v2/me?projection=(id,profilePicture(displayImage~:playableStreams))&oauth2_access_token=HERE
/// where you will of course replace [HERE] with a access token which you can
/// find inside [token] property
/// [firstName] & [lastName] & [email] will contain information which user has setup on
/// linkedIn page
/// while [userId] is LinkedIn generated field same as values inside [token]
class LinkedInUserModel {
  final _LinkedInPersonalInfo firstName, lastName;
  final _LinkedInProfilePicture profilePicture;
  final String userId;
  LinkedInProfileEmail email;
  LinkedInTokenObject token;

  /// Create user model based on response of LinkedIn APIs
  LinkedInUserModel({
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.userId,
  });

  /// Convert response from API to [LinkedInUserModel] object
  factory LinkedInUserModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> firstName = json['firstName'];
    Map<String, dynamic> lastName = json['lastName'];
    Map<String, dynamic> profilePicture = json['profilePicture'];
    String userId = json['id'];

    return LinkedInUserModel(
      firstName:
          firstName != null ? _LinkedInPersonalInfo.fromJson(firstName) : null,
      lastName:
          lastName != null ? _LinkedInPersonalInfo.fromJson(lastName) : null,
      profilePicture: profilePicture != null
          ? _LinkedInProfilePicture.fromJson(profilePicture)
          : null,
      userId: userId ?? null,
    );
  }

  /// Static method which will based on string response parse the user into
  /// [LinkedInUserModel] object
  static LinkedInUserModel parseUser(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();

    return LinkedInUserModel.fromJson(parsed);
  }
}

/// Helper children subclass
class _LinkedInPersonalInfo {
  final _LinkedInLocalInfo localized;
  final _LinkedInPreferredLocal preferredLocal;

  factory _LinkedInPersonalInfo.fromJson(Map<String, dynamic> json) =>
      _LinkedInPersonalInfo(
        localized: _LinkedInLocalInfo.fromJson(json['localized']),
        preferredLocal:
            _LinkedInPreferredLocal.fromJson(json['preferredLocale']),
      );

  _LinkedInPersonalInfo({this.localized, this.preferredLocal});
}

/// Helper children subclass
class _LinkedInLocalInfo {
  final String label;

  _LinkedInLocalInfo({this.label});

  /// Convert response from API to [_LinkedInLocalInfo] object
  factory _LinkedInLocalInfo.fromJson(Map<String, dynamic> json) =>
      _LinkedInLocalInfo(
        label: getFirstInListFromJson(json),
      );
}

/// Helper function to parse first element from json
/// If there is no element, or element is not string it will return you null
@visibleForTesting
String getFirstInListFromJson(Map<String, dynamic> json) {
  final jsonValue = json?.values;

  if (jsonValue != null && jsonValue.isNotEmpty) {
    final jsonLocalization = jsonValue.toList().first;
    if (jsonLocalization is String) {
      return jsonLocalization;
    }
  }

  return null;
}

/// Helper children subclass
class _LinkedInPreferredLocal {
  final String country;
  final String language;

  _LinkedInPreferredLocal({this.country, this.language});

  /// Convert response from API to [_LinkedInPreferredLocal] object
  factory _LinkedInPreferredLocal.fromJson(Map<String, dynamic> json) =>
      _LinkedInPreferredLocal(
        country: json['country'],
        language: json['language'],
      );
}

/// Helper children subclass
class _LinkedInProfilePicture {
  final String displayImage;

  _LinkedInProfilePicture({this.displayImage});

  /// Convert response from API to [_LinkedInProfilePicture] object
  factory _LinkedInProfilePicture.fromJson(Map<String, dynamic> json) =>
      _LinkedInProfilePicture(
        displayImage: json['displayImage'],
      );
}

/// Helper children subclass
class LinkedInProfileEmail {
  List<_LinkedInDeepEmail> elements;

  LinkedInProfileEmail({this.elements});

  /// Convert response from API to [LinkedInProfileEmail] object
  factory LinkedInProfileEmail.fromJson(Map<String, dynamic> json) =>
      LinkedInProfileEmail(
        elements: (json['elements'] != null && '${json['elements']}' != '[]')
            ? (json['elements'] as List)
                .map((i) => _LinkedInDeepEmail.fromJson(i))
                .toList()
            : [],
      );

  /// Based on string response parse to [LinkedInProfileEmail]
  static LinkedInProfileEmail parseUser(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();

    return LinkedInProfileEmail.fromJson(parsed);
  }
}

/// Helper children subclass
class _LinkedInDeepEmail {
  String handle;
  _LinkedInDeepEmailHandle handleDeep;

  _LinkedInDeepEmail({this.handle, this.handleDeep});

  /// Convert response from API to [_LinkedInDeepEmail] object
  factory _LinkedInDeepEmail.fromJson(Map<String, dynamic> json) =>
      _LinkedInDeepEmail(
        handle: json['handle'],
        handleDeep: _LinkedInDeepEmailHandle.fromJson(json['handle~']),
      );
}

/// Helper children subclass
class _LinkedInDeepEmailHandle {
  String emailAddress;

  _LinkedInDeepEmailHandle({this.emailAddress});

  /// Convert response from API to [_LinkedInDeepEmailHandle] object
  factory _LinkedInDeepEmailHandle.fromJson(Map<String, dynamic> json) =>
      _LinkedInDeepEmailHandle(
        emailAddress: json['emailAddress'],
      );
}
