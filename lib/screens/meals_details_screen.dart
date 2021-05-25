import 'package:flutter/material.dart';
import 'package:foodies/models/meal.dart';
import 'package:provider/provider.dart';

import '../dummy_data.dart';
import '../providers/favorite_providers.dart';

class MealsDetailsScreen extends StatelessWidget {
  static const routeName = '/meal-details';

  Widget spacingBetweenWidgets() {
    return const SizedBox(
      height: 10,
    );
  }

  Widget heading(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  Widget roundedView(BuildContext context, Widget child) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Theme.of(context).accentColor),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    String? mealId = ModalRoute.of(context)!.settings.arguments as String?;
    Meal selectedMealItem = DUMMY_MEALS.firstWhere((meal) => meal.id == mealId);
    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedMealItem.title}'),
      ),
      floatingActionButton: Consumer<FavoriteProviders>(
        builder: (BuildContext context, favoriteProvider, Widget? child) =>
            FloatingActionButton(
          child:
              (favoriteProvider.favoriteMeals.any((meal) => meal.id == mealId))
                  ? Icon(Icons.star)
                  : Icon(Icons.star_border),
          onPressed: () => favoriteProvider.toggleFavorite(mealId),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              selectedMealItem.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            spacingBetweenWidgets(),
            heading(context, 'Ingredients:'),
            spacingBetweenWidgets(),
            roundedView(
              context,
              ListView.separated(
                itemCount: selectedMealItem.ingredients.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      '${selectedMealItem.ingredients[index]}',
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            ),
            spacingBetweenWidgets(),
            heading(context, 'steps to create:'),
            spacingBetweenWidgets(),
            roundedView(
              context,
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: selectedMealItem.steps.length,
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 15,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            '${index + 1}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        title: Text('${selectedMealItem.steps[index]}'),
                      ),
                      if (index < selectedMealItem.steps.length - 1)
                        const Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
