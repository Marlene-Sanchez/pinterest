

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest/models/board_model.dart';
import 'package:pinterest/widgets/pin.dart';

class BoardDetail extends StatelessWidget {
  final String boardId;
  final String boardName;

  const BoardDetail({
    super.key,
    required this.boardId,
    required this.boardName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(boardName),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('pins')
            .where('boardId', isEqualTo: boardId)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final pins = snapshot.data!.docs;

          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            padding: const EdgeInsets.all(8),
            itemCount: pins.length,

            itemBuilder: (context, index) {
              final pin = pins[index];

              return PinGridItem(
                imageUrl: pin['imageUrl'],
                title: pin['title'],
                description: pin['description'],
              );
            },
          );
        },
      ),
    );
  }
}