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
      appBar: AppBar(
        title: const Text("Pinterest"),
      ),
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
  List<QueryDocumentSnapshot> pins = [];
  List<PinModel> images = [];
  bool isLoading = true;
  final ScrollController _controller = ScrollController();
  DocumentSnapshot? lastDocument;
  bool hasMore=false;

  @override
  void initState() {
    super.initState();
    hasMore = true;

    loadImages();
    _fetchPins();

    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 200) {
        _fetchPins();
      }
    });
  }

  Future<void> _fetchPins() async {
  if (isLoading || !hasMore) return;

  setState(() => isLoading = true);

  Query query = FirebaseFirestore.instance
      .collection('pins')
      .orderBy('createdAt', descending: true)
      .limit(10);

  if (lastDocument != null) {
    query = query.startAfterDocument(lastDocument!);
  }

  final snapshot = await query.get();

  if (snapshot.docs.isNotEmpty) {
    lastDocument = snapshot.docs.last;
    pins.addAll(snapshot.docs);
  }

  if (snapshot.docs.length < 10) {
    hasMore = false;
  }

  setState(() => isLoading = false);
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: MasonryGridView.count(
                controller: _controller,
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                itemCount: images.length + pins.length + (hasMore ? 1 : 0),

                itemBuilder: (context, index) {
                  if (index == images.length + pins.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (index < images.length) {
                    final pin = images[index];

                    return PinGridItem(
                      imageUrl: pin.imageUrl,
                      onTap: () {
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
                      },
                    );
                  }

                  final doc = pins[index - images.length];

                  return PinGridItem(
                    imageUrl: doc['imageUrl'],
                    onTap: () {
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
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
