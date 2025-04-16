import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/models/meal.dart';
import 'package:recipe_app/providers/favorite_provider.dart';

class FavoriteButton extends StatefulWidget {
  final Meal meal;
  final bool isFavorite;

  const FavoriteButton({required this.meal, required this.isFavorite});

  @override
  // ignore: library_private_types_in_public_api
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0, right: 12, left: 12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isFavorite = !isFavorite;
          });
          if (isFavorite) {
            context.read<FavoriteProvider>().addFavoriteMeal(meal: widget.meal);
          } else {
            context
                .read<FavoriteProvider>()
                .deleteFavoriteMeal(meal: widget.meal);
          }
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xffF2EDE8),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isFavorite ? Icons.star : Icons.star_outline),
              const SizedBox(width: 10),
              Text(
                isFavorite ? "Remove from favorite" : "Add to favorite",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
