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

  test('total calculation', () {
    final calculator = TempoCalculator();
    DateTime time = DateTime(2024, 12, 31, 0, 0);
    Duration res = calculator.addTap(time);
    expect(res, const Duration(seconds: 1)); // デフォルト

    time = time.add(const Duration(milliseconds: 500));
    res = calculator.addTap(time);
    expect(calculator.taps.length, 2);
    expect(res, const Duration(seconds: 1)); // まだデフォルト

    time = time.add(const Duration(milliseconds: 500));
    res = calculator.addTap(time);
    expect(calculator.taps.length, 3);
    expect(res, const Duration(milliseconds: 500)); // 平均計算が始まる

    time = time.add(const Duration(milliseconds: 500));
    res = calculator.addTap(time);
    expect(calculator.taps.length, 4);
    expect(res, const Duration(milliseconds: 500)); // 平均値を維持

    time = time.add(const Duration(seconds: 2)); // 間が空いた
    res = calculator.addTap(time);
    expect(calculator.taps.length, 1); // 履歴クリア
    expect(res, const Duration(seconds: 1)); // Durationもリセット

    time = time.add(const Duration(milliseconds: 750)); // 新しいテンポ
    res = calculator.addTap(time);
    expect(calculator.taps.length, 2);
    expect(res, const Duration(seconds: 1)); // 維持

    time = time.add(const Duration(milliseconds: 750)); // 新しいテンポ・3発目
    res = calculator.addTap(time);
    expect(calculator.taps.length, 3);
    expect(res, const Duration(milliseconds: 750)); // 新しいDuration

  });
}