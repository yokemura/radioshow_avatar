import 'package:flutter/foundation.dart';

class TempoCalculator {
  static const int _maxTap = 10;
  static const double _minBpm = 60;
  static const double _maxBpm = 200;
  static const int _minNumTaps = 3;

  Duration currentDuration = _minBpm.toDuration;

  @visibleForTesting
  final List<DateTime> taps = [];

  // 履歴を追加してタイマーの間隔を返す。
  Duration addTap(DateTime newTime) {
    // 履歴更新
    _addAndRetireTap(newTime);

    if (taps.length >= _minNumTaps) {
      // 十分な履歴数あり
      // 前回との差分計算（＆単独bpm換算）
      final lastLast = taps[taps.length - 2];
      final diff = newTime.difference(lastLast).inBpm;

      if (diff < _minBpm || diff > _maxBpm) {
        // 範囲外
        // 履歴クリア
        taps.clear();
        taps.add(newTime);
        // 既存bpmでタイマー再セットさせる
        return currentDuration;
      } else {
        // 範囲内
        // 新しい履歴からbpm換算、タイマー再セットさせる
        currentDuration = taps.averageDuration;
        return currentDuration;
      }
    } else {
      // 十分な履歴数なし
      // 既存bpmでタイマー再セット
      return currentDuration;
    }
  }

  void _addAndRetireTap(DateTime newDate) {
    taps.add(newDate);
    if (taps.length > _maxTap) {
      taps.removeAt(0);
    }
  }
}

extension BpmConversion on Duration {
  double get inBpm => 60000000.0 / inMicroseconds.toDouble();
}

extension ToDuration on double {
  Duration get toDuration {
    final bps = this / 60.0;
    final secondsPerBeat = 1.0 / bps;
    return Duration(microseconds: (1000000 * secondsPerBeat).toInt());
  }
}

extension AvarageDuration on List<DateTime> {
  Duration get averageDuration {
    if (length < 2) {
      return Duration.zero;
    }
    int totalMicros = 0;
    for (int i = 0; i < length - 1; i++) {
      totalMicros += this[i + 1].difference(this[i]).inMicroseconds;
    }
    final average = totalMicros ~/ (length - 1);
    return Duration(microseconds: average);
  }
}
