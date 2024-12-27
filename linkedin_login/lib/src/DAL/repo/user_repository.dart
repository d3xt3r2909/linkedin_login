import 'package:http/http.dart' as http;
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/model/linked_in_user_model.dart';
import 'package:linkedin_login/src/utils/logger.dart';
import 'package:linkedin_login/src/wrappers/linked_in_token_object.dart';

class UserRepository {
  UserRepository({
    required this.api,
  });

  final LinkedInApi api;

  /// This method is using new api from Linkedin
  /// and requires OpenId scope at least, as success response
  /// will return users available data
  Future<LinkedInUserModel> fetchProfile({
    required final LinkedInTokenObject token,
    required final http.Client client,
  }) async {
    log('Fetching user profile');

    final profile = await api.fetchUserInfo(
      client: client,
      token: token.accessToken,
    );

    return profile;
  }
}
