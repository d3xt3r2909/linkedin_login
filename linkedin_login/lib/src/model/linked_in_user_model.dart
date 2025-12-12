import 'package:linkedin_login/src/wrappers/linked_in_token_object.dart';

/// Base class representing a LinkedIn user's profile information.
///
/// This abstract class contains the basic user information returned from
/// the LinkedIn API, including name, email, and profile picture.
abstract class LinkedInUser {
  const LinkedInUser({
    required this.name,
    required this.familyName,
    required this.givenName,
    required this.isEmailVerified,
    required this.sub,
    required this.email,
    required this.picture,
    required this.locale,
  });

  /// The user's full name.
  final String? name;

  /// The user's family name (last name).
  final String? familyName;

  /// The user's given name (first name).
  final String? givenName;

  /// Whether the user's email address has been verified by LinkedIn.
  final bool? isEmailVerified;

  /// The unique identifier (subject) for the user.
  final String? sub;

  /// The user's email address.
  final String? email;

  /// URL to the user's profile picture.
  final String? picture;

  /// The user's preferred locale settings.
  final LinkedInPreferredLocal? locale;
}

/// A LinkedIn user with an associated access token.
///
/// This class extends [LinkedInUser] and includes the access token needed
/// to make authenticated API requests on behalf of the user.
class EnrichedUser extends LinkedInUser {
  /// Creates an [EnrichedUser] from a [LinkedInUser] and an access token.
  ///
  /// [user] is the base user information.
  /// [token] is the access token associated with this user.
  EnrichedUser({
    required final LinkedInUser user,
    required this.token,
  }) : super(
          sub: user.sub,
          picture: user.picture,
          name: user.name,
          familyName: user.familyName,
          isEmailVerified: user.isEmailVerified,
          givenName: user.givenName,
          email: user.email,
          locale: user.locale,
        );

  /// The access token associated with this user.
  final LinkedInTokenObject token;
}

/// A concrete implementation of [LinkedInUser] created from JSON data.
///
/// This class represents a LinkedIn user profile parsed from the API response.
class LinkedInUserModel extends LinkedInUser {
  /// Creates a [LinkedInUserModel] with the provided user information.
  const LinkedInUserModel({
    required super.name,
    required super.familyName,
    required super.givenName,
    required super.isEmailVerified,
    required super.sub,
    required super.email,
    required super.picture,
    required super.locale,
  }) : super();

  /// Creates a [LinkedInUserModel] from a JSON map.
  ///
  /// [json] should contain the user data returned from the LinkedIn API.
  factory LinkedInUserModel.fromJson(final Map<String, dynamic> json) {
    final name = json['name'] as String?;
    final familyName = json['family_name'] as String?;
    final givenName = json['given_name'] as String?;
    final isEmailVerified = json['email_verified'] as bool?;
    final sub = json['sub'] as String?;
    final email = json['email'] as String?;
    final picture = json['picture'] as String?;
    final locale = json['locale'] == null
        ? null
        : LinkedInPreferredLocal.fromJson(json['locale']);

    return LinkedInUserModel(
      email: email,
      givenName: givenName,
      isEmailVerified: isEmailVerified,
      familyName: familyName,
      name: name,
      picture: picture,
      sub: sub,
      locale: locale,
    );
  }
}

/// Represents the user's preferred locale settings.
///
/// Contains the country and language preferences for the LinkedIn user.
class LinkedInPreferredLocal {
  /// Creates a [LinkedInPreferredLocal] with the provided values.
  LinkedInPreferredLocal({this.country, this.language});

  /// Creates a [LinkedInPreferredLocal] from a JSON map.
  ///
  /// [json] should contain 'country' and 'language' keys.
  factory LinkedInPreferredLocal.fromJson(final Map<String, dynamic> json) =>
      LinkedInPreferredLocal(
        country: json['country'],
        language: json['language'],
      );

  /// The user's country code (e.g., 'US', 'GB').
  final String? country;

  /// The user's language code (e.g., 'en', 'fr').
  final String? language;
}
