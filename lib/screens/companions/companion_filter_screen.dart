import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Companions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'Destination',
            _destinations,
            _destination,
            (value) => setState(() => _destination = value),
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Interest',
            _interests,
            _interest,
            (value) => setState(() => _interest = value),
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Skill',
            _skills,
            _skill,
            (value) => setState(() => _skill = value),
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
                child: const Text('Reset'),
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
                child: const Text('Apply'),
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
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = option == selected;
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onChanged(option);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}



