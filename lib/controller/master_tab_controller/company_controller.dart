import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:time_attendance/model/master_tab_model/company_model.dart';

class BranchController extends GetxController {
  // Reactive observable for the current branch
  final branch = BranchModel().obs;

  // List to store actual branch objects
  final branches = <BranchModel>[].obs;

  // Observable lists for master branch types
  final masterBranches = <String>[
    'Head Office',
    'Regional Office',
    'Sales Branch',
    'Customer Service Branch',
    'N / A'
  ].obs;

  final masterBranches1 = <String>[
    'Main Headquarters',
    'Regional Operations',
    'Sales & Distribution',
    'Customer Support',
    'N / A'
  ].obs;

  // Reactive filtered list for search
  final filteredBranches = <BranchModel>[].obs;

  // Search query text
  final searchQuery = ''.obs;

  // Sorting variables
  final sortColumn = Rx<String?>(null);
  final isAscending = true.obs;

  // Constructor to initialize the controller
  BranchController() {
    // Initialize with some default branches
    branches.addAll([
      BranchModel(
        branchName: 'Main Headquarters',
        address: '123 Corporate Plaza',
        contact: '+1 (555) 123-4567',
        website: 'www.mainhq.com',
        masterBranch: 'Main Headquarters'
      ),
      BranchModel(
        branchName: 'Regional Operations',
        address: '456 Regional Street',
        contact: '+1 (555) 987-6543',
        website: 'www.regionalops.com',
        masterBranch: 'Regional Operations'
      )
    ]);

    // Update filtered branches
    updateFilteredBranches();
  }

  // Setter methods for updating branch properties
  void setBranchName(String value) {
    branch.update((val) {
      val?.branchName = value;
    });
  }

  void setAddress(String value) {
    branch.update((val) {
      val?.address = value;
    });
  }

  void setContact(String value) {
    branch.update((val) {
      val?.contact = value;
    });
  }

  void setWebsite(String value) {
    branch.update((val) {
      val?.website = value;
    });
  }

  void setMasterBranch(String? value) {
    branch.update((val) {
      val?.masterBranch = value;
    });
  }

  // Method to sort branches
  void sortBranches(String columnName, bool ascending) {
    sortColumn.value = columnName;
    isAscending.value = ascending;

    // Sort the branches based on the selected column
    branches.sort((a, b) {
      dynamic valueA, valueB;
      switch (columnName) {
        case 'Branch Name':
          valueA = a.branchName ?? '';
          valueB = b.branchName ?? '';
          break;
        case 'Address':
          valueA = a.address ?? '';
          valueB = b.address ?? '';
          break;
        case 'Contact':
          valueA = a.contact ?? '';
          valueB = b.contact ?? '';
          break;
        case 'Website':
          valueA = a.website ?? '';
          valueB = b.website ?? '';
          break;
        case 'Master Branch':
          valueA = a.masterBranch ?? '';
          valueB = b.masterBranch ?? '';
          break;
        default:
          return 0;
      }

      // Perform case-insensitive sorting
      final comparison = valueA.toLowerCase().compareTo(valueB.toLowerCase());
      return ascending ? comparison : -comparison;
    });

    // Update filtered branches after sorting
    updateFilteredBranches();
  }

  // Method to edit an existing branch
  void editBranch(int index) {
    if (index >= 0 && index < branches.length) {
      branch.value = branches[index].copyWith();
    }
  }

  // Save branch method with validation
  void saveBranch() {
    if (branch.value.branchName?.isEmpty ?? true) {
      Get.snackbar(
        'Error',
        'Branch name is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Check if this is a new branch or editing an existing one
    final existingIndex = branches.indexWhere(
      (b) => b.branchName == branch.value.branchName
    );
    
    if (existingIndex != -1) {
      // Update existing branch
      branches[existingIndex] = branch.value;
    } else {
      // Add new branch
      branches.add(branch.value);
    }

    // Update the filtered list
    updateFilteredBranches();

    Get.snackbar(
      'Success',
      'Branch saved successfully',
      snackPosition: SnackPosition.BOTTOM,
    );

    cancelBranch(); // Reset branch
  }

  // Cancel and reset branch
  void cancelBranch() {
    branch.value = BranchModel();
    Get.back();
  }

  // Method to delete a branch
  void deleteBranch(int index) {
    if (index >= 0 && index < branches.length) {
      branches.removeAt(index);

      // Update the filtered list
      updateFilteredBranches();

      Get.snackbar(
        'Success',
        'Branch deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Update filtered branches based on search query and current sorting
  void updateFilteredBranches() {
    if (searchQuery.value.isEmpty) {
      filteredBranches.assignAll(branches);
    } else {
      filteredBranches.assignAll(
        branches.where((branch) => 
          branch.branchName?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false ||
          branch.address!.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false ||
          branch.contact!.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false
        )
      );
    }

    // Re-apply current sorting if a sort column is set
    if (sortColumn.value != null) {
      sortBranches(sortColumn.value!, isAscending.value);
    }
  }

  // Method to update the search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    updateFilteredBranches();
  }

  // Method to get master branch options
  List<String> getMasterBranchOptions() {
    return masterBranches1;
  }
}