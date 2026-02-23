import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Username'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Username',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: const [
                  Text('Board1'),
                  SizedBox(height: 8),
                  Placeholder(fallbackHeight: 120),
                  SizedBox(height: 16),
                  Text('Board2'),
                  SizedBox(height: 8),
                  Placeholder(fallbackHeight: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}