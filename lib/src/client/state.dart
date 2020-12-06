import 'package:linkedin_login/src/model/linked_in_user_model.dart';
import 'package:meta/meta.dart';

@immutable
class LinkedInUserState {
  const LinkedInUserState({
    @required this.linkedInUser,
  }) : assert(linkedInUser != null);

  const LinkedInUserState.initialState() : linkedInUser = null;

  final LinkedInUserModel linkedInUser;

  LinkedInUserState copyWith({
    LinkedInUserModel linkedInUser,
  }) {
    return LinkedInUserState(
      linkedInUser: linkedInUser ?? this.linkedInUser,
    );
  }
}
