import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:linkedin_login/src/DAL/api/endpoint.dart';
import 'package:linkedin_login/src/model/linked_in_user_model.dart';
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

  Uri _generateEndpoint(EnvironmentAccess setup, String path,
      [Map<String, String> queryParameters]) {
    return _endpoint.generate(setup, path, queryParameters);
  }

  Future<LinkedInTokenObject> login({
    @required String redirectUrl,
    @required String authCode,
    @required String clientSecret,
    @required String clientId,
  }) async {
    final endpoint =
        _generateEndpoint(EnvironmentAccess.authorization, 'accessToken');

    final Map<String, dynamic> body = {
      'grant_type': 'authorization_code',
      'code': authCode,
      'redirect_uri': redirectUrl,
      'client_id': clientId,
      'client_secret': clientSecret,
    };

    final response = await _postWithResponse(
      endpoint,
      body,
    );

    final responseBody = json.decode(response.body);

    return LinkedInTokenObject(
      accessToken: responseBody['access_token'].toString(),
      expiresIn: responseBody['expires_in'],
    );
  }

  Future<LinkedInUserModel> fetchProfile({
    @required String token,
    @required List<String> projection,
  }) async {
    final projectionParameter = 'projection=(${projection.join(",")})';
    final endpoint = _generateEndpoint(EnvironmentAccess.profile, 'me?$projectionParameter');

    final response = await _get(endpoint, token);

    return LinkedInUserModel.fromJson(response);
  }

  Future<LinkedInProfileEmail> fetchEmail({
    @required String token,
  }) async {
    assert(token != null);

    final endpoint = _generateEndpoint(EnvironmentAccess.profile,
        'emailAddress?q=members&projection=(elements*(handle~))');

    final response = await _get(endpoint, token);

    return LinkedInProfileEmail.fromJson(response);
  }

  Future<dynamic> _get(Uri url, String token) async {
    assert(url != null);
    assert(token != null);
    assert(token.isNotEmpty);

    var headers = {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response = await get(url, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return Future.error(Exception(
          "Unable to GET '$url'. Got ${response.statusCode} and '${response.body}'"));
    }

    return json.decode(response.body);
  }

  Future<http.Response> _postWithResponse(
    Uri url,
    dynamic body, {
    String token,
  }) async {
    final response = await _fetchPostResponse(
      url,
      body,
      token: token,
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
    dynamic body, {
    String token,
  }) async {
    assert(url != null);

    var headers = {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      HttpHeaders.acceptHeader: 'application/json',
    };

    if (token != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    return http.post(url, body: body, headers: headers);
  }
}
