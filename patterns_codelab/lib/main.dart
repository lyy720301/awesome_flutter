import 'package:flutter/material.dart';

import 'data.dart';

void main() {
  runApp(const DocumentApp());
}

/// switch表达式
String formatDate(DateTime dateTime) {
  final today = DateTime.now();
  final difference = dateTime.difference(today);

  return switch (difference) {
    Duration(inDays: 0) => 'today',
    Duration(inDays: 1) => 'tomorrow',
    Duration(inDays: -1) => 'yesterday',
    Duration(inDays: final days) when days > 7 =>
      '${days ~/ 7} weeks from now', // Add from here
    Duration(inDays: final days) when days < -7 =>
      '${days.abs() ~/ 7} weeks ago', // to here.
    Duration(inDays: final days, isNegative: true) => '${days.abs()} days ago',
    Duration(inDays: final days) => '$days days from now',
  };
}

class DocumentApp extends StatelessWidget {
  const DocumentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: DocumentScreen(
        document: Document(),
      ),
    );
  }
}

class DocumentScreen extends StatelessWidget {
  final Document document;

  const DocumentScreen({
    required this.document,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final (title, modified: lastmodified) = document.metadata; // Modify
    // final (title, :modified) = document.metadata; // Modify
    final formattedModifiedDate = formatDate(lastmodified); // Add this line

    final blocks = document.getBlocks();
    return Scaffold(
      appBar: AppBar(
        title: Text(title), // Modify this line,
      ),
      body: Column(
        children: [
          Text('Last modified: $formattedModifiedDate'), // Modify from here
          Expanded(
            child: ListView.builder(
              itemCount: blocks.length,
              itemBuilder: (context, index) {
                return BlockWidget(block: blocks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BlockWidget extends StatelessWidget {
  final Block block;

  const BlockWidget({
    required this.block,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: switch (block) {
        HeaderBlock(:final text) => Text(
            text,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ParagraphBlock(:final text) => Text(text),
        CheckboxBlock(:final text, :var isChecked) => Row(
            children: [
              Checkbox(
                  value: isChecked,
                  onChanged: (_) {
                    
                  }),
              Text(text),
            ],
          ),
      },
    );
  }
}
