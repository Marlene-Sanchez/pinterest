import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/board_model.dart';
import '../services/pin_firebase_service.dart';
import '../widgets/board_selector.dart';

class CreatePin extends StatefulWidget {
  final File imageFile;

  const CreatePin({
    super.key,
    required this.imageFile,
  });

  @override
  State<CreatePin> createState() => _CreatePinState();
}

class _CreatePinState extends State<CreatePin> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Pin')),
      body: Column(
        children: [
          Expanded(
            child: Image.file(
              widget.imageFile,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Titulo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Descripcion',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showBoardSelector(context, (Board board) async {
                      final title = _titleController.text.trim();
                      final description = _descriptionController.text.trim();

                      if (title.isEmpty || description.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('El titulo o descripcion estan vacios'),
                          ),
                        );
                        return;
                      }

                      final messenger = ScaffoldMessenger.of(context);
                      final navigator = Navigator.of(context);

                      try {
                        await PinService.uploadPin(
                          imageFile: widget.imageFile,
                          title: title,
                          description: description,
                          boardId: board.id,
                        );

                        if (!context.mounted) return;
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('Pin guardado en ${board.name}'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        navigator.pop();
                      } catch (e) {
                        if (!context.mounted) return;
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    });
                  },
                  child: const Text('Guardar Pin'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showBoardSelector(
    BuildContext context,
    Function(Board) onBoardSelected,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return BoardSelector(
          userId: FirebaseAuth.instance.currentUser!.uid,
          onBoardSelected: onBoardSelected,
        );
      },
    );
  }
}