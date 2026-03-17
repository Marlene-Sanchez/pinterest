import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'create_pin.dart';
import 'dart:io';
final ImagePicker _picker = ImagePicker();
Future<void> pickFromCamera(BuildContext context) async {
  final XFile? image = await _picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 80,
  );

  if (image != null) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePin(imageFile: File(image!.path)),
      ),
    );
  }
}

Future<void> pickFromGallery(BuildContext context) async {
  final XFile? image = await _picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
  );

  if (image != null) {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePin(imageFile: File(image.path)),
      ),
    );
  }
}
void showUploadPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Comienza a crear ahora',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],

            ),
            const SizedBox(height: 24),
            Row(
              children: [
                _UploadOption(
                  icon: Icons.push_pin,
                  label: 'Pin',
                  onTap: () {
                    Navigator.pop(context);
                    showPinSourcePopup(context);
                  },
                ),
                const SizedBox(width: 24),

                _UploadOption(
                  icon: Icons.dashboard,
                  label: 'Board',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
  
}

void showPinSourcePopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Text(
              "Crear Pin",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                _UploadOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () => pickFromCamera(context),
                ),

                const SizedBox(width: 32),

                _UploadOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () => pickFromGallery(context),
                ),

              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}


class _UploadOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  
  const _UploadOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 32),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}