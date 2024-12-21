import 'package:get/get.dart';
import 'package:time_attendance/model/master_tab_model/designation_model.dart';

class DesignationController extends GetxController {
  // Reactive observable for the current designation
  final designation = DesignationModel().obs;

  // Observable lists for designations
  final masterDesignations = <String>[
    'Senior Manager',
    'Site Engineer',
    'Team Lead',
    'Junior Developer',
    'N / A'
  ].obs;

  final MasterDesignations = <String>[
    'Manager',
    'Engineer',
    'Team Lead',
    'Developer',
    'Intern'
  ].obs;

  // Sorting variables
  final sortColumn = RxString('Designation Name');
  final isSortAscending = RxBool(true);

  // Filtered designations list
  final filteredDesignations = <String>[].obs;
  final filteredMasterDesignations = <String>[].obs;

  // Search query text
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    filteredDesignations.assignAll(masterDesignations);
    filteredMasterDesignations.assignAll(MasterDesignations);
  }

  void sortDesignations(String columnName) {
    // Toggle sort order if the same column is clicked
    if (sortColumn.value == columnName) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      sortColumn.value = columnName;
      isSortAscending.value = true;
    }

    // Perform sorting based on the selected column
    switch (columnName) {
      case 'Designation Name':
        _sortByDesignationName();
        break;
      case 'Master Designation':
        _sortByMasterDesignation();
        break;
    }
  }

  void _sortByDesignationName() {
    // Create a parallel sorting index list
    final sortedIndices = List.generate(filteredDesignations.length, (index) => index);
    
    sortedIndices.sort((a, b) {
      return isSortAscending.value 
        ? filteredDesignations[a].compareTo(filteredDesignations[b])
        : filteredDesignations[b].compareTo(filteredDesignations[a]);
    });

    // Reorder both lists based on sorted indices
    final newFilteredDesignations = List<String>.from(filteredDesignations);
    final newFilteredMasterDesignations = List<String>.from(filteredMasterDesignations);

    for (int i = 0; i < sortedIndices.length; i++) {
      newFilteredDesignations[i] = filteredDesignations[sortedIndices[i]];
      newFilteredMasterDesignations[i] = filteredMasterDesignations[sortedIndices[i]];
    }

    filteredDesignations.assignAll(newFilteredDesignations);
    filteredMasterDesignations.assignAll(newFilteredMasterDesignations);
  }

  void _sortByMasterDesignation() {
    // Create a parallel sorting index list
    final sortedIndices = List.generate(filteredMasterDesignations.length, (index) => index);
    
    sortedIndices.sort((a, b) {
      return isSortAscending.value 
        ? filteredMasterDesignations[a].compareTo(filteredMasterDesignations[b])
        : filteredMasterDesignations[b].compareTo(filteredMasterDesignations[a]);
    });

    // Reorder both lists based on sorted indices
    final newFilteredDesignations = List<String>.from(filteredDesignations);
    final newFilteredMasterDesignations = List<String>.from(filteredMasterDesignations);

    for (int i = 0; i < sortedIndices.length; i++) {
      newFilteredDesignations[i] = filteredDesignations[sortedIndices[i]];
      newFilteredMasterDesignations[i] = filteredMasterDesignations[sortedIndices[i]];
    }

    filteredDesignations.assignAll(newFilteredDesignations);
    filteredMasterDesignations.assignAll(newFilteredMasterDesignations);
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      // If query is empty, show all designations
      filteredDesignations.assignAll(masterDesignations);
      filteredMasterDesignations.assignAll(MasterDesignations);
    } else {
      // Filter designations based on the search query
      final searchResults = masterDesignations
          .where((designation) => designation.toLowerCase().contains(query.toLowerCase()))
          .toList();

      filteredDesignations.assignAll(searchResults);
      
      // Update Master designations to match filtered designations
      filteredMasterDesignations.assignAll(
        searchResults.map((designation) {
          final index = masterDesignations.indexOf(designation);
          return index != -1 ? MasterDesignations[index] : '';
        }).toList()
      );
    }

    // Re-apply the last sorting if there was any
    if (sortColumn.value == 'Designation Name') {
      _sortByDesignationName();
    } else if (sortColumn.value == 'Master Designation') {
      _sortByMasterDesignation();
    }
  }

  // Setter methods for updating designation properties
  void setDesignationName(String value) {
    designation.update((val) {
      val?.designationName = value;
    });
  }

  void setMasterDesignation(String? value) {
    designation.update((val) {
      val?.masterDesignation = value;
    });
  }

  // Save designation method with validation
  void saveDesignation() {
    if (designation.value.designationName?.isEmpty ?? true) {
      Get.snackbar(
        'Error',
        'Designation name is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Add the new designation to the list
    if (!masterDesignations.contains(designation.value.designationName)) {
      masterDesignations.add(designation.value.designationName!);
      updateSearchQuery(''); // Update filtered list after adding
    }

    Get.snackbar(
      'Success',
      'Designation saved successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Cancel and reset designation
  void cancelDesignation() {
    designation.value = DesignationModel();
    Get.back();
  }

  // Method to delete a designation
  void deleteDesignation(int index) {
    if (index >= 0 && index < filteredDesignations.length) {
      final designationToDelete = filteredDesignations[index];
      masterDesignations.remove(designationToDelete);
      updateSearchQuery(''); // Update filtered list after deletion
      Get.snackbar(
        'Success',
        'Designation deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}