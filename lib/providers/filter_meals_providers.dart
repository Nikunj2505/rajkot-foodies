import 'package:flutter/foundation.dart';

import '../dummy_data.dart';
import '../models/meal.dart';
import '../providers/filter_providers.dart';

class FilterMealsProviders with ChangeNotifier {
  final FilterProviders _filterProviders;
  List<Meal> _meals = DUMMY_MEALS;

  FilterMealsProviders(this._filterProviders);

  List<Meal> get meals {
    if (_filterProviders != null) {
      _updateMealListBasedOnFilter();
    }
    return [..._meals];
  }

  void _updateMealListBasedOnFilter() {
    if (_filterProviders != null) {
      _meals = DUMMY_MEALS.where((meal) {
        if (_filterProviders.filterList['isGlutenFree'] && !meal.isGlutenFree) {
          return false;
        }
        if (_filterProviders.filterList['isVegan'] && !meal.isVegan) {
          return false;
        }
        if (_filterProviders.filterList['isVegetarian'] && !meal.isVegetarian) {
          return false;
        }
        if (_filterProviders.filterList['isLactoseFree'] &&
            !meal.isLactoseFree) {
          return false;
        }
        return true;
      }).toList();
    }
  }
}
