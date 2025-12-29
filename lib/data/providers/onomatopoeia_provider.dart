import 'package:flutter/material.dart';
import 'package:onomatopoeia_app/data/models/onomatopoeia_model.dart';
import 'package:onomatopoeia_app/data/repositories/onomatopoeia_repository.dart';

class OnomatopoeiaProvider extends ChangeNotifier {
  final OnomatopoeiaRepository _repository = OnomatopoeiaRepository();

  List<Onomatopoeia> _onomatopoeiaList = [];
  List<Onomatopoeia> _filteredList = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isLoading = false;

  // Advanced filter variables
  List<int> _selectedDifficulties = [];
  List<String> _selectedSoundTypes = [];
  String _currentSortType = 'default';

  List<Onomatopoeia> get onomatopoeiaList => _onomatopoeiaList;
  List<Onomatopoeia> get filteredList => _filteredList;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  List<int> get selectedDifficulties => _selectedDifficulties;
  List<String> get selectedSoundTypes => _selectedSoundTypes;
  String get currentSortType => _currentSortType;

  OnomatopoeiaProvider() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _onomatopoeiaList = _repository.getOnomatopoeiaList();
    _filteredList = _onomatopoeiaList;

    _isLoading = false;
    notifyListeners();
  }

  void searchOnomatopoeia(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  // Public method for advanced filtering
  void applyFilters({
    List<int> difficulties = const [],
    List<String> soundTypes = const [],
    String sortType = 'default',
  }) {
    _selectedDifficulties = difficulties;
    _selectedSoundTypes = soundTypes;
    _currentSortType = sortType;

    _applyFilters();
  }

  void _applyFilters() {
    List<Onomatopoeia> filtered = _onomatopoeiaList;

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered.where((item) => item.category == _selectedCategory).toList();
    }

    // Apply difficulty filter
    if (_selectedDifficulties.isNotEmpty) {
      filtered = filtered.where((item) => _selectedDifficulties.contains(item.difficulty)).toList();
    }

    // Apply sound type filter
    if (_selectedSoundTypes.isNotEmpty) {
      filtered = filtered.where((item) => _selectedSoundTypes.contains(item.soundType)).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) =>
      item.japanese.toLowerCase().contains(_searchQuery) ||
          item.romaji.toLowerCase().contains(_searchQuery) ||
          item.meaning.toLowerCase().contains(_searchQuery) ||
          item.exampleSentence.toLowerCase().contains(_searchQuery)).toList();
    }

    // Apply sorting
    _applySorting(filtered);
  }

  void _applySorting(List<Onomatopoeia> list) {
    List<Onomatopoeia> sortedList = List.from(list);

    switch (_currentSortType) {
      case 'japanese_asc':
        sortedList.sort((a, b) => a.japanese.compareTo(b.japanese));
        break;
      case 'japanese_desc':
        sortedList.sort((a, b) => b.japanese.compareTo(a.japanese));
        break;
      case 'difficulty_asc':
        sortedList.sort((a, b) => a.difficulty.compareTo(b.difficulty));
        break;
      case 'difficulty_desc':
        sortedList.sort((a, b) => b.difficulty.compareTo(a.difficulty));
        break;
      case 'popularity_desc':
        sortedList.sort((a, b) => b.viewCount.compareTo(a.viewCount));
        break;
      case 'date_desc':
        sortedList.sort((a, b) => b.addedDate.compareTo(a.addedDate));
        break;
      case 'default':
      default:
      // Keep original order
        break;
    }

    _filteredList = sortedList;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final index = _onomatopoeiaList.indexWhere((item) => item.id == id);
    if (index != -1) {
      _onomatopoeiaList[index] = _onomatopoeiaList[index].copyWith(
        isFavorite: !_onomatopoeiaList[index].isFavorite,
      );
      _applyFilters();
    }
  }

  void incrementViewCount(String id) {
    final index = _onomatopoeiaList.indexWhere((item) => item.id == id);
    if (index != -1) {
      _onomatopoeiaList[index] = _onomatopoeiaList[index].copyWith(
        viewCount: _onomatopoeiaList[index].viewCount + 1,
      );
      notifyListeners();
    }
  }

  List<Onomatopoeia> getFavorites() {
    return _onomatopoeiaList.where((item) => item.isFavorite).toList();
  }

  List<String> getCategories() {
    return _repository.getCategories();
  }

  void sortOnomatopoeia(String sortType) {
    _currentSortType = sortType;
    _applyFilters();
  }

  // Clear all filters
  void clearAllFilters() {
    _selectedCategory = 'All';
    _selectedDifficulties = [];
    _selectedSoundTypes = [];
    _searchQuery = '';
    _currentSortType = 'default';
    _filteredList = _onomatopoeiaList;
    notifyListeners();
  }
}