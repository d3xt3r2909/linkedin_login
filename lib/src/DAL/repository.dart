import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/src/utils/session.dart';
import 'package:linkedin_login/src/wrappers/authorization_code_response.dart';
import 'package:linkedin_login/src/wrappers/linked_in_error_object.dart';
import 'package:linkedin_login/src/wrappers/linked_in_token_object.dart';
import 'package:linkedin_login/src/utils/constants.dart';

abstract class LinkedInFetcher {
  LinkedInFetcher({
    @required this.redirectUrl,
    @required this.clientId,
  })  : assert(redirectUrl != null),
        assert(clientId != null);

  Future<AuthorizationCodeResponse> fetchWithAccessTokenCode({
    String clientSecret,
  });

  Future<AuthorizationCodeResponse> fetchWithAuthCode();

  final String redirectUrl;
  final String clientId;
}

class LinkedInRepository extends LinkedInFetcher {
  LinkedInRepository({
    @required String redirectionUrl,
    @required String clientId,
  }) : super(
          redirectUrl: redirectionUrl,
          clientId: clientId,
        );

  @override
  Future<AuthorizationCodeResponse> fetchWithAccessTokenCode({
    @required String clientSecret,
  }) async {
    try {
      return await _getAuthorizationWithAccessToken(
        authorizationCode: _getAuthorizationCode(),
        clientSecret: clientSecret,
      );
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<AuthorizationCodeResponse> fetchWithAuthCode() {
    return Future.value(_getAuthorizationCode());
  }

  /// Method will parse redirection URL to get authorization code from
  /// query parameters. If there is an error property inside
  /// [AuthorizationCodeResponse] object will be populate
  AuthorizationCodeResponse _getAuthorizationCode() {
    AuthorizationCodeResponse response;
    final List<String> parseUrl = redirectUrl.split('?');

    if (parseUrl.isNotEmpty) {
      final List<String> queryPart = parseUrl.last.split('&');

      if (queryPart.isNotEmpty && queryPart.first.startsWith('code')) {
        final List<String> codePart = queryPart.first.split('=');
        final List<String> statePart = queryPart.last.split('=');

        if (statePart[1] == Session.clientState) {
          response = AuthorizationCodeResponse(
            code: codePart[1],
            state: statePart[1],
          );
        } else {
          throw Exception(
            'State code is not valid: ${statePart[1]}, expected ${Session.clientState}',
          );
        }
      } else if (queryPart.isNotEmpty && queryPart.first.startsWith('error')) {
        response = AuthorizationCodeResponse(
          error: LinkedInErrorObject(
            statusCode: HttpStatus.unauthorized,
            description: queryPart[1].split('=')[1].replaceAll('+', ' '),
          ),
          state: queryPart[2].split('=')[1],
        );
      }
    }

    return response;
  }

  /// Method that will retrieve authorization code
  /// After auth code is received you can call API service to get access token
  /// from linkedIn
  /// If error happens it will be saved into [error] property of result object
  Future<AuthorizationCodeResponse> _getAuthorizationWithAccessToken({
    @required AuthorizationCodeResponse authorizationCode,
    @required String clientSecret,
  }) async {
    // get access token based on code
    if (authorizationCode.code != null && authorizationCode.code.isNotEmpty) {
      final LinkedInTokenObject tokenObject =
          await _getAccessToken(authorizationCode, clientSecret);

      if (tokenObject.isSuccess) {
        authorizationCode.accessToken = tokenObject;
      } else {
        authorizationCode.errorObject = tokenObject.error;
      }
    }

    return authorizationCode;
  }

  /// Method for getting token object for current user
  /// This method will return you token & expiration time for that token
  Future<LinkedInTokenObject> _getAccessToken(
    AuthorizationCodeResponse codeDetails,
    String clientSecret,
  ) async {
    final Map<String, dynamic> body = {
      'grant_type': 'authorization_code',
      'code': codeDetails.code,
      'redirect_uri': redirectUrl.split('/?')[0],
      'client_id': clientId,
      'client_secret': clientSecret,
    };

    print("::> _getAuthorizationWithAccessToken ${authorizationCode.code} || ${clientSecret}");


    final response = await post(
      UrlAccessPoint.URL_LINKED_IN_GET_ACCESS_TOKEN,
      body: body,
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
      },
      encoding: Encoding.getByName('utf-8'),
    );

    if (response.statusCode == HttpStatus.ok) {
      return LinkedInTokenObject(
        accessToken: json.decode(response.body)['access_token'].toString(),
        expiresIn: json.decode(response.body)['expires_in'],
      );
    } else {
      return LinkedInTokenObject(
        error: LinkedInErrorObject(
          description: 'Failed to get token',
          statusCode: response.statusCode,
        ),
      );
    }
  }
}

abstract class LinkedInUserRepository {
  Future<LinkedInUserModel> fetchFullLinkedInUserProfile();
}

class LinkedInUserRepositoryImpl implements LinkedInUserRepository {
  LinkedInUserRepositoryImpl(this.token) : assert(token != null);
  LinkedInTokenObject token;

  @override
  Future<LinkedInUserModel> fetchFullLinkedInUserProfile() async {
    final basicUserProfile = await _fetchUserProfile(token);
    final userEmail = await _fetchUserEmail(token);
    final linkedInUser = LinkedInUserModel.fromJson(
      json.decode(basicUserProfile),
    );

    // @TODO can be refactored with copyWith
    linkedInUser.email = LinkedInProfileEmail.fromJson(json.decode(userEmail));
    linkedInUser.token = token;

    return linkedInUser;
  }

  // @TODO move to API
  Future<String> _fetchUserProfile(LinkedInTokenObject token) async {
    final result = await get(
      _urlLinkedInUserProfile,
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
      },
    );

    return result.body;
  }

  // @TODO move to API
  Future<String> _fetchUserEmail(LinkedInTokenObject token) async {
    final result = await get(
      _urlLinkedInEmailAddress,
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
      },
    );

    return result.body;
  }

  // @TODO move to API
  String get _urlLinkedInUserProfile => 'https://api.linkedin.com/v2/me';

  // @TODO move to API
  String get _urlLinkedInEmailAddress =>
      'https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))';
}
