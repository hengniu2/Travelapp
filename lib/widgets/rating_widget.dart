import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double size;

  const RatingWidget({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B35),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, color: Colors.white, size: 12),
              const SizedBox(width: 2),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Text(
          l10n.ratingPoints,
          style: TextStyle(
            fontSize: size - 4,
            color: Colors.grey.shade600,
          ),
        ),
        if (reviewCount > 0) ...[
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              l10n.bookedCount(reviewCount),
              style: TextStyle(
                fontSize: size - 6,
                color: Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
}



