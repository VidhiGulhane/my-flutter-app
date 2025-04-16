import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String username;
  final String comment;
  final int rating;

  Review({
    required this.username,
    required this.comment,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'comment': comment,
      'rating': rating,
    };
  }

  factory Review.fromMap(Map<String, dynamic> data) {
    return Review(
      username: data['username'] ?? '',
      comment: data['comment'] ?? '',
      rating: data['rating'] ?? 0,
    );
  }
}

class ReviewsPage extends StatefulWidget {
  final String mealId;

  const ReviewsPage({required this.mealId, super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 5; // Default rating

  void _submitReview() async {
    final comment = _reviewController.text.trim();
    if (comment.isEmpty) return;

    final newReview = Review(
      username: "TestUser", // Replace with actual user's name from auth
      comment: comment,
      rating: _rating,
    );

    await FirebaseFirestore.instance
        .collection('meals')
        .doc(widget.mealId)
        .collection('reviews')
        .add(newReview.toMap());

    _reviewController.clear();
    setState(() => _rating = 5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ratings & Reviews"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _reviewController,
              decoration: const InputDecoration(
                hintText: "Write your review...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Rating: "),
              DropdownButton<int>(
                value: _rating,
                items: List.generate(5, (index) {
                  final value = index + 1;
                  return DropdownMenuItem(
                    value: value,
                    child: Text("$value ⭐"),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _rating = value);
                  }
                },
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _submitReview,
                child: const Text("Submit Review"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('meals')
                  .doc(widget.mealId)
                  .collection('reviews')
                  .orderBy('rating', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());

                final reviews = snapshot.data!.docs.map((doc) {
                  return Review.fromMap(doc.data() as Map<String, dynamic>);
                }).toList();

                return ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return ListTile(
                      title: Text(review.username),
                      subtitle:
                          Text("${review.comment} ${"🌟" * review.rating}"),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
