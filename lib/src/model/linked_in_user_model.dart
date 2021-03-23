import 'package:flutter/cupertino.dart';
import 'package:linkedin_login/src/wrappers/linked_in_token_object.dart';

/// Class which has responsibility to keep all users information on one place
/// Note: You will not get an profile URL with this model. The library is still
/// not supporting this, but as work around you should call this API
/// https://api.linkedin.com/v2/me?projection=(id,profilePicture(displayImage~:playableStreams))&oauth2_access_token=HERE
/// where you will of course replace `HERE` with a access token which you can
/// find inside [token] property
/// [firstName] & [lastName] & [email] will contain information which user has setup on
/// linkedIn page
/// while [userId] is LinkedIn generated field same as values inside [token]
class LinkedInUserModel {
  /// Create user model based on response of LinkedIn APIs
  LinkedInUserModel({
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.userId,
    this.localizedFirstName,
    this.localizedLastName,
  });

  /// Convert response from API to [LinkedInUserModel] object
  factory LinkedInUserModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName'];
    final lastName = json['lastName'];
    final profilePicture = json['profilePicture'];
    final localizedFirstName = json['localizedFirstName'];
    final localizedLastName = json['localizedLastName'];
    final userId = json['id'];

    return LinkedInUserModel(
      firstName:
          firstName != null ? LinkedInPersonalInfo.fromJson(firstName) : null,
      lastName:
          lastName != null ? LinkedInPersonalInfo.fromJson(lastName) : null,
      profilePicture: profilePicture != null
          ? LinkedInProfilePicture.fromJson(profilePicture)
          : null,
      userId: userId,
      localizedFirstName: localizedFirstName,
      localizedLastName: localizedLastName,
    );
  }

  final LinkedInPersonalInfo? firstName, lastName;
  final LinkedInProfilePicture? profilePicture;
  final String? userId;
  final String? localizedFirstName, localizedLastName;
  LinkedInProfileEmail? email;
  late LinkedInTokenObject token;

  @override
  String toString() {
    return 'LinkedInUserModel{firstName: $firstName, lastName: $lastName, profilePicture: $profilePicture, userId: $userId, localizedFirstName: $localizedFirstName, localizedLastName: $localizedLastName, email: $email, token: $token}';
  }
}

/// Helper children subclass
class LinkedInPersonalInfo {
  LinkedInPersonalInfo({this.localized, this.preferredLocal});

  factory LinkedInPersonalInfo.fromJson(Map<String, dynamic> json) =>
      LinkedInPersonalInfo(
        localized: LinkedInLocalInfo.fromJson(json['localized']),
        preferredLocal:
            LinkedInPreferredLocal.fromJson(json['preferredLocale']),
      );

  final LinkedInLocalInfo? localized;
  final LinkedInPreferredLocal? preferredLocal;
}

/// Helper children subclass
class LinkedInLocalInfo {
  LinkedInLocalInfo({this.label});

  /// Convert response from API to [LinkedInLocalInfo] object
  factory LinkedInLocalInfo.fromJson(Map<String, dynamic>? json) =>
      LinkedInLocalInfo(
        label: getFirstInListFromJson(json),
      );

  final String? label;
}

