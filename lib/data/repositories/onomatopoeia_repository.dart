import 'package:onomatopoeia_app/data/models/onomatopoeia_model.dart';
import 'package:onomatopoeia_app/services/json_onomatopoeia_service.dart';

class OnomatopoeiaRepository {
  final JsonOnomatopoeiaService _jsonService = JsonOnomatopoeiaService();
  List<Onomatopoeia>? _cachedList;

  Future<List<Onomatopoeia>> getOnomatopoeiaList() async {
    if (_cachedList != null) {
      return _cachedList!;
    }

    try {
      _cachedList = await _jsonService.loadOnomatopoeiaData();
      return _cachedList!;
    } catch (e) {
      print('Error loading from JSON: $e');
      // Fallback to hardcoded data if JSON fails
      return _getFallbackData();
    }
  }

  List<Onomatopoeia> _getFallbackData() {
    // Your existing hardcoded data here as fallback
    return [];
  }

  Future<Map<String, dynamic>> getMetadata() async {
    return await _jsonService.loadMetadata();
  }

  Future<List<String>> getCategories() async {
    final metadata = await getMetadata();
    final categories = metadata['categories'] as Map<String, dynamic>?;
    if (categories != null) {
      return ['All', ...categories.keys];
    }
    return [
      'All',
      'Animal',
      'Nature',
      'Human',
      'Object',
      'Food',
      'Vehicle',
      'Music',
      'Technology'
    ];
  }

  Future<Map<String, List<String>>> getSubCategories() async {
    final metadata = await getMetadata();
    final categories = metadata['categories'] as Map<String, dynamic>?;
    if (categories != null) {
      final result = <String, List<String>>{};
      categories.forEach((key, value) {
        result[key] = [
          'All',
          ...List<String>.from(value['subCategories'] ?? [])
        ];
      });
      return result;
    }
    return {};
  }

  Future<Map<String, String>> getCategoryDescriptions() async {
    final metadata = await getMetadata();
    final categories = metadata['categories'] as Map<String, dynamic>?;
    if (categories != null) {
      final result = <String, String>{};
      categories.forEach((key, value) {
        result[key] = value['description'] ?? '';
      });
      return result;
    }
    return {};
  }
}
