import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../widgets/pin.dart';
import 'pin.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.email?.split('@')[0] ?? 'Username';

    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 36, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              username,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _UserPinsGrid(userId: user?.uid ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserPinsGrid extends StatelessWidget {
  final String userId;

  const _UserPinsGrid({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pins')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final pins = snapshot.data!.docs;

        if (pins.isEmpty) {
          return const Center(child: Text('No has creado pins'));
        }

        return MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          itemCount: pins.length,
          itemBuilder: (context, index) {
            final pin = pins[index];
            final imageUrl = pin['imageUrl'] as String;
            final title = pin['title'] as String;
            final description = pin['description'] as String;

            return PinGridItem(
              imageUrl: imageUrl,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PinDetail(
                      imageUrl: imageUrl,
                      title: title,
                      description: description,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}