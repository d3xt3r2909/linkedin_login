import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/src/utils/widgets/linked_in_buttons.dart';

import '../../../widget_test_utils.dart';

void main() {
  late WidgetTestbed testbed;

  setUp(() {
    testbed = WidgetTestbed();
  });

  testWidgets('is created', (WidgetTester tester) async {
    final testWidget = testbed.simpleWrap(
      child: LinkedInButtonStandardWidget(
        onTap: () {},
      ),
    );

    await tester.pumpWidget(testWidget);
    await tester.pump();
  });

  testWidgets('is created', (WidgetTester tester) async {
    final testWidget = testbed.simpleWrap(
      child: LinkedInButtonStandardWidget(
        onTap: () {},
      ),
    );

    await tester.pumpWidget(testWidget);
    await tester.pump();
  });

  testWidgets('on tap button is tapped', (WidgetTester tester) async {
    var isTaped = false;
    final testWidget = testbed.simpleWrap(
      child: LinkedInButtonStandardWidget(
        onTap: () {
          isTaped = true;
        },
      ),
    );

    await tester.pumpWidget(testWidget);
    await tester.pump();
    await tester.tap(find.text('Sign in with LinkedIn'));

    expect(isTaped, isTrue);
  });
}
