import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/filter_providers.dart';
import '../widgets/main_drawer.dart';
import '../widgets/switch_list_item.dart';

class FiltersScreen extends StatefulWidget {
  static const route = '/filters';
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
            ),
            onPressed: () {
              // update filter list
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: Consumer<FilterProviders>(builder: (ctx, filterProvider, child) {
        return Column(
          children: [
            SwitchListItem(
              title: 'Gluten Free',
              description: 'Only include Gluten free meals',
              isSelected: filterProvider.filterList['isGlutenFree'],
              updateSwitch: (isChanged) {
                filterProvider.updateFilterList('isGlutenFree', isChanged);
              },
            ),
            SwitchListItem(
              title: 'Lactose free',
              description: 'Only includes Lactose free meals',
              isSelected: filterProvider.filterList['isLactoseFree'],
              updateSwitch: (isChanged) {
                filterProvider.updateFilterList('isLactoseFree', isChanged);
              },
            ),
            SwitchListItem(
              title: 'Vegan',
              description: 'Only includes vegan meals',
              isSelected: filterProvider.filterList['isVegan'],
              updateSwitch: (isChanged) {
                filterProvider.updateFilterList('isVegan', isChanged);
              },
            ),
            SwitchListItem(
              title: 'Vegetarian',
              description: 'Only includes Vegetarian meals',
              isSelected: filterProvider.filterList['isVegetarian'],
              updateSwitch: (isChanged) {
                filterProvider.updateFilterList('isVegetarian', isChanged);
              },
            ),
          ],
        );
      }),
    );
  }
}
