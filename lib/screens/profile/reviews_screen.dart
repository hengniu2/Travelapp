import 'package:flutter/material.dart';
import '../../services/data_service.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = DataService();
    final reviews = dataService.getReviews('1', 'companion');

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reviews'),
      ),
      body: reviews.isEmpty
          ? const Center(child: Text('No reviews yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.blue.shade100,
                              child: review.userAvatar != null
                                  ? Image.network(review.userAvatar!)
                                  : Text(review.userName[0]),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review.userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (i) => Icon(
                                        i < review.rating.toInt()
                                            ? Icons.star
                                            : Icons.star_border,
                                        size: 16,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(review.comment),
                        const SizedBox(height: 8),
                        Text(
                          review.date.toString().split(' ')[0],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

