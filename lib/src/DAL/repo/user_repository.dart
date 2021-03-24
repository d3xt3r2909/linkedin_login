import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/model/linked_in_user_model.dart';
import 'package:linkedin_login/src/utils/logger.dart';
import 'package:linkedin_login/src/wrappers/linked_in_token_object.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  UserRepository({
    required this.api,
  });

  final LinkedInApi api;

  Future<LinkedInUserModel> fetchFullProfile({
    required LinkedInTokenObject token,
    required List<String> projection,
    required http.Client client,
  }) async {
    log('Fetching user profile');

    final basicUserProfile = await api.fetchProfile(
      token: token.accessToken,
      projection: projection,
      client: client,
    );
    final userEmail = await api.fetchEmail(
      client: client,
      token: token.accessToken,
    );

    basicUserProfile
      ..email = userEmail
      ..token = token;

    return basicUserProfile;
  }
}
