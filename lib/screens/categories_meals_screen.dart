import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../providers/filter_meals_providers.dart';
import '../widgets/meals_list_item.dart';

class CategoriesMealsScreen extends StatelessWidget {
  static const route = '/categories-meals';
  static const categoryId = 'meals_id';
  static const categoryTitle = 'meals_title';

  @override
  Widget build(BuildContext context) {
    List<Meal> meals =
        Provider.of<FilterMealsProviders>(context, listen: false).meals;

    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final String? categoryId = arguments[CategoriesMealsScreen.categoryId];
    final String categoryTitle = arguments[CategoriesMealsScreen.categoryTitle]!;

    final mealList = meals.where((mealItem) {
      return mealItem.categories.contains(categoryId);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, item) {
          final mealItem = mealList[item];
          return MealsListItem(
            id: mealItem.id,
            title: mealItem.title,
            imageUrl: mealItem.imageUrl,
            duration: mealItem.duration,
            affordability: mealItem.affordability,
            complexity: mealItem.complexity,
          );
        },
        itemCount: mealList.length,
      ),
    );
  }
}
