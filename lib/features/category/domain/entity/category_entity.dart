import 'package:base_bloc_3/data/model/category/category_model.dart';

class CategoryEntity {
  final String id;
  final String name;
  final String url;
  final String description;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.url,
    required this.description,
  });

  factory CategoryEntity.fromModel(CategoryModel model) {
    return CategoryEntity(
      id: model.id ?? '',
      name: model.name,
      url: model.url ?? '',
      description: model.description ?? '',
    );
  }
}
