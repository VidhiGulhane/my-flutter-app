class Ingrediant {
  // ignore: non_constant_identifier_names
  String IngrediantName;
  String image;
  String quantity;

  Ingrediant({
    // ignore: non_constant_identifier_names
    required this.IngrediantName,
    required this.image,
    required this.quantity,
  });

  factory Ingrediant.fromjson(jsonData) {
    return Ingrediant(
      IngrediantName: jsonData["strIngredient"],
      image:
          "https://www.themealdb.com/images/ingredients/${jsonData["strIngredient"]}.png",
      quantity: "",
    );
  }

  @override
  String toString() {
    return 'Ingrediant{IngrediantName: $IngrediantName, image: $image, quantity: $quantity}';
  }
}
