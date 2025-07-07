import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class BranchProvider with ChangeNotifier {
  List<Branch> _branches = [];
  Branch? _selectedBranch;
  bool _isLoading = false;
  String? _error;

  List<Branch> get branches => _branches;
  Branch? get selectedBranch => _selectedBranch;
  bool get isLoading => _isLoading;
  String? get error => _error;

  BranchProvider() {
    _loadSelectedBranch();
  }

  Future<void> _loadSelectedBranch() async {
    final branchId = await StorageService.getSelectedBranchId();
    if (branchId != null && _branches.isNotEmpty) {
      _selectedBranch = _branches.firstWhere(
        (branch) => branch.id == branchId,
        orElse: () => _branches.first,
      );
      notifyListeners();
    }
  }

  Future<void> fetchBranches() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _branches = await ApiService.getBranches();

      // If no branch is selected, select the first one
      if (_selectedBranch == null && _branches.isNotEmpty) {
        _selectedBranch = _branches.first;
        await StorageService.saveSelectedBranchId(_selectedBranch!.id);
      }

      _isLoading = false;
      _error = null;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> selectBranch(Branch branch) async {
    _selectedBranch = branch;
    await StorageService.saveSelectedBranchId(branch.id);
    notifyListeners();
  }

  void clearBranches() {
    _branches = [];
    _selectedBranch = null;
    _error = null;
    notifyListeners();
  }

  void selectBranchById(String branchId) {
    final branch = _branches.firstWhere(
      (b) => b.id == branchId,
      orElse: () => _branches.first,
    );
    selectBranch(branch);
  }

  Branch? getBranchById(String branchId) {
    try {
      return _branches.firstWhere((b) => b.id == branchId);
    } catch (e) {
      return null;
    }
  }

  List<Branch> get activeBranches {
    return _branches.where((branch) => branch.isActive).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
