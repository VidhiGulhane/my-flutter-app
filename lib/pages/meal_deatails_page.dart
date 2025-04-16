import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/constants.dart';
import 'package:recipe_app/models/meal.dart';
import 'package:recipe_app/providers/favorite_provider.dart';
import 'package:recipe_app/services/get_meal_byname.dart';
import 'package:recipe_app/widgets/error_widget.dart';
import 'package:recipe_app/widgets/ingredient_checkbox.dart';
import 'package:recipe_app/widgets/loading_widget.dart';
import 'package:recipe_app/widgets/tags_container.dart';
import 'package:recipe_app/widgets/favourite_button.dart';
import 'review_page.dart';

class MealDetailsPage extends StatefulWidget {
  final String mealName;

  static String id = 'MealDetailsPage';

  const MealDetailsPage({required this.mealName, super.key});

  @override
  State<MealDetailsPage> createState() => _MealDetailsPageState();
}

class _MealDetailsPageState extends State<MealDetailsPage> {
  bool isFavorite = false;
  String? selectedIngredient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Details"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Meal>(
        future: GetMealNameService().getMealName(mealName: widget.mealName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          } else if (snapshot.hasError || snapshot.data == null) {
            return const CustomErrorWidget();
          }

          final meal = snapshot.data!;
          final favoriteMeals = context.watch<FavoriteProvider>().favoriteMeals;
          isFavorite = favoriteMeals.any((favMeal) => favMeal.id == meal.id);

          final List<String> ingredientDetails = (meal.measure.isNotEmpty &&
                  meal.ingeredients.length == meal.measure.length)
              ? List.generate(
                  meal.ingeredients.length,
                  (i) => "${meal.measure[i]} ${meal.ingeredients[i]}",
                )
              : meal.ingeredients;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Meal Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  meal.image,
                  height: 320,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 16),

              // Meal Name
              Text(
                meal.name,
                style: GoogleFonts.epilogue(
                  color: kTitleColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Tags
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: meal.tags.split(",").length,
                  itemBuilder: (context, index) {
                    final tag = meal.tags.split(",")[index].trim();
                    return TagsContainer(tag: tag);
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Ingredients
              Text(
                "Ingredients",
                style: GoogleFonts.epilogue(
                  color: kTitleColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: ingredientDetails
                    .map((detail) => IngredientCheckbox(detail: detail))
                    .toList(),
              ),

              const SizedBox(height: 20),

              // Instructions
              Text(
                "Instructions",
                style: GoogleFonts.epilogue(
                  color: kTitleColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                meal.instructions,
                textAlign: TextAlign.justify,
                style: GoogleFonts.epilogue(
                  color: kTitleColor,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 20),

              // Ingredient Dropdown
              DropdownButton<String>(
                hint: const Text("Select an ingredient to replace"),
                value: selectedIngredient,
                isExpanded: true,
                items: meal.ingeredients.map((ingredient) {
                  return DropdownMenuItem<String>(
                    value: ingredient,
                    child: Text(ingredient),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedIngredient = newValue;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Write Review Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReviewsPage(mealId: meal.id),
                    ),
                  );
                },
                child: const Text("Write a Review"),
              ),

              const SizedBox(height: 20),

              // Favorite Button
              FavoriteButton(
                meal: meal,
                isFavorite: isFavorite,
              ),
            ],
          );
        },
      ),
    );
  }
}
