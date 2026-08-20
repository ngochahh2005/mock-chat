import 'package:base_bloc_3/features/category/domain/entity/category_entity.dart';
import 'package:base_bloc_3/import.dart';

abstract class CategoryRepo {
  Future<Either<BaseError, List<CategoryEntity>>> getCategories();
}
