import 'package:flutter/material.dart';
import 'package:pinterest/views/upload_popup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 
import '../widgets/pin.dart';
import 'search.dart';
import 'profile.dart';
import 'pin.dart';

class Photo {
  final String title;
  final String url;

  Photo({required this.title, required this.url});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      title: json['title'],
      url: json['url'], 
    );
  }
}

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
    int currentIndex = 0;
    final screens = const[
      FeedContent(),
      Search(),
      Profile(),
    ];
    
   
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
            setState(() => currentIndex = index> 2 ? index - 1 : index);
          }
        },
        items: const [  
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],fixedColor: Colors.black,
        unselectedItemColor: Colors.blueGrey,
        
      ),
    );
  }
}

class FeedContent extends StatelessWidget {
  const FeedContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Para ti'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return PinGridItem(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PinDetail(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}