/// Helper function to parse first element from json
/// If there is no element, or element is not string it will return you null
@visibleForTesting
String? getFirstInListFromJson(Map<String, dynamic>? json) {
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
class LinkedInPreferredLocal {
  LinkedInPreferredLocal({this.country, this.language});

  /// Convert response from API to [LinkedInPreferredLocal] object
  factory LinkedInPreferredLocal.fromJson(Map<String, dynamic> json) =>
      LinkedInPreferredLocal(
        country: json['country'],
        language: json['language'],
      );

  final String? country;
  final String? language;
}

/// Helper children subclass
class LinkedInProfilePicture {
  LinkedInProfilePicture({this.displayImage, this.displayImageContent});

  /// Convert response from API to [LinkedInProfilePicture] object
  factory LinkedInProfilePicture.fromJson(Map<String, dynamic> json) =>
      LinkedInProfilePicture(
        displayImage: json['displayImage'],
        displayImageContent: json['displayImage~'] != null
            ? _DisplayImage.fromJson(json['displayImage~'])
            : null,
      );

  final String? displayImage;
  final _DisplayImage? displayImageContent;
}

/// Will contain info about image if it's included into response
class _DisplayImage {
  _DisplayImage({this.paging, this.elements});

  /// Convert response from API to [LinkedInProfilePicture] object
  factory _DisplayImage.fromJson(Map<String, dynamic> json) => _DisplayImage(
        paging: _ImagePagination.fromJson(json['paging']),
        elements: (json['elements'] != null && '${json['elements']}' != '[]')
            // ignore: avoid_as
            ? (json['elements'] as List)
                .map((i) => _ImageItem.fromJson(i))
                .toList()
            : [],
      );

  final _ImagePagination? paging;
  final List<_ImageItem>? elements;
}

/// Contain URL and other information about one user image
class _ImageItem {
  _ImageItem({this.artifact, this.authorizationMethod, this.identifiers});

  /// Convert response from API to [LinkedInProfilePicture] object
  factory _ImageItem.fromJson(Map<String, dynamic> json) => _ImageItem(
        artifact: json['artifact'],
        authorizationMethod: json['authorizationMethod'],
        identifiers:
            (json['identifiers'] != null && '${json['identifiers']}' != '[]')
                // ignore: avoid_as
                ? (json['identifiers'] as List)
                    .map((i) => _ImageIdentifierItem.fromJson(i))
                    .toList()
                : [],
      );

  final String? artifact;
  final String? authorizationMethod;
  final List<_ImageIdentifierItem>? identifiers;
}

/// Main type of image, will contain URL for image related to user
class _ImageIdentifierItem {
  _ImageIdentifierItem({
    this.identifier,
    this.index,
    this.mediaType,
    this.file,
    this.identifierType,
    this.identifierExpiresInSeconds,
  });

  /// Convert response from API to [_ImageIdentifierItem] object
  factory _ImageIdentifierItem.fromJson(Map<String, dynamic> json) =>
      _ImageIdentifierItem(
        identifier: json['identifier'],
        index: json['index'],
        mediaType: json['mediaType'],
        file: json['file'],
        identifierType: json['identifierType'],
        identifierExpiresInSeconds: json['identifierExpiresInSeconds'],
      );

  final String? identifier;
  final int? index;
  final String? mediaType;
  final String? file;
  final String? identifierType;
  final int? identifierExpiresInSeconds;
}

/// Class which is containing info about pagination for images
class _ImagePagination {
  _ImagePagination({this.count, this.start});

  /// Convert response from API to [_ImagePagination] object
  factory _ImagePagination.fromJson(Map<String, dynamic> json) =>
      _ImagePagination(
        count: json['count'],
        start: json['start'],
      );

  final int? count;
  final int? start;
}

/// Helper children subclass
class LinkedInProfileEmail {
  LinkedInProfileEmail({this.elements});

  /// Convert response from API to [LinkedInProfileEmail] object
  factory LinkedInProfileEmail.fromJson(Map<String, dynamic> json) =>
      LinkedInProfileEmail(
        elements: (json['elements'] != null && '${json['elements']}' != '[]')
            // ignore: avoid_as
            ? (json['elements'] as List)
                .map((i) => LinkedInDeepEmail.fromJson(i))
                .toList()
            : [],
      );

  List<LinkedInDeepEmail>? elements;
}

/// Helper children subclass
class LinkedInDeepEmail {
  LinkedInDeepEmail({this.handle, this.handleDeep});

  /// Convert response from API to [LinkedInDeepEmail] object
  factory LinkedInDeepEmail.fromJson(Map<String, dynamic> json) =>
      LinkedInDeepEmail(
        handle: json['handle'],
        handleDeep: LinkedInDeepEmailHandle.fromJson(json['handle~']),
      );

  String? handle;
  LinkedInDeepEmailHandle? handleDeep;
}

/// Helper children subclass
class LinkedInDeepEmailHandle {
  LinkedInDeepEmailHandle({this.emailAddress});

  /// Convert response from API to [LinkedInDeepEmailHandle] object
  factory LinkedInDeepEmailHandle.fromJson(Map<String, dynamic> json) =>
      LinkedInDeepEmailHandle(
        emailAddress: json['emailAddress'],
      );

  String? emailAddress;
}
