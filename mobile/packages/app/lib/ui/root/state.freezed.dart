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
mixin _$RootState {
  dynamic get isSignedIn => throw _privateConstructorUsedError;
  List<Viary> get viaries => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RootStateCopyWith<RootState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RootStateCopyWith<$Res> {
  factory $RootStateCopyWith(RootState value, $Res Function(RootState) then) =
      _$RootStateCopyWithImpl<$Res, RootState>;
  @useResult
  $Res call({dynamic isSignedIn, List<Viary> viaries});
}

/// @nodoc
class _$RootStateCopyWithImpl<$Res, $Val extends RootState>
    implements $RootStateCopyWith<$Res> {
  _$RootStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSignedIn = null,
    Object? viaries = null,
  }) {
    return _then(_value.copyWith(
      isSignedIn: null == isSignedIn
          ? _value.isSignedIn
          : isSignedIn // ignore: cast_nullable_to_non_nullable
              as dynamic,
      viaries: null == viaries
          ? _value.viaries
          : viaries // ignore: cast_nullable_to_non_nullable
              as List<Viary>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RootStateCopyWith<$Res> implements $RootStateCopyWith<$Res> {
  factory _$$_RootStateCopyWith(
          _$_RootState value, $Res Function(_$_RootState) then) =
      __$$_RootStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({dynamic isSignedIn, List<Viary> viaries});
}

/// @nodoc
class __$$_RootStateCopyWithImpl<$Res>
    extends _$RootStateCopyWithImpl<$Res, _$_RootState>
    implements _$$_RootStateCopyWith<$Res> {
  __$$_RootStateCopyWithImpl(
      _$_RootState _value, $Res Function(_$_RootState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSignedIn = null,
    Object? viaries = null,
  }) {
    return _then(_$_RootState(
      isSignedIn: null == isSignedIn ? _value.isSignedIn : isSignedIn,
      viaries: null == viaries
          ? _value._viaries
          : viaries // ignore: cast_nullable_to_non_nullable
              as List<Viary>,
    ));
  }
}

/// @nodoc

class _$_RootState implements _RootState {
  const _$_RootState(
      {this.isSignedIn = false, final List<Viary> viaries = const []})
      : _viaries = viaries;

  @override
  @JsonKey()
  final dynamic isSignedIn;
  final List<Viary> _viaries;
  @override
  @JsonKey()
  List<Viary> get viaries {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_viaries);
  }

  @override
  String toString() {
    return 'RootState(isSignedIn: $isSignedIn, viaries: $viaries)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RootState &&
            const DeepCollectionEquality()
                .equals(other.isSignedIn, isSignedIn) &&
            const DeepCollectionEquality().equals(other._viaries, _viaries));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(isSignedIn),
      const DeepCollectionEquality().hash(_viaries));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RootStateCopyWith<_$_RootState> get copyWith =>
      __$$_RootStateCopyWithImpl<_$_RootState>(this, _$identity);
}

abstract class _RootState implements RootState {
  const factory _RootState(
      {final dynamic isSignedIn, final List<Viary> viaries}) = _$_RootState;

  @override
  dynamic get isSignedIn;
  @override
  List<Viary> get viaries;
  @override
  @JsonKey(ignore: true)
  _$$_RootStateCopyWith<_$_RootState> get copyWith =>
      throw _privateConstructorUsedError;
}
