import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:linkedin_login/src/linked_in_auth_response_wrapper.dart';

class LinkedInUserModel {
  final _LinkedInPersonalInfo firstName, lastName;
  final _LinkedInProfilePicture profilePicture;
  final String userId;
  LinkedInProfileEmail email;
  LinkedInTokenObject token;

  LinkedInUserModel({
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.userId,
  });

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

  static LinkedInUserModel parseUser(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();

    return LinkedInUserModel.fromJson(parsed);
  }
}

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

class _LinkedInLocalInfo {
  final String label;

  _LinkedInLocalInfo({this.label});

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

class _LinkedInPreferredLocal {
  final String country;
  final String language;

  _LinkedInPreferredLocal({this.country, this.language});

  factory _LinkedInPreferredLocal.fromJson(Map<String, dynamic> json) =>
      _LinkedInPreferredLocal(
        country: json['country'],
        language: json['language'],
      );
}

class _LinkedInProfilePicture {
  final String displayImage;

  _LinkedInProfilePicture({this.displayImage});

  factory _LinkedInProfilePicture.fromJson(Map<String, dynamic> json) =>
      _LinkedInProfilePicture(
        displayImage: json['displayImage'],
      );
}

class LinkedInProfileEmail {
  List<_LinkedInDeepEmail> elements;

  LinkedInProfileEmail({this.elements});

  factory LinkedInProfileEmail.fromJson(Map<String, dynamic> json) =>
      LinkedInProfileEmail(
        elements: (json['elements'] != null && '${json['elements']}' != '[]')
            ? (json['elements'] as List)
                .map((i) => _LinkedInDeepEmail.fromJson(i))
                .toList()
            : [],
      );

  static LinkedInProfileEmail parseUser(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();

    return LinkedInProfileEmail.fromJson(parsed);
  }
}

class _LinkedInDeepEmail {
  String handle;
  _LinkedInDeepEmailHandle handleDeep;

  _LinkedInDeepEmail({this.handle, this.handleDeep});

  factory _LinkedInDeepEmail.fromJson(Map<String, dynamic> json) =>
      _LinkedInDeepEmail(
        handle: json['handle'],
        handleDeep: _LinkedInDeepEmailHandle.fromJson(json['handle~']),
      );
}

class _LinkedInDeepEmailHandle {
  String emailAddress;

  _LinkedInDeepEmailHandle({this.emailAddress});

  factory _LinkedInDeepEmailHandle.fromJson(Map<String, dynamic> json) =>
      _LinkedInDeepEmailHandle(
        emailAddress: json['emailAddress'],
      );
}
