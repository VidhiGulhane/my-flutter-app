// ignore: file_names
// ignore: file_names
// ignore: file_names
import 'package:flutter/material.dart';
import 'package:recipe_app/constants.dart';

class CartSearchBar extends StatefulWidget {
  const CartSearchBar({super.key, required this.onSubmitted});
  final Function(String)? onSubmitted;

  @override
  // ignore: library_private_types_in_public_api
  _CartSearchBarState createState() => _CartSearchBarState();
}

class _CartSearchBarState extends State<CartSearchBar> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: (data) {
        // Clear the text field after submitting
      },
      style: const TextStyle(color: kTextColor),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        fillColor: const Color(0xFFF2EDE8),
        filled: true,
        prefixIcon: const Icon(
          Icons.search,
          color: kTextColor,
        ),
        hintText: "Type Recipe's Name to find the ingredients",
        hintStyle: const TextStyle(color: kTextColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
