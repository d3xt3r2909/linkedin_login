import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:linkedin_login/src/DAL/api/endpoint.dart';
import 'package:linkedin_login/src/DAL/api/exceptions.dart';
import 'package:linkedin_login/src/model/linked_in_user_model.dart';
import 'package:linkedin_login/src/utils/logger.dart';
import 'package:linkedin_login/src/wrappers/linked_in_token_object.dart';
import 'package:meta/meta.dart';

class LinkedInApi {
  factory LinkedInApi(final Endpoint endpoint) => LinkedInApi._(endpoint);

  LinkedInApi._(this._endpoint);

  @visibleForTesting
  factory LinkedInApi.test(final Endpoint endpoint) {
    return LinkedInApi._(endpoint);
  }

  final Endpoint _endpoint;

  Uri _generateEndpoint(
    final EnvironmentAccess setup,
    final String path, [
    final Map<String, String>? queryParameters,
  ]) =>
      _endpoint.generate(
        setup,
        path,
        queryParameters,
      );

  Future<LinkedInTokenObject> login({
    required final String redirectUrl,
    required final String? authCode,
    required final String? clientSecret,
    required final String? clientId,
    required final http.Client client,
  }) async {
    log('LinkedInAuth-steps: trying to login...');

    final endpoint = _generateEndpoint(
      EnvironmentAccess.authorization,
      'accessToken',
    );

    final Map<String, dynamic> body = {
      'grant_type': 'authorization_code',
      'code': authCode,
      'redirect_uri': redirectUrl,
      'client_id': clientId,
      'client_secret': clientSecret,
    };

    log('LinkedInAuth-steps: trying to login on ${endpoint.toString()}');
    final response = await _postWithResponse(endpoint, client, body);

    final responseBody = json.decode(response.body);

    log('LinkedInAuth-steps: trying to login DONE');

    return LinkedInTokenObject(
      accessToken: responseBody['access_token'].toString(),
      expiresIn: responseBody['expires_in'],
    );
  }

  String takeUrl(final String value) {
    return value.split('?').first;
  }

  /// This method is using new api from Linkedin
  /// and requires OpenId scope at least, as success response
  /// will return users available data
  Future<LinkedInUserModel> fetchUserInfo({
    required final String? token,
    required final http.Client client,
  }) async {
    log('LinkedInAuth-steps: trying to fetch user info...');

    final endpoint = _generateEndpoint(
      EnvironmentAccess.profile,
      'userinfo',
    );

    log('LinkedInAuth-steps: trying to fetch from ${endpoint.toString()}');
    final response = await _get(endpoint, token!, client);

    log('LinkedInAuth-steps: trying to login DONE');

    return LinkedInUserModel.fromJson(response);
  }

  Future<dynamic> _get(
    final Uri url,
    final String token,
    final http.Client client,
  ) async {
    final headers = {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response = await client.get(url, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return Future.error(
        Exception(
          "Unable to GET '$url'. Got ${response.statusCode} "
          "and '${response.body}'",
        ),
      );
    }

    return json.decode(response.body);
  }

  Future<http.Response> _postWithResponse(
    final Uri url,
    final http.Client client,
    final dynamic body,
  ) async {
    final response = await _fetchPostResponse(url, client, body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return Future.error(
        HttpResponseException(
          url: url,
          statusCode: response.statusCode,
          body: response.body,
        ),
      );
    }

    return response;
  }

  Future<http.Response> _fetchPostResponse(
    final Uri url,
    final http.Client client,
    final dynamic body,
  ) async {
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      HttpHeaders.acceptHeader: 'application/json',
    };

    return client.post(url, body: body, headers: headers);
  }
}
