import 'package:flutter/material.dart';

class AIModelDefinition {
  final String name;
  final String desc;
  final String apiUrl;
  final IconData icon;
  final Color color;
  final List<AIModelFieldDefinition> fields;

  const AIModelDefinition({
    required this.name,
    required this.desc,
    required this.icon,
    required this.color,
    required this.apiUrl,
    required this.fields,
  });
}

class AIModelFieldDefinition {
  final String key;
  final String label;
  final String hint;
  final TextInputType type;

  const AIModelFieldDefinition({
    required this.key,
    required this.label,
    required this.hint,
    required this.type,
  });
}
