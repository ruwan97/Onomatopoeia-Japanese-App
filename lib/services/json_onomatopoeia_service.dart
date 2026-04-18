import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:onomatopoeia_app/data/models/onomatopoeia_model.dart';

class JsonOnomatopoeiaService {
  static const String _dataPath = 'assets/data/onomatopoeia.json';

  Future<List<Onomatopoeia>> loadOnomatopoeiaData() async {
    try {
      final String jsonString = await rootBundle.loadString(_dataPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final List<dynamic> onomatopoeiaList = jsonData['onomatopoeia'];

      return onomatopoeiaList
          .map((json) => Onomatopoeia.fromJson(json))
          .toList();
    } catch (e) {
      print('Error loading JSON data: $e');
      throw Exception('Failed to load onomatopoeia data');
    }
  }

  Future<Map<String, dynamic>> loadMetadata() async {
    try {
      final String jsonString = await rootBundle.loadString(_dataPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return jsonData['metadata'] ?? {};
    } catch (e) {
      print('Error loading metadata: $e');
      return {};
    }
  }
}
