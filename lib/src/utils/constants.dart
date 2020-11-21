/// Currently supported projection options
class ProjectionParameters {
  static const String id = "id";
  static const String localizedLastName = "localizedLastName";
  static const String firstName = "firstName";
  static const String lastName = "lastName";
  static const String localizedFirstName = "localizedFirstName";
  static const String profilePicture =
      "profilePicture(displayImage~:playableStreams)";
}

/// Class contains static variables which are containing URLs for oAuth
class UrlAccessPoint {
  static const String URL_LINKED_IN_GET_ACCESS_TOKEN =
      'https://www.linkedin.com/oauth/v2/accessToken';
  static const String URL_LINKED_IN_GET_AUTH_TOKEN =
      'https://www.linkedin.com/oauth/v2/authorization';
}
