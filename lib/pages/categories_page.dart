import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app/constants.dart';
import 'package:recipe_app/models/category.dart';
import 'package:recipe_app/models/category_meal.dart';
import 'package:recipe_app/services/get_category_meals.dart';
import 'package:recipe_app/widgets/cat_meal_widget.dart';
import 'package:recipe_app/widgets/loading_widget.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});
  static const String id = 'CategoriesPage';
  
  get email => null;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Category category = data["category"];
    

    return FutureBuilder(
      future: GetCategoryMeal().getCategoryMeal(catName: category.name),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: LoadingWidget(),
          );
        } else if (snapshot.hasData) {
          List<CategoryMeal>? meals = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              title: Text(
                category.name,
                style: GoogleFonts.epilogue(
                  color: kTitleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                clipBehavior: Clip.none,
                children: [
                  Text(
                    "Choose a recipe",
                    style: GoogleFonts.epilogue(
                      color: kTitleColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: meals!.length,
                    itemBuilder: (context, index) =>
                        CatMealWidget(meal: meals[index].name, email: email),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: Text("No data available"));
        }
      },
    );
  }
}
