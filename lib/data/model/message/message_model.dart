import 'package:base_bloc_3/common/external_lib.dart';

part 'message_model.freezed.dart';

part 'message_model.g.dart';

@freezed
abstract class MessageModel with _$MessageModel {
  const factory MessageModel({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'senderId') String? senderId,
    @JsonKey(name: 'content') String? content,
    @JsonKey(name: 'createdAt') String? createdAt,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
