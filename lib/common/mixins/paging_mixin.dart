import 'package:base_bloc_3/import.dart';

class _PagingError implements Exception {
  final String message;

  _PagingError(this.message);

  @override
  String toString() => message;
}

mixin PagingCommonMethodMixin {
  PagingController<int, T> createPagingController<T>({
    required Future<Either<BaseError, List<T>>> Function(int pageKey) fetchData,
    int limit = ApiConfig.limit,
  }) {
    return PagingController<int, T>(
      getNextPageKey: (state) {
        return state.nextIntPageKey;
      },
      fetchPage: (pageKey) async {
        final result = await fetchData(pageKey);
        return result.fold(
          (error) {
            throw _PagingError(error.getErrorString);
          },
          (items) {
            return items;
          },
        );
      },
    );
  }

  /// Remove an item from paging controller by matching predicate
  ///
  /// Uses filterItems method if available (simpler and more efficient)
  /// Automatically fetches next page if remaining items < 2 * limit
  ///
  /// Example:
  /// ```dart
  /// pagingControllerRemoveItemBy(pagingController, (user) => user.id == userId);
  /// ```
  void pagingControllerRemoveItemBy<T>(
    PagingController<int, T> pagingController,
    bool Function(T item) predicate, {
    int limit = ApiConfig.limit,
  }) {
    // Xóa items
    pagingController.value = pagingController.value.filterItems(
      (item) => !predicate(item),
    );
    Future.microtask(() {
      final stateAfterRemove = pagingController.value;
      final itemsAfterRemove = stateAfterRemove.items?.length ?? 0;

      if (itemsAfterRemove < 2 * limit && !stateAfterRemove.lastPageIsEmpty) {
        pagingController.fetchNextPage();
      }
    });
  }

  /// Update an item in paging controller by matching predicate
  ///
  /// Uses mapItems internally - simpler and more efficient.
  /// This method allows you to update an item using a transformation function,
  /// which is useful when you need to modify specific fields of an existing item.
  ///
  /// Example:
  /// ```dart
  /// // Update user's name by ID
  /// pagingUpdateItemBy(
  ///   pagingController,
  ///   (user) => user.id == userId,
  ///   (oldUser) => oldUser.copyWith(name: 'New Name'),
  /// );
  ///
  /// // Update user's status
  /// pagingUpdateItemBy(
  ///   pagingController,
  ///   (user) => user.id == userId,
  ///   (oldUser) => oldUser.copyWith(isActive: true),
  /// );
  /// ```
  void pagingUpdateItemBy<T>(
    PagingController<int, T> controller,
    bool Function(T item) predicate,
    T Function(T old) updateFn,
  ) {
    controller.value = controller.value.mapItems(
      (item) => predicate(item) ? updateFn(item) : item,
    );
  }
}
