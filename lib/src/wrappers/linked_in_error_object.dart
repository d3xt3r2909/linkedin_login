import 'package:flutter/material.dart';

/// This class contains error information
@deprecated
class LinkedInErrorObject {
  String description;
  int statusCode;

  LinkedInErrorObject({
    @required this.description,
    @required this.statusCode,
  });
}
