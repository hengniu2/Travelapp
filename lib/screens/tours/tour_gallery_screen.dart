import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/travel_images.dart';

/// Full-screen photo gallery for tour (or any list of image paths).
class TourGalleryScreen extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const TourGalleryScreen({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  State<TourGalleryScreen> createState() => _TourGalleryScreenState();
}

class _TourGalleryScreenState extends State<TourGalleryScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    final start = widget.initialIndex.clamp(0, widget.imageUrls.isEmpty ? 0 : widget.imageUrls.length - 1);
    _pageController = PageController(initialPage: start);
    _currentIndex = start;
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = _pageController.page?.round() ?? _currentIndex;
    if (page != _currentIndex && mounted) setState(() => _currentIndex = page);
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.imageUrls;
    if (list.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: list.length,
            itemBuilder: (context, index) {
              final url = list[index];
              final isNetwork = url.startsWith('http');
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: isNetwork
                    ? Image.network(
                        url,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => _placeholder(url),
                      )
                    : Image.asset(
                        url,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => _placeholder(url),
                      ),
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pop();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.close, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                  if (list.length > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentIndex + 1} / ${list.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(String url) {
    return TravelImages.buildImageBackground(
      imageUrl: url,
      opacity: 0.5,
      child: const Center(
        child: Icon(Icons.image_outlined, size: 64, color: Colors.white54),
      ),
    );
  }
}
