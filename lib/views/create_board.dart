import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/board_model.dart';
import '../services/board_service.dart';

class CreateBoard extends StatefulWidget {
  const CreateBoard({super.key});

  @override
  State<CreateBoard> createState() => _CreateBoardState();
}

class _CreateBoardState extends State<CreateBoard> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController nameController = TextEditingController();
  final BoardService boardService = BoardService();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> createBoard() async {
    final board = Board(
      id: '',
      name: nameController.text,
      userId: user!.uid,
      createdAt: DateTime.now(),
    );

    await boardService.createBoard(board);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Board')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre del Board'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: createBoard,
              child: const Text('Crear'),
            ),
          ],
        ),
      ),
    );
  }
}