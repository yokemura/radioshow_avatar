// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_level_setting_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AudioLevelSettingViewState {
  AudioLevelSettingProcess get process => throw _privateConstructorUsedError;
  List<double> get recordedLevels => throw _privateConstructorUsedError;
  DateTime? get recordingFinishTime => throw _privateConstructorUsedError;
  double? get lowerLevel => throw _privateConstructorUsedError;
  double? get upperLevel => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AudioLevelSettingViewStateCopyWith<AudioLevelSettingViewState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudioLevelSettingViewStateCopyWith<$Res> {
  factory $AudioLevelSettingViewStateCopyWith(AudioLevelSettingViewState value,
          $Res Function(AudioLevelSettingViewState) then) =
      _$AudioLevelSettingViewStateCopyWithImpl<$Res,
          AudioLevelSettingViewState>;
  @useResult
  $Res call(
      {AudioLevelSettingProcess process,
      List<double> recordedLevels,
      DateTime? recordingFinishTime,
      double? lowerLevel,
      double? upperLevel});
}

/// @nodoc
class _$AudioLevelSettingViewStateCopyWithImpl<$Res,
        $Val extends AudioLevelSettingViewState>
    implements $AudioLevelSettingViewStateCopyWith<$Res> {
  _$AudioLevelSettingViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? process = null,
    Object? recordedLevels = null,
    Object? recordingFinishTime = freezed,
    Object? lowerLevel = freezed,
    Object? upperLevel = freezed,
  }) {
    return _then(_value.copyWith(
      process: null == process
          ? _value.process
          : process // ignore: cast_nullable_to_non_nullable
              as AudioLevelSettingProcess,
      recordedLevels: null == recordedLevels
          ? _value.recordedLevels
          : recordedLevels // ignore: cast_nullable_to_non_nullable
              as List<double>,
      recordingFinishTime: freezed == recordingFinishTime
          ? _value.recordingFinishTime
          : recordingFinishTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lowerLevel: freezed == lowerLevel
          ? _value.lowerLevel
          : lowerLevel // ignore: cast_nullable_to_non_nullable
              as double?,
      upperLevel: freezed == upperLevel
          ? _value.upperLevel
          : upperLevel // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AudioLevelSettingViewStateImplCopyWith<$Res>
    implements $AudioLevelSettingViewStateCopyWith<$Res> {
  factory _$$AudioLevelSettingViewStateImplCopyWith(
          _$AudioLevelSettingViewStateImpl value,
          $Res Function(_$AudioLevelSettingViewStateImpl) then) =
      __$$AudioLevelSettingViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AudioLevelSettingProcess process,
      List<double> recordedLevels,
      DateTime? recordingFinishTime,
      double? lowerLevel,
      double? upperLevel});
}

/// @nodoc
class __$$AudioLevelSettingViewStateImplCopyWithImpl<$Res>
    extends _$AudioLevelSettingViewStateCopyWithImpl<$Res,
        _$AudioLevelSettingViewStateImpl>
    implements _$$AudioLevelSettingViewStateImplCopyWith<$Res> {
  __$$AudioLevelSettingViewStateImplCopyWithImpl(
      _$AudioLevelSettingViewStateImpl _value,
      $Res Function(_$AudioLevelSettingViewStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? process = null,
    Object? recordedLevels = null,
    Object? recordingFinishTime = freezed,
    Object? lowerLevel = freezed,
    Object? upperLevel = freezed,
  }) {
    return _then(_$AudioLevelSettingViewStateImpl(
      process: null == process
          ? _value.process
          : process // ignore: cast_nullable_to_non_nullable
              as AudioLevelSettingProcess,
      recordedLevels: null == recordedLevels
          ? _value._recordedLevels
          : recordedLevels // ignore: cast_nullable_to_non_nullable
              as List<double>,
      recordingFinishTime: freezed == recordingFinishTime
          ? _value.recordingFinishTime
          : recordingFinishTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lowerLevel: freezed == lowerLevel
          ? _value.lowerLevel
          : lowerLevel // ignore: cast_nullable_to_non_nullable
              as double?,
      upperLevel: freezed == upperLevel
          ? _value.upperLevel
          : upperLevel // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$AudioLevelSettingViewStateImpl implements _AudioLevelSettingViewState {
  _$AudioLevelSettingViewStateImpl(
      {required this.process,
      final List<double> recordedLevels = const [],
      this.recordingFinishTime,
      this.lowerLevel,
      this.upperLevel})
      : _recordedLevels = recordedLevels;

  @override
  final AudioLevelSettingProcess process;
  final List<double> _recordedLevels;
  @override
  @JsonKey()
  List<double> get recordedLevels {
    if (_recordedLevels is EqualUnmodifiableListView) return _recordedLevels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recordedLevels);
  }

  @override
  final DateTime? recordingFinishTime;
  @override
  final double? lowerLevel;
  @override
  final double? upperLevel;

  @override
  String toString() {
    return 'AudioLevelSettingViewState(process: $process, recordedLevels: $recordedLevels, recordingFinishTime: $recordingFinishTime, lowerLevel: $lowerLevel, upperLevel: $upperLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioLevelSettingViewStateImpl &&
            (identical(other.process, process) || other.process == process) &&
            const DeepCollectionEquality()
                .equals(other._recordedLevels, _recordedLevels) &&
            (identical(other.recordingFinishTime, recordingFinishTime) ||
                other.recordingFinishTime == recordingFinishTime) &&
            (identical(other.lowerLevel, lowerLevel) ||
                other.lowerLevel == lowerLevel) &&
            (identical(other.upperLevel, upperLevel) ||
                other.upperLevel == upperLevel));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      process,
      const DeepCollectionEquality().hash(_recordedLevels),
      recordingFinishTime,
      lowerLevel,
      upperLevel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioLevelSettingViewStateImplCopyWith<_$AudioLevelSettingViewStateImpl>
      get copyWith => __$$AudioLevelSettingViewStateImplCopyWithImpl<
          _$AudioLevelSettingViewStateImpl>(this, _$identity);
}

abstract class _AudioLevelSettingViewState
    implements AudioLevelSettingViewState {
  factory _AudioLevelSettingViewState(
      {required final AudioLevelSettingProcess process,
      final List<double> recordedLevels,
      final DateTime? recordingFinishTime,
      final double? lowerLevel,
      final double? upperLevel}) = _$AudioLevelSettingViewStateImpl;

  @override
  AudioLevelSettingProcess get process;
  @override
  List<double> get recordedLevels;
  @override
  DateTime? get recordingFinishTime;
  @override
  double? get lowerLevel;
  @override
  double? get upperLevel;
  @override
  @JsonKey(ignore: true)
  _$$AudioLevelSettingViewStateImplCopyWith<_$AudioLevelSettingViewStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
