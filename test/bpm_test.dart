import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:radioshow_avatar/tempo_calculator.dart';

void main() {
  test('duration conversion', () {
    const dur = Duration(milliseconds: 500);
    final bpm = dur.inBpm;
    expect(bpm, 120);

    const dur2 = Duration(milliseconds: 250);
    final bpm2 = dur2.inBpm;
    expect(bpm2, 240);
  });

  test('avarage duration', () {
    final time1 = DateTime(2024, 12, 31, 0, 0);
    final time2 = DateTime(2024, 12, 31, 0, 1);
    final time3 = DateTime(2024, 12, 31, 0, 2);
    final list = [time1, time2, time3];
    expect(list.averageDuration, const Duration(minutes: 1));

    final time4 = DateTime(2024, 12, 31, 0, 3);
    final list2 = [time1, time2, time4];
    expect(list2.averageDuration, const Duration(seconds: 90));
  });
}