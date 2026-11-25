import 'package:flutter/material.dart';
import 'package:flutter_all_template/config/constants/locales/app_locales.dart';
import 'package:flutter_all_template/core/common/data/models/helpers/model_annotation_helper.dart';
import 'package:flutter_all_template/core/common/data/models/helpers/model_conversion_helper.dart';
import 'package:flutter_all_template/core/common/domain/entities/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  group('LocaleConverter', () {
    const converter = LocaleConverter();

    test('round-trips language and country code', () {
      for (final locale in const [
        Locale('en', 'GB'),
        Locale('en', 'US'),
        Locale('ne', 'NP'),
        Locale('fr'),
      ]) {
        expect(converter.fromJson(converter.toJson(locale)), locale);
      }
    });

    test('reads legacy underscore values and null', () {
      expect(converter.fromJson('en_US'), const Locale('en', 'US'));
      expect(converter.toJson(const Locale('en', 'GB')), 'en-GB');
      expect(converter.fromJson(null), AppLocales.en);
    });
  });

  group('TimeOfDayConverter', () {
    const converter = TimeOfDayConverter();

    test('round-trips as zero-padded HH:mm', () {
      const time = TimeOfDay(hour: 7, minute: 5);
      expect(converter.toJson(time), '07:05');
      expect(converter.fromJson('07:05'), time);
      expect(converter.fromJson('7:5'), time);
    });

    test('rejects malformed values', () {
      expect(() => converter.fromJson('0705'), throwsFormatException);
    });
  });

  group('ResultFuture extensions', () {
    const failure = Failure(message: 'x');

    test('mapModelToEntity / mapModelListToEntityList / rightOrNull', () async {
      expect(
        await Future.value(
          const Right<Failure, int>(2),
        ).mapModelToEntity((m) => '$m'),
        const Right<Failure, String>('2'),
      );
      expect(
        await Future.value(
          const Right<Failure, List<int>>([1, 2]),
        ).mapModelListToEntityList((m) => m * 10),
        isA<Right<Failure, List<int>>>().having((r) => r.value, 'value', [
          10,
          20,
        ]),
      );
      expect(
        await Future.value(const Left<Failure, int>(failure)).rightOrNull,
        isNull,
      );
      expect(await Future.value(const Right<Failure, int>(1)).rightOrNull, 1);
    });
  });
}
