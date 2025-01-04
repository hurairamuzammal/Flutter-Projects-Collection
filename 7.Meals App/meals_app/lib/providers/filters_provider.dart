import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/meals_provider.dart';

enum Filters {
  glutenFree,
  lactoseFree,
  vegan,
  vegetarian,
}

class FiltersNotifier extends StateNotifier<Map<Filters, bool>> {
  FiltersNotifier()
      : super({
          Filters.glutenFree: false,
          Filters.lactoseFree: false,
          Filters.vegan: false,
          Filters.vegetarian: false,
        });
  void setFilters(Map<Filters, bool> chosenFilters) {
    state = chosenFilters;
  }

  void setFilter(Filters filter, bool isActive) {
    //state[filter]=isActive is not allowed so we have to create a new state
    // which is created below
    state = {...state, filter: isActive};
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filters, bool>>(
        (ref) => FiltersNotifier());

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final selectedFilters = ref.watch(filtersProvider);
  return meals.where((meal) {
    if (selectedFilters[Filters.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (selectedFilters[Filters.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (selectedFilters[Filters.vegan]! && !meal.isVegan) {
      return false;
    }
    if (selectedFilters[Filters.vegetarian]! && !meal.isVegetarian) {
      return false;
    } else {
      return true;
    }
  }).toList();
});
