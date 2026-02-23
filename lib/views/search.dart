import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Busca ideas',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Keyword1'),
          SizedBox(height: 12),
          Text('Keyword2'),
          SizedBox(height: 12),
          Text('Keyword3'),
          SizedBox(height: 12),
          Text('Keyword4'),
        ],
      ),
    );
  }
}