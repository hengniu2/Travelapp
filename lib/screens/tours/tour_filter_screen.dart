import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/app_theme.dart';

class TourFilterScreen extends StatefulWidget {
  final String selectedType;
  final String selectedSort;

  const TourFilterScreen({
    super.key,
    required this.selectedType,
    required this.selectedSort,
  });

  @override
  State<TourFilterScreen> createState() => _TourFilterScreenState();
}

class _TourFilterScreenState extends State<TourFilterScreen> {
  late String _type;
  late String _sort;

  final List<String> _types = ['All', 'Multi-City', 'City Tour', 'Cruise'];
  final List<String> _sorts = ['Trending', 'Price Low', 'Price High', 'Duration'];

  @override
  void initState() {
    super.initState();
    _type = widget.selectedType;
    _sort = widget.selectedSort;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.filterTours),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'Route Type',
            _types,
            _type,
            (value) => setState(() => _type = value),
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Sort By',
            _sorts,
            _sort,
            (value) => setState(() => _sort = value),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _type = 'All';
                    _sort = 'Trending';
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: BorderSide(color: AppTheme.primaryColor, width: 2),
                ),
                child: Text(
                  l10n.reset,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'type': _type,
                    'sort': _sort,
                  });
                },
                child: Text(l10n.apply),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    List<String> options,
    String selected,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = option == selected;
            return FilterChip(
              label: Text(
                option,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : AppTheme.textPrimary,
                ),
              ),
              selected: isSelected,
              onSelected: (value) {
                if (value) onChanged(option);
              },
              backgroundColor: Colors.grey.shade200,
              selectedColor: AppTheme.primaryColor,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected ? AppTheme.primaryColor : Colors.grey.shade400,
                width: 1.5,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}



