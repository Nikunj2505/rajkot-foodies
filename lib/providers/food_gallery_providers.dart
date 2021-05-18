import 'dart:io';

import 'package:flutter/foundation.dart';

import '../helper/db_helper.dart';
import '../models/FoodGallery.dart';

class FoodGalleryProvider with ChangeNotifier {
  List<FoodGallery> _foodGalleryItems = [];

  List<FoodGallery> get foodItems {
    return [..._foodGalleryItems.reversed];
  }

  addFoodsPictures(File foodPic) {
    _foodGalleryItems.add(FoodGallery(foodPic));
    notifyListeners();
    DBHelper.insertFoodImages({'path': foodPic.path});
  }

  Future<void> fetchAllPictures() async {
    final list = await DBHelper.getAllFoodImages();
    _foodGalleryItems =
        list.map((item) => FoodGallery(File(item['path']))).toList();
    notifyListeners();
  }
}
