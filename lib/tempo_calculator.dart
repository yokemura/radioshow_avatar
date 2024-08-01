class TempoCalculator {
  static const int _maxTap = 10;
  static const double _minBpm = 60;
  static const double _maxBpm = 200;
  static const double _maxBpmDiff = 15;
  static const int _minNumTaps = 3;

  Duration currentDuration = _minBpm.toDuration;
  final List<DateTime> _taps = [];

  // 履歴を追加してタイマーの間隔を返す。
  Duration addTap(DateTime newTime) {
    if (_taps.length >= _minNumTaps) {
      // 十分な履歴数あり
      final averageDuration = _taps.averageDuration;
      // 前回との差分計算（＆単独bpm換算）
      final diff = newTime.difference(_taps.last).inBpm;
      final diffFromAve = (averageDuration.inBpm - diff).abs();

      if (diff < _minBpm || diff > _maxBpm || diffFromAve > _maxBpmDiff) {
        // 範囲外
        // 履歴クリア
        _taps.clear();
        // 既存bpmでタイマー再セットさせる
        return currentDuration;
      } else {
        // 範囲内
        // 履歴更新
        _addAndRetireTap(newTime);
        // 新しい履歴からbpm換算、タイマー再セットさせる
        return _taps.averageDuration;
      }
    } else {
      // 十分な履歴数なし
      // 履歴追加
      _addAndRetireTap(newTime);
      // 既存bpmでタイマー再セット
      return currentDuration;
    }
  }

  void _addAndRetireTap(DateTime newDate) {
    _taps.add(newDate);
    if (_taps.length > _maxTap) {
      _taps.removeAt(0);
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
