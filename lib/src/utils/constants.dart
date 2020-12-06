// ignore_for_file: avoid_classes_with_only_static_members
/// Currently supported projection options
class ProjectionParameters {
  static const String id = 'id';
  static const String localizedLastName = 'localizedLastName';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String localizedFirstName = 'localizedFirstName';
  static const String profilePicture =
      'profilePicture(displayImage~:playableStreams)';

  static List<String> projectionWithoutPicture = const [
    id,
    localizedFirstName,
    localizedLastName,
    firstName,
    lastName,
  ];

  static List<String> fullProjection = const [
    id,
    localizedFirstName,
    localizedLastName,
    firstName,
    lastName,
    profilePicture,
  ];
}
