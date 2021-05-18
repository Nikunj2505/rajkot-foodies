import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysProvider;
import 'package:provider/provider.dart';

import '../providers/food_gallery_providers.dart';
import '../widgets/main_drawer.dart';

class FoodGallery extends StatelessWidget {
  static const String route = "/food-gallery";

  const FoodGallery({Key key}) : super(key: key);

  void _chooseFile(BuildContext ctx) {
    showDialog(
        context: ctx,
        builder: (bCtx) {
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(
                    top: 15,
                    right: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(bCtx);
                          _takePicture(ctx);
                        },
                        child: const Text(
                          'Choose from camera',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(bCtx);
                          _chooseFromGallery(ctx);
                        },
                        child: const Text(
                          'Choose from gallery',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => Navigator.of(bCtx).pop(),
                      child: CircleAvatar(
                        backgroundColor: Theme.of(bCtx).primaryColor,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _takePicture(BuildContext context) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(
      source: ImageSource.camera,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 80,
    );
    if (pickedImage != null) {
      final directory = await sysProvider.getApplicationDocumentsDirectory();
      final copiedFile = await File(pickedImage.path)
          .copy("${directory.path}/${path.basename(pickedImage.path)}");
      Provider.of<FoodGalleryProvider>(context, listen: false)
          .addFoodsPictures(copiedFile);
    }
  }

  void _chooseFromGallery(BuildContext context) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(
        source: ImageSource.gallery,
        maxHeight: 600,
        maxWidth: 600,
        imageQuality: 80);

    if (pickedImage != null) {
      Provider.of<FoodGalleryProvider>(context, listen: false)
          .addFoodsPictures(File(pickedImage.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Gallery"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _chooseFile(context);
              }),
        ],
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: Provider.of<FoodGalleryProvider>(context, listen: false)
            .fetchAllPictures(),
        builder: (ctx, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<FoodGalleryProvider>(
                  builder: (ctx, value, ch) =>
                      (value != null && value.foodItems.length <= 0)
                          ? ch
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                                childAspectRatio: 2 / 2,
                                maxCrossAxisExtent: 250,
                              ),
                              itemBuilder: (ctx, index) {
                                return ClipRRect(
                                  child: Image.file(
                                    value.foodItems[index].foodImage,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                              itemCount: value.foodItems.length,
                            ),
                  child: const Center(
                    child: Text('Add food picture from Add button!'),
                  ),
                );
        },
      ),
    );
  }
}
