import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Tours'),
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
                child: const Text('Reset'),
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



