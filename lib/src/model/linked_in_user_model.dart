import 'package:linkedin_login/src/wrappers/linked_in_token_object.dart';

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

  final String? name;
  final String? familyName;
  final String? givenName;
  final bool? isEmailVerified;
  final String? sub;
  final String? email;
  final String? picture;
  final LinkedInPreferredLocal? locale;
}

class EnrichedUser extends LinkedInUser {
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

  final LinkedInTokenObject token;
}

class LinkedInUserModel extends LinkedInUser {
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

/// Helper children subclass
class LinkedInPreferredLocal {
  LinkedInPreferredLocal({this.country, this.language});

  /// Convert response from API to [LinkedInPreferredLocal] object
  factory LinkedInPreferredLocal.fromJson(final Map<String, dynamic> json) =>
      LinkedInPreferredLocal(
        country: json['country'],
        language: json['language'],
      );

  final String? country;
  final String? language;
}
