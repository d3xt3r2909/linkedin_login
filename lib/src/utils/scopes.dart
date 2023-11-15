/// Gives you ability to introduce scope whatever you think its needed.
///
/// Please have in mind that any other scope that is not inside this file is not
/// supported by json parser and most probably will not work.
/// If you want to have a new scope you should contribute to this library inside
/// lib/src/model/linked_in_user_model.dart
///
/// Reason behind this is that LinkedIn is not giving to everyone all the access
/// (scopes) and I am unable to find out what response could be for some other
/// scopes like it is w_member_social.
///
/// https://stackoverflow.com/a/57979607/6074443:
/// To gain access to r_member_social, you first need to apply to and be
/// approved for the LinkedIn Marketing Developer Program.
///
/// A bit more of context is described under this issue
/// https://github.com/d3xt3r2909/linkedin_login/issues/63#issuecomment-940696147
/// https://github.com/d3xt3r2909/linkedin_login/issues/28#issuecomment-673366607
abstract class Scope {
  const Scope(this.permission);

  final String permission;

  @override
  String toString() => permission;
}

@Deprecated('Use EmailScope instead')
class EmailAddressScope extends Scope {
  @Deprecated('Use EmailScope instead')
  const EmailAddressScope() : super('r_emailaddress');
}

@Deprecated('Use ProfileScope instead')
class LiteProfileScope extends Scope {
  @Deprecated('Use ProfileScope instead')
  const LiteProfileScope() : super('r_liteprofile');
}

class OpenIdScope extends Scope {
  const OpenIdScope() : super('openid');
}

class EmailScope extends Scope {
  const EmailScope() : super('email');
}

class ProfileScope extends Scope {
  const ProfileScope() : super('profile');
}
