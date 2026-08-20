import 'package:base_bloc_3/features/category/index.dart';
import 'package:base_bloc_3/import.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState
    extends BaseState<CategoryPage, CategoryEvent, CategoryState, CategoryBloc>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    bloc.add(const CategoryEvent.fetch());
  }

  @override
  Widget renderUI(BuildContext context) {
    return BaseScaffold(
      appBar: const BaseAppBar(
        title: "Category Page",
      ),
      body: blocBuilder((context, state) {

        if (state.categories.isEmpty) {
          return const Center(
            child: Text('Không có danh mục nào'),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: GridView.builder(
            itemCount: state.categories.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 10.w,
              crossAxisSpacing: 10.h,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return CategoryCard(category: state.categories[index]);
            },
          ),
        );
      }),
    );
  }
}
