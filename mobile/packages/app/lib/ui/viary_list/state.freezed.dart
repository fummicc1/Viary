// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ViaryListState {
  List<Viary> get viaries => throw _privateConstructorUsedError;
  List<Viary> get allViaries => throw _privateConstructorUsedError;
  DateTime? get selectedDate => throw _privateConstructorUsedError;
  CalendarFormat get calendarFormat => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ViaryListStateCopyWith<ViaryListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ViaryListStateCopyWith<$Res> {
  factory $ViaryListStateCopyWith(
          ViaryListState value, $Res Function(ViaryListState) then) =
      _$ViaryListStateCopyWithImpl<$Res, ViaryListState>;
  @useResult
  $Res call(
      {List<Viary> viaries,
      List<Viary> allViaries,
      DateTime? selectedDate,
      CalendarFormat calendarFormat});
}

/// @nodoc
class _$ViaryListStateCopyWithImpl<$Res, $Val extends ViaryListState>
    implements $ViaryListStateCopyWith<$Res> {
  _$ViaryListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? viaries = null,
    Object? allViaries = null,
    Object? selectedDate = freezed,
    Object? calendarFormat = null,
  }) {
    return _then(_value.copyWith(
      viaries: null == viaries
          ? _value.viaries
          : viaries // ignore: cast_nullable_to_non_nullable
              as List<Viary>,
      allViaries: null == allViaries
          ? _value.allViaries
          : allViaries // ignore: cast_nullable_to_non_nullable
              as List<Viary>,
      selectedDate: freezed == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      calendarFormat: null == calendarFormat
          ? _value.calendarFormat
          : calendarFormat // ignore: cast_nullable_to_non_nullable
              as CalendarFormat,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ViaryListStateCopyWith<$Res>
    implements $ViaryListStateCopyWith<$Res> {
  factory _$$_ViaryListStateCopyWith(
          _$_ViaryListState value, $Res Function(_$_ViaryListState) then) =
      __$$_ViaryListStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Viary> viaries,
      List<Viary> allViaries,
      DateTime? selectedDate,
      CalendarFormat calendarFormat});
}

/// @nodoc
class __$$_ViaryListStateCopyWithImpl<$Res>
    extends _$ViaryListStateCopyWithImpl<$Res, _$_ViaryListState>
    implements _$$_ViaryListStateCopyWith<$Res> {
  __$$_ViaryListStateCopyWithImpl(
      _$_ViaryListState _value, $Res Function(_$_ViaryListState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? viaries = null,
    Object? allViaries = null,
    Object? selectedDate = freezed,
    Object? calendarFormat = null,
  }) {
    return _then(_$_ViaryListState(
      viaries: null == viaries
          ? _value._viaries
          : viaries // ignore: cast_nullable_to_non_nullable
              as List<Viary>,
      allViaries: null == allViaries
          ? _value._allViaries
          : allViaries // ignore: cast_nullable_to_non_nullable
              as List<Viary>,
      selectedDate: freezed == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      calendarFormat: null == calendarFormat
          ? _value.calendarFormat
          : calendarFormat // ignore: cast_nullable_to_non_nullable
              as CalendarFormat,
    ));
  }
}

/// @nodoc

class _$_ViaryListState implements _ViaryListState {
  const _$_ViaryListState(
      {required final List<Viary> viaries,
      required final List<Viary> allViaries,
      this.selectedDate,
      this.calendarFormat = CalendarFormat.month})
      : _viaries = viaries,
        _allViaries = allViaries;

  final List<Viary> _viaries;
  @override
  List<Viary> get viaries {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_viaries);
  }

  final List<Viary> _allViaries;
  @override
  List<Viary> get allViaries {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allViaries);
  }

  @override
  final DateTime? selectedDate;
  @override
  @JsonKey()
  final CalendarFormat calendarFormat;

  @override
  String toString() {
    return 'ViaryListState(viaries: $viaries, allViaries: $allViaries, selectedDate: $selectedDate, calendarFormat: $calendarFormat)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ViaryListState &&
            const DeepCollectionEquality().equals(other._viaries, _viaries) &&
            const DeepCollectionEquality()
                .equals(other._allViaries, _allViaries) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.calendarFormat, calendarFormat) ||
                other.calendarFormat == calendarFormat));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_viaries),
      const DeepCollectionEquality().hash(_allViaries),
      selectedDate,
      calendarFormat);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ViaryListStateCopyWith<_$_ViaryListState> get copyWith =>
      __$$_ViaryListStateCopyWithImpl<_$_ViaryListState>(this, _$identity);
}

abstract class _ViaryListState implements ViaryListState {
  const factory _ViaryListState(
      {required final List<Viary> viaries,
      required final List<Viary> allViaries,
      final DateTime? selectedDate,
      final CalendarFormat calendarFormat}) = _$_ViaryListState;

  @override
  List<Viary> get viaries;
  @override
  List<Viary> get allViaries;
  @override
  DateTime? get selectedDate;
  @override
  CalendarFormat get calendarFormat;
  @override
  @JsonKey(ignore: true)
  _$$_ViaryListStateCopyWith<_$_ViaryListState> get copyWith =>
      throw _privateConstructorUsedError;
}
