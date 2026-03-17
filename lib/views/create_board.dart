import 'package:flutter/material.dart';
import '../services/board_service.dart';
import '../models/board_model.dart';

class CreateBoard extends StatefulWidget {
  const CreateBoard({super.key});

  @override
  State<CreateBoard> createState() => _CreateBoardState();
}

class _CreateBoardState extends State<CreateBoard> {

  final TextEditingController nameController = TextEditingController();
  final BoardService boardService = BoardService();

  void createBoard() async {

    final board = Board(
      id: '',
      name: nameController.text,
      userId: "demoUser", 
      createdAt: DateTime.now(),
    );

    await boardService.createBoard(board);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Crear Board")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nombre del Board",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: createBoard,
              child: const Text("Crear"),
            )
          ],
        ),
      ),
    );
  }
}