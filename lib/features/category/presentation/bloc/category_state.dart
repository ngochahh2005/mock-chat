part of 'category_bloc.dart';

@CopyWith()
class CategoryState extends BaseBlocState {
  final List<CategoryEntity> categories;

  const CategoryState({
    required super.status,
    super.message,
    required this.categories,
  });

  factory CategoryState.init() {
    return const CategoryState(status: BaseStateStatus.init, categories: []);
  }

  @override
  List get props => [status, message, categories];
}
