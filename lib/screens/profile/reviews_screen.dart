import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import '../../widgets/image_first_card.dart';
import '../../widgets/empty_state.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../../l10n/app_localizations.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataService = DataService();
    final reviews = dataService.getReviews('1', 'companion');

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myReviews),
      ),
      body: reviews.isEmpty
          ? EmptyState(
              icon: Icons.rate_review_outlined,
              headline: AppLocalizations.of(context)!.noReviewsYet,
              subtitle: AppLocalizations.of(context)!.reviewsEmptySubtitle,
              iconColor: AppTheme.categoryOrange,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ImageFirstCard(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppTheme.primaryColor.withOpacity(0.15),
                              child: review.userAvatar != null
                                  ? ClipOval(
                                      child: Image.network(
                                        review.userAvatar!,
                                        width: 48,
                                        height: 48,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Text(
                                      review.userName.isNotEmpty
                                          ? review.userName[0].toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: AppDesignSystem.spacingMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review.userName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (i) => Icon(
                                        i < review.rating.toInt()
                                            ? Icons.star
                                            : Icons.star_border,
                                        size: 18,
                                        color: AppTheme.categoryOrange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              review.date.toString().split(' ').first,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDesignSystem.spacingMd),
                        Text(
                          review.comment,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textPrimary,
                            height: 1.4,
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

