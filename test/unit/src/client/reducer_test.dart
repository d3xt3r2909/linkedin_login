import 'package:linkedin_login/linkedin_login.dart';
import 'package:linkedin_login/src/client/actions.dart';
import 'package:linkedin_login/src/client/reducer.dart';
import 'package:linkedin_login/src/client/state.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:test/test.dart';

void main() {
  LinkedInUserModel generateUser({
    String firstName = 'DexterFirst',
    String lastName = 'DexterLast',
  }) {
    return LinkedInUserModel(
      firstName: LinkedInPersonalInfo(
        localized: LinkedInLocalInfo(
          label: firstName,
        ),
        preferredLocal: LinkedInPreferredLocal(country: 'BA', language: 'bs'),
      ),
      lastName: LinkedInPersonalInfo(
        localized: LinkedInLocalInfo(
          label: lastName,
        ),
        preferredLocal: LinkedInPreferredLocal(country: 'BA', language: 'bs'),
      ),
      userId: 'id',
    );
  }

  test('triggers when user is fetched', () {
    final state = LinkedInUserState.initialState().copyWith(
      linkedInUser: generateUser(),
    );

    final affectedState = linkedInClientReducer(
      state,
      FetchLinkedInUserSucceededAction(
        generateUser(
          firstName: 'updatedFirst',
          lastName: 'updatedLast',
        ),
      ),
    );

    expect(
      affectedState.linkedInUser.firstName.localized.label,
      'updatedFirst',
    );
    expect(affectedState.linkedInUser.lastName.localized.label, 'updatedLast');
  });

  test('if there is no action in reducer return same state', () {
    final state = LinkedInUserState.initialState().copyWith(
      linkedInUser: generateUser(),
    );

    final affectedState = linkedInClientReducer(
      state,
      DirectionUrlMatchFailedAction(Exception()),
    );

    expect(
      affectedState.linkedInUser.firstName.localized.label,
      'DexterFirst',
    );
    expect(affectedState.linkedInUser.lastName.localized.label, 'DexterLast');
  });
}
