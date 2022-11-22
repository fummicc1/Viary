// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'viary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Viary _$ViaryFromJson(Map<String, dynamic> json) {
  return _Viary.fromJson(json);
}

/// @nodoc
class _$ViaryTearOff {
  const _$ViaryTearOff();

  _Viary call(
      {String? id,
      String? sender,
      required String title,
      required String message,
      required DateTime date}) {
    return _Viary(
      id: id,
      sender: sender,
      title: title,
      message: message,
      date: date,
    );
  }

  Viary fromJson(Map<String, Object?> json) {
    return Viary.fromJson(json);
  }
}

/// @nodoc
const $Viary = _$ViaryTearOff();

/// @nodoc
mixin _$Viary {
  String? get id => throw _privateConstructorUsedError;
  String? get sender => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ViaryCopyWith<Viary> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ViaryCopyWith<$Res> {
  factory $ViaryCopyWith(Viary value, $Res Function(Viary) then) =
      _$ViaryCopyWithImpl<$Res>;
  $Res call(
      {String? id,
      String? sender,
      String title,
      String message,
      DateTime date});
}

/// @nodoc
class _$ViaryCopyWithImpl<$Res> implements $ViaryCopyWith<$Res> {
  _$ViaryCopyWithImpl(this._value, this._then);

  final Viary _value;
  // ignore: unused_field
  final $Res Function(Viary) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? sender = freezed,
    Object? title = freezed,
    Object? message = freezed,
    Object? date = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      sender: sender == freezed
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String?,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$ViaryCopyWith<$Res> implements $ViaryCopyWith<$Res> {
  factory _$ViaryCopyWith(_Viary value, $Res Function(_Viary) then) =
      __$ViaryCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? id,
      String? sender,
      String title,
      String message,
      DateTime date});
}

/// @nodoc
class __$ViaryCopyWithImpl<$Res> extends _$ViaryCopyWithImpl<$Res>
    implements _$ViaryCopyWith<$Res> {
  __$ViaryCopyWithImpl(_Viary _value, $Res Function(_Viary) _then)
      : super(_value, (v) => _then(v as _Viary));

  @override
  _Viary get _value => super._value as _Viary;

  @override
  $Res call({
    Object? id = freezed,
    Object? sender = freezed,
    Object? title = freezed,
    Object? message = freezed,
    Object? date = freezed,
  }) {
    return _then(_Viary(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      sender: sender == freezed
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String?,
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Viary with DiagnosticableTreeMixin implements _Viary {
  const _$_Viary(
      {this.id,
      this.sender,
      required this.title,
      required this.message,
      required this.date});

  factory _$_Viary.fromJson(Map<String, dynamic> json) =>
      _$$_ViaryFromJson(json);

  @override
  final String? id;
  @override
  final String? sender;
  @override
  final String title;
  @override
  final String message;
  @override
  final DateTime date;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Viary(id: $id, sender: $sender, title: $title, message: $message, date: $date)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Viary'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('sender', sender))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('message', message))
      ..add(DiagnosticsProperty('date', date));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Viary &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.sender, sender) &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.message, message) &&
            const DeepCollectionEquality().equals(other.date, date));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(sender),
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(message),
      const DeepCollectionEquality().hash(date));

  @JsonKey(ignore: true)
  @override
  _$ViaryCopyWith<_Viary> get copyWith =>
      __$ViaryCopyWithImpl<_Viary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ViaryToJson(this);
  }
}

abstract class _Viary implements Viary {
  const factory _Viary(
      {String? id,
      String? sender,
      required String title,
      required String message,
      required DateTime date}) = _$_Viary;

  factory _Viary.fromJson(Map<String, dynamic> json) = _$_Viary.fromJson;

  @override
  String? get id;
  @override
  String? get sender;
  @override
  String get title;
  @override
  String get message;
  @override
  DateTime get date;
  @override
  @JsonKey(ignore: true)
  _$ViaryCopyWith<_Viary> get copyWith => throw _privateConstructorUsedError;
}
