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

  List<Onomatopoeia> get onomatopoeiaList => _onomatopoeiaList;
  List<Onomatopoeia> get filteredList => _filteredList;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  OnomatopoeiaProvider() {
    loadData(); // FIXED: Changed from _loadData to loadData
  }

  Future<void> loadData() async { // FIXED: Changed from _loadData to loadData
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

  void _applyFilters() {
    List<Onomatopoeia> filtered = _onomatopoeiaList;

    if (_selectedCategory != 'All') {
      filtered = filtered.where((item) => item.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) =>
      item.japanese.toLowerCase().contains(_searchQuery) ||
          item.romaji.toLowerCase().contains(_searchQuery) ||
          item.meaning.toLowerCase().contains(_searchQuery) ||
          item.exampleSentence.toLowerCase().contains(_searchQuery)).toList();
    }

    _filteredList = filtered;
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
}