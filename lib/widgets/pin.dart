import 'package:flutter/material.dart';
import '../widgets/board_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/pin_firebase_service.dart';

class PinGridItem extends StatelessWidget {
  final String imageUrl;
  final String? title;
  final String? description;
  final VoidCallback? onTap;

  const PinGridItem({
    super.key,
    required this.imageUrl,
    this.title,
    this.description,
    this.onTap,
  });
  void showBoardSelector(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return BoardSelector(
          userId: user.uid,
          onBoardSelected: (board) async {

            await PinService.uploadPin(
              imageFile: null, 
              imageUrl: imageUrl,
              title: title ?? '',
              description: description ?? '',
              boardId: board.id,
            );

            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Guardado en board")),
            );
          },
        );
      },
    );
  }
 @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [

            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),

            Positioned(
              bottom: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  showBoardSelector(context);
                },
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.push_pin,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}