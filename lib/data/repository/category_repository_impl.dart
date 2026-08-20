import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/base/network/models/base_data.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/common/mixins/api_helper_mixin.dart';
import 'package:base_bloc_3/data/model/category/category_model.dart';
import 'package:base_bloc_3/data/service/category_service/category_service.dart';
import 'package:base_bloc_3/features/category/domain/index.dart';

@Injectable(as: CategoryRepo)
class CategoryRepoImpl with ApiHelperMixin implements CategoryRepo {
  final CategoryService _categoryService;
  CategoryRepoImpl(this._categoryService);

  @override
  Future<Either<BaseError, List<CategoryEntity>>> getCategories() async {
    return handleBaseListDataApiCall(
          () async {
        final resp = await _categoryService.getCategories();
        return BaseListData(
          data: (resp.categories ?? []),
        );
      },
          (model) => CategoryEntity.fromModel(model as CategoryModel),
    );
  }
}