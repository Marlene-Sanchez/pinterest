import 'package:flutter/material.dart';
import '../services/board_service.dart';
import '../models/board_model.dart';
import '../views/create_board.dart';

class BoardSelector extends StatelessWidget {
  final String userId;
  final Function(Board) onBoardSelected;

  const BoardSelector({
    super.key,
    required this.userId,
    required this.onBoardSelected,
  });

  @override
  Widget build(BuildContext context) {

    final boardService = BoardService();

    return Container(
      padding: const EdgeInsets.all(16),
      height: 400,
      child: Column(
        children: [

          const Text(
            "Guardar en...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: StreamBuilder<List<Board>>(
              stream: boardService.getBoards(userId),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final boards = snapshot.data!;

                if (boards.isEmpty) {
                  return const Center(
                    child: Text("Aún no tienes boards"),
                  );
                }

                return ListView.builder(
                  itemCount: boards.length,
                  itemBuilder: (context, index) {

                    final board = boards[index];

                    return ListTile(
                      leading: const Icon(Icons.dashboard),
                      title: Text(board.name),
                      onTap: () {
                        onBoardSelected(board);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Crear Board"),
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateBoard(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}