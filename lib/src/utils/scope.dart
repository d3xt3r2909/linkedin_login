abstract class Scope {
  const Scope(this.permission);

  final String permission;

  @override
  String toString() => permission;
}

class EmailAddressScope extends Scope {
  const EmailAddressScope() : super('r_emailaddress');
}

class LiteProfileScope extends Scope {
  const LiteProfileScope() : super('r_liteprofile');
}

class MemberSocialScope extends Scope {
  const MemberSocialScope() : super('w_member_social');
}
