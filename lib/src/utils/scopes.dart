/// Scopes define what your app can do on a user's behalf.
enum Scopes {
  /// Retrieve your advertising accounts
  readAds('r_ads'),

  /// Retrieve reporting for your advertising accounts
  readAdsReporting('r_ads_reporting'),

  /// Manage your advertising accounts
  readWriteAds('rw_ads'),

  /// Use your name and photo
  readLiteProfile('r_liteprofile'),

  /// Use your basic profile including your name, photo, headline,
  /// and public profile URL
  readBasicProfile('r_basicprofile'),

  /// Use the primary email address associated with your LinkedIn account
  readEmailAddress('r_emailaddress'),

  /// Retrieve your organization's posts,
  /// comments, reactions, and other engagement data
  readOrganizationSocial('r_organization_social'),

  /// Create, modify, and delete posts, comments, and reactions
  /// on your organization's behalf
  writeOrganizationSocial('w_organization_social'),

  /// Retrieve your organization's pages and their reporting
  /// data (including follower, visitor and content analytics)
  readOrganizationAdmin('r_organization_admin'),

  /// Manage your organization's pages and retrieve reporting data
  readWriteOrganizationAdmin('rw_organization_admin'),

  /// Create, modify, and delete posts, comments, and reactions on your behalf
  writeMemberSocial('w_member_social'),

  /// Use your 1st-degree connections' data
  readFirstConnectionSize('r_1st_connections_size');

  const Scopes(this.value);

  final String value;
}
