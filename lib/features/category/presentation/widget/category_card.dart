import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/features/category/domain/entity/category_entity.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: category.url,
                fit: BoxFit.contain,
                placeholder: (context, url) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(
                        Icons.restaurant_menu,
                        size: 40,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Icon(Icons.broken_image),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      category.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
