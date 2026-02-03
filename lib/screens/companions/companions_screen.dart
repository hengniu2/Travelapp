import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/data_service.dart';
import '../../models/companion.dart';
import '../../widgets/rating_widget.dart';
import '../../widgets/price_widget.dart';
import '../../utils/app_theme.dart';
import '../../utils/travel_images.dart';
import 'companion_detail_screen.dart';
import 'companion_filter_screen.dart';

class CompanionsScreen extends StatefulWidget {
  const CompanionsScreen({super.key});

  @override
  State<CompanionsScreen> createState() => _CompanionsScreenState();
}

class _CompanionsScreenState extends State<CompanionsScreen> {
  final DataService _dataService = DataService();
  List<Companion> _companions = [];
  List<Companion> _filteredCompanions = [];
  String _selectedDestination = 'All';
  String _selectedInterest = 'All';
  String _selectedSkill = 'All';

  @override
  void initState() {
    super.initState();
    _loadCompanions();
  }

  void _loadCompanions() {
    _companions = _dataService.getCompanions();
    _filteredCompanions = _companions;
  }

  void _applyFilters() {
    setState(() {
      _filteredCompanions = _companions.where((companion) {
        bool destinationMatch = _selectedDestination == 'All' ||
            companion.destinations.contains(_selectedDestination);
        bool interestMatch = _selectedInterest == 'All' ||
            companion.interests.contains(_selectedInterest);
        bool skillMatch = _selectedSkill == 'All' ||
            companion.skills.contains(_selectedSkill);
        return destinationMatch && interestMatch && skillMatch;
      }).toList();
    });
  }

  Future<void> _showFilterDialog() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompanionFilterScreen(
          selectedDestination: _selectedDestination,
          selectedInterest: _selectedInterest,
          selectedSkill: _selectedSkill,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedDestination = result['destination'] ?? 'All';
        _selectedInterest = result['interest'] ?? 'All';
        _selectedSkill = result['skill'] ?? 'All';
      });
      _applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.travelCompanions),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.1),
                  AppTheme.primaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            ),
          ),
        ],
      ),
      body: _filteredCompanions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.1),
                          AppTheme.primaryColor.withOpacity(0.05),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.people_outline,
                      size: 64,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noCompanionsFound,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredCompanions.length,
              itemBuilder: (context, index) {
                final companion = _filteredCompanions[index];
                final gradients = [
                  [const Color(0xFF00C853), const Color(0xFF4DD865)],
                  [const Color(0xFFFF6B35), const Color(0xFFFFB74D)],
                  [const Color(0xFF2979FF), const Color(0xFF00E5FF)],
                  [const Color(0xFFAA00FF), const Color(0xFFFF4081)],
                  [const Color(0xFFFF1744), const Color(0xFFFF6B6B)],
                ];
                final gradient = gradients[index % gradients.length];
                final avatarColor = gradient[0];
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.white.withOpacity(0.95),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: avatarColor.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CompanionDetailScreen(companion: companion),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Enhanced avatar with decorative ring
                          Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: gradient,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: avatarColor.withOpacity(0.4),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(3),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                              child: ClipOval(
                                  child: Image.network(
                                    companion.avatar ?? TravelImages.getCompanionAvatar(index),
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: gradient,
                                          ),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                : null,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: gradient,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                    companion.name[0],
                                            style: const TextStyle(
                                              fontSize: 32,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                ),
                              ),
                              // Online status indicator
                              if (companion.isAvailable)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4CAF50),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF4CAF50).withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        companion.name,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: companion.isAvailable
                                              ? [const Color(0xFF4CAF50), const Color(0xFF66BB6A)]
                                              : [const Color(0xFFE53935), const Color(0xFFEF5350)],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (companion.isAvailable
                                                ? const Color(0xFF4CAF50)
                                                : const Color(0xFFE53935))
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            companion.isAvailable
                                                ? Icons.check_circle
                                                : Icons.cancel,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 4),
                                Text(
                                            companion.isAvailable
                                                ? l10n.available
                                                : l10n.unavailable,
                                  style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                RatingWidget(
                                  rating: companion.rating,
                                  reviewCount: companion.reviewCount,
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: companion.destinations
                                      .take(3)
                                      .map((dest) => Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  avatarColor.withOpacity(0.15),
                                                  avatarColor.withOpacity(0.08),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(
                                                color: avatarColor.withOpacity(0.3),
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.place,
                                                  size: 14,
                                                  color: avatarColor,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  dest,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: avatarColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    PriceWidget(
                                      price: companion.pricePerDay,
                                      prefix: '¥',
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            avatarColor.withOpacity(0.1),
                                            avatarColor.withOpacity(0.05),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: avatarColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}



