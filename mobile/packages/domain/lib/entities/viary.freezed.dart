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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Viary _$ViaryFromJson(Map<String, dynamic> json) {
  return _Viary.fromJson(json);
}

/// @nodoc
mixin _$Viary {
  String? get id => throw _privateConstructorUsedError;
  String? get sender => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  List<ViaryEmotion> get emotions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ViaryCopyWith<Viary> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ViaryCopyWith<$Res> {
  factory $ViaryCopyWith(Viary value, $Res Function(Viary) then) =
      _$ViaryCopyWithImpl<$Res, Viary>;
  @useResult
  $Res call(
      {String? id,
      String? sender,
      String title,
      String message,
      DateTime date,
      List<ViaryEmotion> emotions});
}

/// @nodoc
class _$ViaryCopyWithImpl<$Res, $Val extends Viary>
    implements $ViaryCopyWith<$Res> {
  _$ViaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? sender = freezed,
    Object? title = null,
    Object? message = null,
    Object? date = null,
    Object? emotions = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      emotions: null == emotions
          ? _value.emotions
          : emotions // ignore: cast_nullable_to_non_nullable
              as List<ViaryEmotion>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ViaryCopyWith<$Res> implements $ViaryCopyWith<$Res> {
  factory _$$_ViaryCopyWith(_$_Viary value, $Res Function(_$_Viary) then) =
      __$$_ViaryCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? sender,
      String title,
      String message,
      DateTime date,
      List<ViaryEmotion> emotions});
}

/// @nodoc
class __$$_ViaryCopyWithImpl<$Res> extends _$ViaryCopyWithImpl<$Res, _$_Viary>
    implements _$$_ViaryCopyWith<$Res> {
  __$$_ViaryCopyWithImpl(_$_Viary _value, $Res Function(_$_Viary) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? sender = freezed,
    Object? title = null,
    Object? message = null,
    Object? date = null,
    Object? emotions = null,
  }) {
    return _then(_$_Viary(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      sender: freezed == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      emotions: null == emotions
          ? _value._emotions
          : emotions // ignore: cast_nullable_to_non_nullable
              as List<ViaryEmotion>,
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
      required this.date,
      final List<ViaryEmotion> emotions = const []})
      : _emotions = emotions;

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
  final List<ViaryEmotion> _emotions;
  @override
  @JsonKey()
  List<ViaryEmotion> get emotions {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_emotions);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Viary(id: $id, sender: $sender, title: $title, message: $message, date: $date, emotions: $emotions)';
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
      ..add(DiagnosticsProperty('date', date))
      ..add(DiagnosticsProperty('emotions', emotions));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Viary &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(other._emotions, _emotions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, sender, title, message, date,
      const DeepCollectionEquality().hash(_emotions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ViaryCopyWith<_$_Viary> get copyWith =>
      __$$_ViaryCopyWithImpl<_$_Viary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ViaryToJson(
      this,
    );
  }
}

abstract class _Viary implements Viary {
  const factory _Viary(
      {final String? id,
      final String? sender,
      required final String title,
      required final String message,
      required final DateTime date,
      final List<ViaryEmotion> emotions}) = _$_Viary;

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
  List<ViaryEmotion> get emotions;
  @override
  @JsonKey(ignore: true)
  _$$_ViaryCopyWith<_$_Viary> get copyWith =>
      throw _privateConstructorUsedError;
}

ViaryEmotion _$ViaryEmotionFromJson(Map<String, dynamic> json) {
  return _ViaryEmotion.fromJson(json);
}

/// @nodoc
mixin _$ViaryEmotion {
  String get sentence => throw _privateConstructorUsedError;
  @EmotionJsonConverter()
  Emotion get emotion => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ViaryEmotionCopyWith<ViaryEmotion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ViaryEmotionCopyWith<$Res> {
  factory $ViaryEmotionCopyWith(
          ViaryEmotion value, $Res Function(ViaryEmotion) then) =
      _$ViaryEmotionCopyWithImpl<$Res, ViaryEmotion>;
  @useResult
  $Res call({String sentence, @EmotionJsonConverter() Emotion emotion});
}

/// @nodoc
class _$ViaryEmotionCopyWithImpl<$Res, $Val extends ViaryEmotion>
    implements $ViaryEmotionCopyWith<$Res> {
  _$ViaryEmotionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sentence = null,
    Object? emotion = null,
  }) {
    return _then(_value.copyWith(
      sentence: null == sentence
          ? _value.sentence
          : sentence // ignore: cast_nullable_to_non_nullable
              as String,
      emotion: null == emotion
          ? _value.emotion
          : emotion // ignore: cast_nullable_to_non_nullable
              as Emotion,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ViaryEmotionCopyWith<$Res>
    implements $ViaryEmotionCopyWith<$Res> {
  factory _$$_ViaryEmotionCopyWith(
          _$_ViaryEmotion value, $Res Function(_$_ViaryEmotion) then) =
      __$$_ViaryEmotionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String sentence, @EmotionJsonConverter() Emotion emotion});
}

/// @nodoc
class __$$_ViaryEmotionCopyWithImpl<$Res>
    extends _$ViaryEmotionCopyWithImpl<$Res, _$_ViaryEmotion>
    implements _$$_ViaryEmotionCopyWith<$Res> {
  __$$_ViaryEmotionCopyWithImpl(
      _$_ViaryEmotion _value, $Res Function(_$_ViaryEmotion) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sentence = null,
    Object? emotion = null,
  }) {
    return _then(_$_ViaryEmotion(
      sentence: null == sentence
          ? _value.sentence
          : sentence // ignore: cast_nullable_to_non_nullable
              as String,
      emotion: null == emotion
          ? _value.emotion
          : emotion // ignore: cast_nullable_to_non_nullable
              as Emotion,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ViaryEmotion with DiagnosticableTreeMixin implements _ViaryEmotion {
  const _$_ViaryEmotion(
      {required this.sentence,
      @EmotionJsonConverter() this.emotion = Emotion.unknown});

  factory _$_ViaryEmotion.fromJson(Map<String, dynamic> json) =>
      _$$_ViaryEmotionFromJson(json);

  @override
  final String sentence;
  @override
  @JsonKey()
  @EmotionJsonConverter()
  final Emotion emotion;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ViaryEmotion(sentence: $sentence, emotion: $emotion)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ViaryEmotion'))
      ..add(DiagnosticsProperty('sentence', sentence))
      ..add(DiagnosticsProperty('emotion', emotion));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ViaryEmotion &&
            (identical(other.sentence, sentence) ||
                other.sentence == sentence) &&
            (identical(other.emotion, emotion) || other.emotion == emotion));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, sentence, emotion);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ViaryEmotionCopyWith<_$_ViaryEmotion> get copyWith =>
      __$$_ViaryEmotionCopyWithImpl<_$_ViaryEmotion>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ViaryEmotionToJson(
      this,
    );
  }
}

abstract class _ViaryEmotion implements ViaryEmotion {
  const factory _ViaryEmotion(
      {required final String sentence,
      @EmotionJsonConverter() final Emotion emotion}) = _$_ViaryEmotion;

  factory _ViaryEmotion.fromJson(Map<String, dynamic> json) =
      _$_ViaryEmotion.fromJson;

  @override
  String get sentence;
  @override
  @EmotionJsonConverter()
  Emotion get emotion;
  @override
  @JsonKey(ignore: true)
  _$$_ViaryEmotionCopyWith<_$_ViaryEmotion> get copyWith =>
      throw _privateConstructorUsedError;
}
