import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/src/client/linked_in_user_widget.dart';
import 'package:linkedin_login/src/model/linked_in_user_model.dart';
import 'package:linkedin_login/src/utils/constants.dart';
import 'package:linkedin_login/src/utils/widgets/linked_in_buttons.dart';

import '../../../widget_test_utils.dart';

void main() {
  WidgetTestbed testbed;

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
