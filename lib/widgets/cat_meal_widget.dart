import 'package:flutter/material.dart';
import 'package:recipe_app/pages/meal_deatails_page.dart';

class CatMealWidget extends StatelessWidget {
  final String meal;
  final String email;

  const CatMealWidget({required this.meal, required this.email});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(meal),
      subtitle: Text(email),
      onTap: () {
        Navigator.pushNamed(context, MealDetailsPage.id);
      },
    );
  }
}
