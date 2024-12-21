import 'package:get/get.dart';
import 'package:time_attendance/model/master_tab_model/department_model.dart';

class DepartmentsController extends GetxController {
  // Reactive observable for the current department
  final department = departmentModel().obs;

  // Observable lists for departments
  final masterdepartments = <String>[
    'IT Department',
    'HR Department',
    'Finance Department',
    'Sales Department',
    'Operations'
  ].obs;

  final masterdepartments1 = <String>[
    'Information Technology',
    'Human Resources',
    'Finance & Accounting',
    'Sales & Marketing',
    'N / A'
  ].obs;

  // Sorting variables
  final sortColumn = RxString('Department Name');
  final isSortAscending = RxBool(true);

  // Reactive filtered list for search
  final filteredDepartments = <String>[].obs;
  final filteredMasterDepartments = <String>[].obs;

  // Search query text
  final searchQuery = ''.obs;

  // Constructor to initialize the filtered list
  DepartmentsController() {
    updateSearchQuery('');
  }

  // Setter methods for updating department properties
  void setdepartmentName(String value) {
    department.update((val) {
      val?.departmentName = value;
    });
  }

  void setMasterdepartment(String? value) {
    department.update((val) {
      val?.masterdepartment = value;
    });
  }

  // Sorting method
  void sortDepartments(String columnName) {
    if (sortColumn.value == columnName) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      sortColumn.value = columnName;
      isSortAscending.value = true;
    }

    // Perform sorting
    final indices = List.generate(filteredDepartments.length, (index) => index);
    indices.sort((a, b) {
      final compare = (columnName == 'Department Name')
          ? filteredDepartments[a].compareTo(filteredDepartments[b])
          : filteredMasterDepartments[a].compareTo(filteredMasterDepartments[b]);
      return isSortAscending.value ? compare : -compare;
    });

    // Reorder filtered lists based on sorted indices
    filteredDepartments.assignAll([for (var i in indices) filteredDepartments[i]]);
    filteredMasterDepartments.assignAll([for (var i in indices) filteredMasterDepartments[i]]);
  }

  // Save a department
  void savedepartment() {
    if (department.value.departmentName?.isEmpty ?? true) {
      Get.snackbar('Error', 'Department name is required');
      return;
    }

    masterdepartments.add(department.value.departmentName ?? '');
    masterdepartments1.add(department.value.masterdepartment ?? 'N / A');

    updateSearchQuery(searchQuery.value);

    Get.snackbar('Success', 'Department saved successfully');
    canceldepartment();
  }

  void canceldepartment() {
    department.value = departmentModel();
    Get.back();
  }

  void deletedepartment(int index) {
    masterdepartments.removeAt(index);
    masterdepartments1.removeAt(index);
    updateSearchQuery(searchQuery.value);

    Get.snackbar('Success', 'Department deleted successfully');
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filteredDepartments.assignAll(
      query.isEmpty
          ? masterdepartments
          : masterdepartments.where((dep) => dep.toLowerCase().contains(query.toLowerCase())),
    );
    filteredMasterDepartments.assignAll(
      query.isEmpty
          ? masterdepartments1
          : List.generate(masterdepartments.length, (index) {
              if (masterdepartments[index].toLowerCase().contains(query.toLowerCase())) {
                return masterdepartments1[index];
              }
              return null;
            }).whereType<String>(),
    );
  }
}
