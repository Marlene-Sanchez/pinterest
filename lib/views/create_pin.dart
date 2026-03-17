import 'package:flutter/material.dart';
import 'dart:io';
import '../services/pin_firebase_service.dart';

class CreatePin extends StatefulWidget {
  final File imageFile;
  const CreatePin({

    super.key,
    required this.imageFile
    });

  @override
  State<CreatePin> createState() => _CreatePinState();

}


class _CreatePinState extends State<CreatePin> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void savePin() async {

  String title = _titleController.text.trim();
  String description = _descriptionController.text.trim();

  if (title.isEmpty || description.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("El título o descripción están vacíos")),
    );
    return;
  }

  try {

    await PinService.uploadPin(
      imageFile: widget.imageFile,
      title: title,
      description: description,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Pin creado"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error al subir el pin: $e"),
        backgroundColor: Colors.red,
      ),
    );

  }
}



  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Pin"),
      ),
      body: Column(
        children: [

          Expanded(
            child: Image.file(
              widget.imageFile,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          /// mini forms
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: "Título",
                    border: OutlineInputBorder()
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: "Descripción",
                    border:OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(        
                  onPressed: () {
                    savePin();
                  },
                  child: const Text("Guardar Pin"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
