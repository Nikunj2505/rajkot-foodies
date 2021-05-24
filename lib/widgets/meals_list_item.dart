import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/meal.dart';
import '../providers/favorite_providers.dart';
import '../screens/meals_details_screen.dart';

class MealsListItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  final int duration;
  final Affordability affordability;
  final Complexity complexity;

  MealsListItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.duration,
    required this.affordability,
    required this.complexity,
  });

  final circularWidget = BorderRadius.circular(15);

  String get getAffordability {
    switch (affordability) {
      case Affordability.Affordable:
        {
          return 'Affordable';
        }
      case Affordability.Luxurious:
        {
          return 'Luxurious';
        }
      case Affordability.Pricey:
        {
          return 'Pricey';
        }
      default:
        {
          return "";
        }
    }
  }

  String get getComplexity {
    switch (complexity) {
      case Complexity.Simple:
        {
          return 'Simple';
        }
      case Complexity.Challenging:
        {
          return 'Challenging';
        }
      case Complexity.Hard:
        {
          return 'Hard';
        }
      default:
        {
          return "";
        }
    }
  }

  void _moveToDetailScreen(BuildContext ctx) {
    Navigator.pushNamed(ctx, MealsDetailsScreen.route, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: circularWidget),
      elevation: 4,
      child: InkWell(
        onTap: () => _moveToDetailScreen(context),
        splashColor: Theme.of(context).primaryColor,
        borderRadius: circularWidget,
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    height: 250,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 250,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    color: Colors.black54,
                    child: Text(
                      '$title',
                      style: Theme.of(context).textTheme.bodyText1,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
                Consumer<FavoriteProviders>(
                  builder: (ctx, favoriteProvider, child) {
                    return favoriteProvider.favoriteMeals
                            .any((meal) => meal.id == id)
                        ? Positioned(
                            top: 0,
                            right: 5,
                            child: Container(
                              margin: const EdgeInsets.only(
                                right: 5,
                                top: 5,
                              ),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Icon(
                                Icons.star,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 0,
                            height: 0,
                          );
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule),
                      SizedBox(
                        width: 5,
                      ),
                      Text('$duration min'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.work),
                      SizedBox(
                        width: 5,
                      ),
                      Text('$getComplexity'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.attach_money),
                      SizedBox(
                        width: 5,
                      ),
                      Text('$getAffordability'),
                    ],
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
