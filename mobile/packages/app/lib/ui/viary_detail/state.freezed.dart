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
mixin _$ViaryDetailState {
  Viary get viary => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ViaryDetailStateCopyWith<ViaryDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ViaryDetailStateCopyWith<$Res> {
  factory $ViaryDetailStateCopyWith(
          ViaryDetailState value, $Res Function(ViaryDetailState) then) =
      _$ViaryDetailStateCopyWithImpl<$Res, ViaryDetailState>;
  @useResult
  $Res call({Viary viary});

  $ViaryCopyWith<$Res> get viary;
}

/// @nodoc
class _$ViaryDetailStateCopyWithImpl<$Res, $Val extends ViaryDetailState>
    implements $ViaryDetailStateCopyWith<$Res> {
  _$ViaryDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? viary = null,
  }) {
    return _then(_value.copyWith(
      viary: null == viary
          ? _value.viary
          : viary // ignore: cast_nullable_to_non_nullable
              as Viary,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ViaryCopyWith<$Res> get viary {
    return $ViaryCopyWith<$Res>(_value.viary, (value) {
      return _then(_value.copyWith(viary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ViaryDetailStateCopyWith<$Res>
    implements $ViaryDetailStateCopyWith<$Res> {
  factory _$$_ViaryDetailStateCopyWith(
          _$_ViaryDetailState value, $Res Function(_$_ViaryDetailState) then) =
      __$$_ViaryDetailStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Viary viary});

  @override
  $ViaryCopyWith<$Res> get viary;
}

/// @nodoc
class __$$_ViaryDetailStateCopyWithImpl<$Res>
    extends _$ViaryDetailStateCopyWithImpl<$Res, _$_ViaryDetailState>
    implements _$$_ViaryDetailStateCopyWith<$Res> {
  __$$_ViaryDetailStateCopyWithImpl(
      _$_ViaryDetailState _value, $Res Function(_$_ViaryDetailState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? viary = null,
  }) {
    return _then(_$_ViaryDetailState(
      viary: null == viary
          ? _value.viary
          : viary // ignore: cast_nullable_to_non_nullable
              as Viary,
    ));
  }
}

/// @nodoc

class _$_ViaryDetailState implements _ViaryDetailState {
  const _$_ViaryDetailState({required this.viary});

  @override
  final Viary viary;

  @override
  String toString() {
    return 'ViaryDetailState(viary: $viary)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ViaryDetailState &&
            (identical(other.viary, viary) || other.viary == viary));
  }

  @override
  int get hashCode => Object.hash(runtimeType, viary);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ViaryDetailStateCopyWith<_$_ViaryDetailState> get copyWith =>
      __$$_ViaryDetailStateCopyWithImpl<_$_ViaryDetailState>(this, _$identity);
}

abstract class _ViaryDetailState implements ViaryDetailState {
  const factory _ViaryDetailState({required final Viary viary}) =
      _$_ViaryDetailState;

  @override
  Viary get viary;
  @override
  @JsonKey(ignore: true)
  _$$_ViaryDetailStateCopyWith<_$_ViaryDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}
