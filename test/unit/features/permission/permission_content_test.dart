import 'dart:convert';
import 'dart:io';

import 'package:flutter_all_template/features/permission/domain/entities/app_permission.dart';
import 'package:flutter_all_template/features/permission/presentation/helpers/permission_content.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Map<String, dynamic> translations;

  setUpAll(() {
    final json = File('assets/translations/en-GB.json').readAsStringSync();
    translations = jsonDecode(json) as Map<String, dynamic>;
  });

  /// Resolves a dotted key such as `features.permission.camera.title`.
  Object? lookup(String key) {
    Object? node = translations;
    for (final part in key.split('.')) {
      node = node is Map<String, dynamic> ? node[part] : null;
    }
    return node;
  }

  test('every permission has its four texts in the translations', () {
    for (final permission in AppPermission.values) {
      for (final key in [
        permission.titleKey,
        permission.messageKey,
        permission.reAskTitleKey,
        permission.reAskMessageKey,
      ]) {
        expect(lookup(key), isA<String>(), reason: 'missing key $key');
      }
    }
  });

  test('keys are semantic, not file paths', () {
    expect(AppPermission.camera.titleKey, 'features.permission.camera.title');
    expect(
      AppPermission.activityRecognition.reAskMessageKey,
      'features.permission.activityRecognition.reAskMessage',
    );
  });
}
