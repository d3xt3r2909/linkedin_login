/// Currently supported projection options
class ProjectionParameters {
  static const String id = "id";
  static const String localizedLastName = "localizedLastName";
  static const String firstName = "firstName";
  static const String lastName = "lastName";
  static const String localizedFirstName = "localizedFirstName";
  static const String profilePicture =
      "profilePicture(displayImage~:playableStreams)";

  static List<String> fullProjection = const [
    id,
    localizedFirstName,
    localizedLastName,
    firstName,
    lastName,
  ];
}

bool get isUnderTest => _isUnderTest;
bool _isUnderTest = false;

/// Indicates if the system is currently under test
set isUnderTest(bool value) {
  assert(value != null);
  if (_isUnderTest == value) {
    return;
  }
  _isUnderTest = value;
}
