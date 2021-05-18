import 'package:flutter/material.dart';
import 'package:foodies/dummy_data.dart';

import '../widgets/categories_list_items.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(15),
      children: DUMMY_CATEGORIES
          .map((item) => CategoriesListItems(
                id: item.id,
                title: item.title,
                color: item.color,
              ))
          .toList(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 3 / 2,
        maxCrossAxisExtent: 200,
      ),
    );
  }
}
