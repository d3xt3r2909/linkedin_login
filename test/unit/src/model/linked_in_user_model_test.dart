import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_login/linkedin_login.dart';

void main() {
  group('Tests for _getFirstInListFromJson method', () {
    test('If json is null, return null', () {
      expect(getFirstInListFromJson(null), null);
    });

    test('If json is empty, return null', () {
      expect(getFirstInListFromJson({}), null);
    });

    test('If json is contains int type as value, return null', () {
      expect(getFirstInListFromJson({'local': 23}), null);
    });

    test('If json is contains English local, return the en_US code', () {
      expect(getFirstInListFromJson({'local': 'en_US'}), 'en_US');
    });

    test('If json is contains Spanish local, return the es_ES code', () {
      expect(getFirstInListFromJson({'local': 'es_ES'}), 'es_ES');
    });
  });
}
