import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart ';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/categroy_grid_item.dart';

// first screen (main screen)
class CategoriesSceen extends StatefulWidget {
  const CategoriesSceen({
    super.key,
    required this.availableMeals,
  });
  final List<Meal> availableMeals;

  @override
  State<CategoriesSceen> createState() => _CategoriesSceenState();
}

class _CategoriesSceenState extends State<CategoriesSceen>
    with SingleTickerProviderStateMixin {
  //late tells the variable will have value when needed but not now
  late AnimationController _animationController;
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filterMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => MealsScreen(
                  title: category.title,
                  meals: filterMeals,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => SlideTransition(
              position:
                  Tween(begin: const Offset(0, 0.35), end: const Offset(0, 0))
                      .animate(
                CurvedAnimation(
                    parent: _animationController, curve: Curves.easeInCirc),
              ),
              child: GridView(
                padding: const EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWideScreen ? 4 : 2,
                    childAspectRatio: isWideScreen ? 4 / 3 : 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                children: [
                  for (final category in availableCategories)
                    CategroyGridItem(
                        category: category,
                        onSelectedCategory: () =>
                            _selectCategory(context, category)),
                ],
              ),
            ));
  }
}
