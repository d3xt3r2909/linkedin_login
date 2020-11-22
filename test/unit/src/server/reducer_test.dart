import 'package:linkedin_login/src/server/actions.dart';
import 'package:linkedin_login/src/server/reducer.dart';
import 'package:linkedin_login/src/server/state.dart';
import 'package:linkedin_login/src/webview/actions.dart';
import 'package:linkedin_login/src/wrappers/authorization_code_response.dart';
import 'package:test/test.dart';

void main() {
  test('triggers when user fetches auth code without access token', () {
    final state = UserAuthCodeState.initialState().copyWith(
      userAuthCode: AuthorizationCodeResponse(
        code: 'initialCode',
        state: 'initialState',
      ),
    );

    final affectedState = linkedInServerReducer(
      state,
      FetchAuthCodeSucceededAction(
        AuthorizationCodeResponse(
          code: 'changedValueCode',
          state: 'changedValueState',
        ),
      ),
    );

    expect(affectedState.userAuthCode.code, 'changedValueCode');
    expect(affectedState.userAuthCode.state, 'changedValueState');
  });

  test('if action is not in this reducer return same state', () {
    final state = UserAuthCodeState.initialState().copyWith(
      userAuthCode: AuthorizationCodeResponse(
        code: 'initialCode',
        state: 'initialState',
      ),
    );

    final affectedState = linkedInServerReducer(
      state,
      DirectionUrlMatchFailedAction(Exception()),
    );

    expect(affectedState.userAuthCode.code, 'initialCode');
    expect(affectedState.userAuthCode.state, 'initialState');
  });
}
