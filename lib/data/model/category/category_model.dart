import 'package:base_bloc_3/import.dart';

part 'category_model.freezed.dart';

part 'category_model.g.dart';

@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    @JsonKey(name: 'idCategory') String? id,
    @JsonKey(name: 'strCategory') required String name,
    @JsonKey(name: 'strCategoryThumb') String? url,
    @JsonKey(name: 'strCategoryDescription') String? description,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

@freezed
abstract class CategoryResponseModel with _$CategoryResponseModel {
  const factory CategoryResponseModel({
    @JsonKey(name: 'categories') List<CategoryModel>? categories,
  }) = _CategoryResponseModel;

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseModelFromJson(json);
}
