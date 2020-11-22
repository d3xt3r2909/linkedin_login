import 'package:flutter/material.dart';
import 'package:linkedin_login/src/DAL/api/linked_in_api.dart';
import 'package:linkedin_login/src/model/linked_in_user_model.dart';
import 'package:linkedin_login/src/wrappers/linked_in_token_object.dart';
import 'package:logging/logging.dart';

class UserRepository {
  UserRepository({
    @required this.api,
  }) : assert(api != null);

  final Logger log = Logger('UserRepository');
  final LinkedInApi api;

  Future<LinkedInUserModel> fetchFullProfile({
    @required LinkedInTokenObject token,
  }) async {
    log.fine('Fetching user profile');

    final basicUserProfile = await api.fetchProfile(token: token.accessToken);
    final userEmail = await api.fetchEmail(token: token.accessToken);

    basicUserProfile.email = userEmail;
    basicUserProfile.token = token;

    return basicUserProfile;
  }
}
