import 'package:linkedin_login/redux/actions.dart';
import 'package:test/test.dart';


void main() {
  test('Test toString method', () async {
    final action = TestLinkedInAction();

    expect(action.toString(), action.runtimeType.toString());
  });
}
