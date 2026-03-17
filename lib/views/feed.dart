import 'package:flutter/material.dart';
import 'package:pinterest/views/upload_popup.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/pin_model.dart';
import '../services/unsplash.dart';
import '../widgets/pin.dart';
import 'pin.dart';
import 'search.dart';
import 'profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  int currentIndex = 0;
  final screens = const [FeedContent(), Search(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 2) {
            showUploadPopup(context);
          } else {
            setState(() => currentIndex = index > 2 ? index - 1 : index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        fixedColor: Colors.black,
        unselectedItemColor: Colors.blueGrey,
      ),
    );
  }
}

class FeedContent extends StatefulWidget {
  const FeedContent({super.key});

  @override
  State<FeedContent> createState() => _FeedContentState();
}

class _FeedContentState extends State<FeedContent> {
  final UnsplashService _unsplashService = UnsplashService();
  List<PinModel> images = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<void> loadImages() async {
    images = await _unsplashService.fetchImages(query: 'random');
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Text(
                  "Para ti",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('pins').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final firestorePins = snapshot.data!.docs;

                final allImages = [
                  ...images,
                  ...firestorePins.map(
                    (doc) => PinModel(
                      imageUrl: doc['imageUrl'],
                      title: doc['title'],
                      description: doc['description'],
                    ),
                  ),
                ];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    itemCount: allImages.length,

                    itemBuilder: (context, index) {
                      final pin = allImages[index];

                      return PinGridItem(
                        imageUrl: pin.imageUrl,
                        onTap: () {
                          if (index >= images.length) {
                            final doc = firestorePins[index - images.length];

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PinDetail(
                                  imageUrl: doc['imageUrl'],
                                  title: doc['title'],
                                  description: doc['description'],
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PinDetail(
                                  imageUrl: pin.imageUrl,
                                  title: pin.title,
                                  description: pin.description,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
