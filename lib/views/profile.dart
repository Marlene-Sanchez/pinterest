import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../widgets/pin.dart';
import 'pin.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;
    final username = user?.email?.split('@')[0] ?? 'Username';

    return Scaffold(

      appBar: AppBar(
        title: Text(username),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pins"),
            Tab(text: "Boards"),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [

          Padding(
            padding: const EdgeInsets.all(16),
            child: _UserPinsGrid(userId: user?.uid ?? ''),
          ),

          _buildBoards(),

        ],
      ),
    );
  }
  Widget _buildBoards() {

    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(

      stream: FirebaseFirestore.instance
          .collection("boards")
          .where("userId", isEqualTo: user!.uid)
          .orderBy("createdAt", descending: true)
          .snapshots(),

      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final boards = snapshot.data!.docs;

        if (boards.isEmpty) {
          return const Center(
            child: Text("No boards yet"),
          );
        }

        return GridView.builder(

          padding: const EdgeInsets.all(16),

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),

          itemCount: boards.length,

          itemBuilder: (_, i) {

            final board = boards[i];

            return Card(
              child: Center(
                child: Text(
                  board["name"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        );
      },
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