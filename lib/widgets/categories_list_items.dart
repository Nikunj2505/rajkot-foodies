import 'package:flutter/material.dart';

import '../screens/categories_meals_screen.dart';

class CategoriesListItems extends StatelessWidget {
  final String id;
  final String title;
  final Color color;

  CategoriesListItems(
      {@required this.id, @required this.title, @required this.color});

  void openCategoriesMealsScreen({BuildContext ctx}) {
    Navigator.pushNamed(ctx, CategoriesMealsScreen.route, arguments: {
      CategoriesMealsScreen.categoryId: id,
      CategoriesMealsScreen.categoryTitle: title
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      onTap: () => openCategoriesMealsScreen(ctx: context),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.7),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}
