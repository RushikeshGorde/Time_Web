import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/master_tab_controller/company_controller.dart';
import 'package:time_attendance/screen/master_tab_screens/company_screens/company_dialog_screen.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';

class MainCompanyScreen extends StatelessWidget {
  MainCompanyScreen({super.key});

  final BranchController controller = Get.find<BranchController>();
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
          title: const Text('Search Branches'),
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
        title: const Text('Branches'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (MediaQuery.of(context).size.width > 600)
            ReusableSearchField(
              searchController: _searchController,
              onSearchChanged: controller.updateSearchQuery,
            ),
         
          const SizedBox(width: 20),
          CustomActionButton(
            label: 'Add Branch',
            onPressed: () => _showSmallBranchDialog(context),
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage:
                'Manage Branches for your organization in this section.',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (MediaQuery.of(context).size.width <= 600)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReusableSearchField(
                searchController: _searchController,
                onSearchChanged: controller.updateSearchQuery,
                responsiveWidth: false,
              ),
            ),
          Expanded(
            child: Obx(() {
              return Column(
                children: [
                  Expanded(
                    child: ReusableTableAndCard(
                      data: List.generate(controller.filteredBranches.length, (index) {
                        final branch = controller.filteredBranches[index];
                        return {
                          'Branch Name': branch.branchName ?? 'N/A',
                          'Address': branch.address ?? 'N/A',
                          'Contact': branch.contact ?? 'N/A',
                          'Website': branch.website ?? 'N/A',
                          'Master Branch': branch.masterBranch ?? 'N/A',
                          'Actions': 'Edit/Delete',
                        };
                      }),
                      headers: ['Branch Name', 'Address', 'Contact', 'Website', 'Master Branch', 'Actions'],
                      visibleColumns: ['Branch Name', 'Address', 'Contact', 'Website', 'Master Branch', 'Actions'],
                      onEdit: (row) {
                        final index = controller.filteredBranches.indexWhere(
                          (branch) => branch.branchName == row['Branch Name']
                        );
                        if (index != -1) _showEditDialog(context, index);
                      },
                      onDelete: (row) {
                        final index = controller.filteredBranches.indexWhere(
                          (branch) => branch.branchName == row['Branch Name']
                        );
                        if (index != -1) _showDeleteConfirmationDialog(context, index);
                      },
                      onSort: (columnName, ascending) {
                        controller.sortBranches(columnName, ascending);
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
                    totalItems: controller.filteredBranches.length,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showSmallBranchDialog(BuildContext context) {
    showCustomDialog(
      context: context,
      dialogContent: [BranchDialog(controller: controller)],
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    controller.editBranch(index);
    showCustomDialog(
      context: context,
      dialogContent: [BranchDialog(controller: controller)],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this branch?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                controller.deleteBranch(index);
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