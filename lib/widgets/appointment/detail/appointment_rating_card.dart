import 'package:flutter/material.dart';

class AppointmentRatingCard extends StatelessWidget {
final double rating;
final String comment;

const AppointmentRatingCard({
super.key,
required this.rating,
required this.comment,
});

@override
Widget build(BuildContext context) {
final roundedRating = rating.round();


return Card(
  margin: const EdgeInsets.only(top: 16),
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rating & Review',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Row(
              children: List.generate(
                5,
                (index) {
                  return Icon(
                    index < roundedRating
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 24,
                  );
                },
              ),
            ),

            const SizedBox(width: 10),

            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        if (comment.trim().isNotEmpty) ...[
          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Text(
              comment.trim(),
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ],
    ),
  ),
);


}
}
