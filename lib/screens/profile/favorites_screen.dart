import 'package:flutter/material.dart';
import '../../providers/app_provider.dart';
import 'package:provider/provider.dart';
import '../../services/data_service.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final favorites = appProvider.favorites;
    final dataService = DataService();

    if (favorites.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
        ),
        body: const Center(child: Text('No favorites yet')),
      );
    }

    final companions = dataService.getCompanions();
    final tours = dataService.getTours();
    final hotels = dataService.getHotels();

    final favoriteItems = <Map<String, dynamic>>[];

    for (final id in favorites) {
      try {
        final companion = companions.firstWhere((c) => c.id == id);
        favoriteItems.add({
          'type': 'companion',
          'name': companion.name,
          'id': id,
        });
      } catch (e) {
        try {
          final tour = tours.firstWhere((t) => t.id == id);
          favoriteItems.add({
            'type': 'tour',
            'name': tour.title,
            'id': id,
          });
        } catch (e) {
          try {
            final hotel = hotels.firstWhere((h) => h.id == id);
            favoriteItems.add({
              'type': 'hotel',
              'name': hotel.name,
              'id': id,
            });
          } catch (_) {
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          final item = favoriteItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: Icon(_getIcon(item['type'])),
              title: Text(item['name']),
              subtitle: Text(item['type']),
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  appProvider.toggleFavorite(item['id']);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'companion':
        return Icons.people;
      case 'tour':
        return Icons.explore;
      case 'hotel':
        return Icons.hotel;
      default:
        return Icons.star;
    }
  }
}

