import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pin_model.dart';
import '../services/unsplash.dart';
import '../widgets/pin.dart';
import 'pin.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<String> searchHistory = [];

  final UnsplashService _unsplashService = UnsplashService();

  List<PinModel> images = [];

  bool isLoading = false;

  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> searchImages(String query, {bool saveToHistory = true}) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return;
    }

    if (saveToHistory) {
      await saveSearch(trimmedQuery);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    images = await _unsplashService.fetchImages(query: trimmedQuery);

    if (!mounted) {
      return;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    searchHistory = prefs.getStringList('searchHistory') ?? [];
    setState(() {});
  }

  Future<void> saveSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();

    searchHistory.remove(query);
    searchHistory.insert(0, query);

    if (searchHistory.length > 5) {
      searchHistory.removeLast();
    }

    await prefs.setStringList('searchHistory', searchHistory);
  }

  @override
  void initState() {
    super.initState();
    loadHistory();
    // Fetch initial inspiration suggestions so the screen is not empty
    final topics = ['inspiration', 'home decor', 'outfits', 'tattoos', 'quotes', 'painting', 'photography'];
    final query = topics[Random().nextInt(topics.length)];
    searchImages(query, saveToHistory: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Search ideas",
            border: InputBorder.none,
          ),
          onSubmitted: searchImages,
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchHistory.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Recent searches",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

          if (searchHistory.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 8,
                children: searchHistory.map((term) {
                  return ActionChip(
                    label: Text(term),
                    onPressed: () {
                      controller.text = term;
                      searchImages(term);
                    },
                  );
                }).toList(),
              ),
            ),

          const SizedBox(height: 10),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    padding: const EdgeInsets.all(8),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return PinGridItem(
                        imageUrl: images[index].imageUrl,
                        onTap: () {
                          final selectedPin = images[index];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PinDetail(
                                imageUrl: selectedPin.imageUrl,
                                title: selectedPin.title,
                                description: selectedPin.description,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}