import 'dart:convert';

import 'package:flutter/foundation.dart';

class Document {
  final Map<String, Object?> _json;
  Document() : _json = jsonDecode(documentJson);

  (String, {DateTime modified}) get metadata {
    // 源代码
    // Add from here...
    // if (_json.containsKey('metadata')) {                     // Modify from here...
    //   final metadataJson = _json['metadata'];
    //   if (metadataJson is Map) {
    //     final title = metadataJson['title'] as String;
    //     final localModified =
    //         DateTime.parse(metadataJson['modified'] as String);
    //     return (title, modified: localModified);
    //   }
    // }
    // throw const FormatException('Unexpected JSON');

    /*
    Here, you see a new kind of if-statement (introduced in Dart 3), the if-case. The case body only executes if the case pattern matches the data in _json. This match accomplishes the same checks you wrote in the first version of metadata to validate the incoming JSON. This code validates the following:

    _json is a Map type.
    _json contains a metadata key.
    _json is not null.
    _json['metadata'] is also a Map type.
    _json['metadata'] contains the keys title and modified.
    title and localModified are strings and aren't null.
    */
    if (_json // Modify from here...
        case {
          'metadata': {
            'title': String title,
            'modified': String localModified,
          }
        }) {
      return (title, modified: DateTime.parse(localModified));
    } else {
      throw const FormatException('Unexpected JSON');
    }
  }

  List<Block> getBlocks() {
    if (_json case {'blocks': List blocksJson}) {
      return [for (final blockJson in blocksJson) Block.fromJson(blockJson)];
    } else {
      throw const FormatException('Unexpected JSON format');
    }
  }

}

sealed class Block {
  Block();

  factory Block.fromJson(Map<String, Object?> json) {
    return switch (json) {
      {'type': 'h1', 'text': String text} => HeaderBlock(text),
      {'type': 'p', 'text': String text} => ParagraphBlock(text),
      {'type': 'checkbox', 'text': String text, 'checked': bool checked} =>
        CheckboxBlock(text, checked),
      _ => throw const FormatException('Unexpected JSON format'),
    };
  }
}

class HeaderBlock extends Block {
  final String text;
  HeaderBlock(this.text);
}

class ParagraphBlock extends Block {
  final String text;
  ParagraphBlock(this.text);
}

class CheckboxBlock extends Block {
  final String text;
  final bool isChecked;
  CheckboxBlock(this.text, this.isChecked);
}

const documentJson = '''
{
  "metadata": {
    "title": "My Document",
    "modified": "2023-05-10"
  },
  "blocks": [
    {
      "type": "h1",
      "text": "Chapter 1"
    },
    {
      "type": "p",
      "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    },
    {
      "type": "checkbox",
      "checked": false,
      "text": "Learn Dart 3"
    }
  ]
}
''';
