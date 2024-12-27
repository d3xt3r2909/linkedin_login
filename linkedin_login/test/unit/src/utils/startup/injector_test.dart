import 'package:flutter/material.dart';
import 'package:linkedin_login/src/utils/startup/injector.dart';
import 'package:test/test.dart';

import '../../../utils/shared_mocks.mocks.dart';

void main() {
  test('is created with updateShouldNotify to be false', () async {
    final inject = InjectorWidget(
      graph: MockGraph(),
      child: Container(),
    );

    expect(inject.updateShouldNotify(inject), isFalse);
  });
}
