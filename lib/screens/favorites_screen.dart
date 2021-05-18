import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorite_providers.dart';
import '../widgets/meals_list_item.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoriteMeals = Provider.of<FavoriteProviders>(context).favoriteMeals;
    if (favoriteMeals.isEmpty) {
      return Center(
        child: Text('No Favorite Meals found!'),
      );
    } else {
      return ListView.builder(
        itemBuilder: (ctx, item) {
          final mealItem = favoriteMeals[item];
          return MealsListItem(
            id: mealItem.id,
            title: mealItem.title,
            imageUrl: mealItem.imageUrl,
            duration: mealItem.duration,
            affordability: mealItem.affordability,
            complexity: mealItem.complexity,
          );
        },
        itemCount: favoriteMeals.length,
      );
    }
  }
}
