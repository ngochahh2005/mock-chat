import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_data.g.dart';

@JsonSerializable(
  genericArgumentFactories: true,
  anyMap: true,
  explicitToJson: true,
)
class BaseListData<T> {
  BaseListData({this.data, this.status});

  factory BaseListData.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseListDataFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseListDataToJson(this, toJsonT);

  @JsonKey(name: 'data')
  List<T>? data;
  @JsonKey(name: 'code')
  int? status;
}

@JsonSerializable(
  genericArgumentFactories: true,
  anyMap: true,
  explicitToJson: true,
)
class BaseData<T> {
  BaseData({this.data, this.status});

  factory BaseData.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseDataFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseDataToJson(this, toJsonT);

  @JsonKey(name: 'data')
  T? data;
  @JsonKey(name: 'status')
  int? status;
}

@JsonSerializable(
  genericArgumentFactories: true,
  anyMap: true,
  explicitToJson: true,
)
class BaseConfigData<T> {
  BaseConfigData({
    this.listJson,
  });

  factory BaseConfigData.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseConfigDataFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseConfigDataToJson(this, toJsonT);

  @JsonKey(name: 'json')
  List<T>? listJson;
}

@JsonSerializable()
class PagingData {
  PagingData({this.number, this.limit, this.total});

  @JsonKey(name: 'number')
  int? number;
  @JsonKey(name: 'limit')
  int? limit;
  @JsonKey(name: 'total')
  int? total;

  factory PagingData.fromJson(Map<String, dynamic> json) =>
      _$PagingDataFromJson(json);

  Map<String, dynamic> toJson() => _$PagingDataToJson(this);
}

@JsonSerializable()
class BaseSuccessData {
  BaseSuccessData({this.success});

  @JsonKey(name: 'success')
  bool? success;
  @JsonKey(name: 'data')
  String? data;

  factory BaseSuccessData.fromJson(Map<String, dynamic> json) =>
      _$BaseSuccessDataFromJson(json);

  Map<String, dynamic> toJson() => _$BaseSuccessDataToJson(this);
}
