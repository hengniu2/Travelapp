import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/app_theme.dart';
import '../../utils/tag_localizations.dart';

class CompanionFilterScreen extends StatefulWidget {
  final String selectedDestination;
  final String selectedInterest;
  final String selectedSkill;

  const CompanionFilterScreen({
    super.key,
    required this.selectedDestination,
    required this.selectedInterest,
    required this.selectedSkill,
  });

  @override
  State<CompanionFilterScreen> createState() => _CompanionFilterScreenState();
}

class _CompanionFilterScreenState extends State<CompanionFilterScreen> {
  late String _destination;
  late String _interest;
  late String _skill;

  final List<String> _destinations = [
    'All',
    'Paris',
    'Rome',
    'Barcelona',
    'Tokyo',
    'Seoul',
    'Bangkok',
    'New York',
    'London',
    'Amsterdam',
  ];

  final List<String> _interests = [
    'All',
    'History',
    'Art',
    'Food',
    'Culture',
    'Technology',
    'Architecture',
    'Museums',
    'Nightlife',
  ];

  final List<String> _skills = [
    'All',
    'Photography',
    'French',
    'Guiding',
    'Japanese',
    'Planning',
    'English',
  ];

  @override
  void initState() {
    super.initState();
    _destination = widget.selectedDestination;
    _interest = widget.selectedInterest;
    _skill = widget.selectedSkill;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.filterCompanions),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            l10n.destinations,
            _destinations,
            _destination,
            (value) => setState(() => _destination = value),
            (v) => v == 'All' ? l10n.all : TagLocalizations.destination(l10n.localeName, v),
          ),
          const SizedBox(height: 24),
          _buildSection(
            l10n.interests,
            _interests,
            _interest,
            (value) => setState(() => _interest = value),
            (v) => v == 'All' ? l10n.all : TagLocalizations.interest(l10n.localeName, v),
          ),
          const SizedBox(height: 24),
          _buildSection(
            l10n.skills,
            _skills,
            _skill,
            (value) => setState(() => _skill = value),
            (v) => v == 'All' ? l10n.all : TagLocalizations.skill(l10n.localeName, v),
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
                    _destination = 'All';
                    _interest = 'All';
                    _skill = 'All';
                  });
                },
                child: Text(l10n.reset),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'destination': _destination,
                    'interest': _interest,
                    'skill': _skill,
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
    String Function(String) displayLabel,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
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
                displayLabel(option),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : AppTheme.textPrimary,
                ),
              ),
              selected: isSelected,
              onSelected: (value) {
                if (value) onChanged(option);
              },
              backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              selectedColor: AppTheme.primaryColor,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected
                    ? AppTheme.primaryColor
                    : theme.colorScheme.outline.withValues(alpha: 0.6),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}



