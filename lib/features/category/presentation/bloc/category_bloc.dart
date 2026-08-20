import 'package:base_bloc_3/features/category/domain/entity/category_entity.dart';
import 'package:base_bloc_3/features/category/domain/repository/category_repository.dart';
import 'package:base_bloc_3/import.dart';

part 'category_bloc.freezed.dart';

part 'category_bloc.g.dart';

part 'category_event.dart';

part 'category_state.dart';

@injectable
class CategoryBloc extends BaseBloc<CategoryEvent, CategoryState> {
  final CategoryRepo _categoryRepo;

  CategoryBloc(this._categoryRepo) : super(CategoryState.init()) {
    on<CategoryEvent>((CategoryEvent event, Emitter<CategoryState> emit) async {
      await event.when(
        fetch: () => _onFetchCategories(emit),
      );
    });
  }

  Future<void> _onFetchCategories(Emitter<CategoryState> emit) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
      ),
    );

    final resp = await _categoryRepo.getCategories();

    resp.fold(
        (error) => emit(state.copyWith(
            status: BaseStateStatus.failed,
            message: error.toString())), (categories) {
      emit(
        state.copyWith(
          status: BaseStateStatus.success,
          categories: categories,
        ),
      );
    });
  }
}
