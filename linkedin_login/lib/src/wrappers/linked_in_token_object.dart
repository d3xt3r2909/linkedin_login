/// When you get authorization code, you need to exchange to get access token
/// Expires in is time, when your access token will be invalid
class LinkedInTokenObject {
  LinkedInTokenObject({
    this.accessToken,
    this.expiresIn,
  });

  String? accessToken;
  int? expiresIn;
}
