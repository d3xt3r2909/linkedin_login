import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linkedin_login/src/DAL/api/endpoint.dart';
import 'package:linkedin_login/src/model/linked_in_user_model.dart';
import 'package:linkedin_login/src/utils/logger.dart';
import 'package:linkedin_login/src/wrappers/linked_in_token_object.dart';
import 'package:meta/meta.dart';
import 'exceptions.dart';

class LinkedInApi {
  factory LinkedInApi(Endpoint endpoint) => LinkedInApi._(endpoint);

  LinkedInApi._(this._endpoint);

  @visibleForTesting
  factory LinkedInApi.test(Endpoint endpoint) {
    return LinkedInApi._(endpoint);
  }

  final Endpoint _endpoint;

  Uri _generateEndpoint(
    EnvironmentAccess setup,
    String path, [
    Map<String, String> queryParameters,
  ]) =>
      _endpoint.generate(
        setup,
        path,
        queryParameters,
      );

  Future<LinkedInTokenObject> login({
    @required String redirectUrl,
    @required String authCode,
    @required String clientSecret,
    @required String clientId,
    @required http.Client client,
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

  String takeUrl(String value) {
    return value.split('?').first;
  }

  Future<LinkedInUserModel> fetchProfile({
    @required String token,
    @required List<String> projection,
    @required http.Client client,
  }) async {
    assert(client != null);

    log('LinkedInAuth-steps: trying to fetchProfile...');

    final projectionParameter = 'projection=(${projection.join(",")})';
    final endpoint = _generateEndpoint(
      EnvironmentAccess.profile,
      'me?$projectionParameter',
    );

    log('LinkedInAuth-steps: trying to fetchProfile on ${endpoint.toString()}');

    final response = await _get(endpoint, token, client);

    log('LinkedInAuth-steps: trying to fetchProfile DONE');

    return LinkedInUserModel.fromJson(response);
  }

  Future<LinkedInProfileEmail> fetchEmail({
    @required String token,
    @required http.Client client,
  }) async {
    assert(token != null);
    log('LinkedInAuth-steps: trying to fetchEmail...');

    final endpoint = _generateEndpoint(
      EnvironmentAccess.profile,
      'emailAddress?q=members&projection=(elements*(handle~))',
    );

    log('LinkedInAuth-steps: trying to fetchEmail on ${endpoint.toString()}');

    final response = await _get(endpoint, token, client);

    log('LinkedInAuth-steps: trying to fetchEmail DONE');

    return LinkedInProfileEmail.fromJson(response);
  }

  Future<dynamic> _get(
    Uri url,
    String token,
    http.Client client,
  ) async {
    assert(url != null);
    assert(token != null);
    assert(token.isNotEmpty);

    final headers = {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response = await client.get(url, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return Future.error(
        Exception(
          "Unable to GET '$url'. Got ${response.statusCode} and '${response.body}'",
        ),
      );
    }

    return json.decode(response.body);
  }

  Future<http.Response> _postWithResponse(
    Uri url,
    http.Client client,
    dynamic body,
  ) async {
    final response = await _fetchPostResponse(
      url,
      client,
      body,
    );

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
    Uri url,
    http.Client client,
    dynamic body,
  ) async {
    assert(url != null);

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      HttpHeaders.acceptHeader: 'application/json',
    };

    return client.post(url, body: body, headers: headers);
  }
}
