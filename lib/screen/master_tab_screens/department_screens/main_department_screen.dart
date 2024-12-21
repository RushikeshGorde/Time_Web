import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/master_tab_controller/department_controller.dart';
import 'package:time_attendance/screen/master_tab_screens/department_screens/department_dialog_screen.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';

class MaindepartmentScreen extends StatelessWidget {
  MaindepartmentScreen({super.key});

  final DepartmentsController controller = Get.put(DepartmentsController());
  final TextEditingController _searchController = TextEditingController();
    int _currentPage = 1;
  int _itemsPerPage = 10;
  int _totalPages = 1;
   void _handlePageChange(int page) {
    _currentPage = page;
    controller.update();
  }

  void _handleItemsPerPageChange(int itemsPerPage) {
    _itemsPerPage = itemsPerPage;
    _currentPage = 1;
    controller.update();
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Departments'),
          content: ReusableSearchField(
            searchController: _searchController,
            onSearchChanged: controller.updateSearchQuery,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Department'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (MediaQuery.of(context).size.width > 600)
            ReusableSearchField(
              searchController: _searchController,
              onSearchChanged: (query) => controller.updateSearchQuery(query),
            ),
          const SizedBox(width: 20),
          CustomActionButton(
            label: 'Add Department',
            onPressed: () => _showDepartmentDialog(context),
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage: 'Manage departments here.',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            if (MediaQuery.of(context).size.width <= 600)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ReusableSearchField(
                  searchController: _searchController,
                  onSearchChanged: (query) => controller.updateSearchQuery(query),
                ),
              ),
            Expanded(
              child: ReusableTableAndCard(
                data: List.generate(controller.filteredDepartments.length, (index) {
                  return {
                    'Department Name': controller.filteredDepartments[index],
                    'Master Department': controller.filteredMasterDepartments[index],
                  };
                }),
                headers: ['Department Name', 'Master Department', 'Actions'],
                visibleColumns: ['Department Name', 'Master Department', 'Actions'],
                onSort: (columnName, ascending) => controller.sortDepartments(columnName),
                onEdit: (row) {
                  final index = controller.filteredDepartments.indexOf(row['Department Name']!);
                  if (index != -1) _showEditDialog(context, index);
                },
                onDelete: (row) {
                  final index = controller.filteredDepartments.indexOf(row['Department Name']!);
                  if (index != -1) _showDeleteConfirmationDialog(context, index);
                },
              ),
            ),
             PaginationWidget(
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                    onFirstPage: () => _handlePageChange(1),
                    onPreviousPage: () => _handlePageChange(_currentPage - 1),
                    onNextPage: () => _handlePageChange(_currentPage + 1),
                    onLastPage: () => _handlePageChange(_totalPages),
                    onItemsPerPageChange: _handleItemsPerPageChange,
                    itemsPerPage: _itemsPerPage,
                    itemsPerPageOptions: [10, 25, 50, 100],
                    totalItems: controller.filteredDepartments.length,
                  ),
          ],
        );
      }),
    );
  }  void _showDepartmentDialog(BuildContext context) {
    showCustomDialog(
      context: context,
      dialogContent: [DepartmentDialog(controller: controller)],
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    controller.setdepartmentName(controller.filteredDepartments[index]);
    controller.setMasterdepartment(controller.filteredMasterDepartments[index]);
    _showDepartmentDialog(context);
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this department?'),
          actions: [
            TextButton(
              onPressed: () {
                controller.deletedepartment(index);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
