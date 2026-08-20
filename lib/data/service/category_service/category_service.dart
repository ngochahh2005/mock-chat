import 'package:base_bloc_3/common/constants/api_endpoint.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/model/category/category_model.dart';
import 'package:retrofit/retrofit.dart';

part 'category_service.g.dart';

@RestApi()
@injectable
abstract class CategoryService {
  @factoryMethod
  factory CategoryService(Dio dio) = _CategoryService;

  @GET(ApiEndpoint.getCategories)
  Future<CategoryResponseModel> getCategories();
}