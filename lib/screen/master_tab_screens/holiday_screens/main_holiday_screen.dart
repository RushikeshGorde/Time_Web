// main_holiday_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_attendance/controller/master_tab_controller/holiday_controller.dart';
import 'package:time_attendance/screen/master_tab_screens/holiday_screens/holiday_dailog_screen.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';

class MainHolidayScreen extends StatelessWidget {
  MainHolidayScreen({super.key});

  final HolidaysController controller = Get.find<HolidaysController>();
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(1);
  final ValueNotifier<int> _itemsPerPage = ValueNotifier<int>(10);

  void _handlePageChange(int page) {
    _currentPage.value = page;
  }

  void _handleItemsPerPageChange(int itemsPerPage) {
    _itemsPerPage.value = itemsPerPage;
    _currentPage.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holidays'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          // Show search field for larger screens or search button for smaller screens
          if (MediaQuery.of(context).size.width > 600)
            ReusableSearchField(
              searchController: _searchController,
              onSearchChanged: controller.updateSearchQuery,
            ),
         
          const SizedBox(width: 20),
          CustomActionButton(
            label: 'Add Holiday',
            onPressed: () => _showSmallHolidayDialog(context),
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage:
                'Manage Holidays for your organization in this section.',
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
                      data: List.generate(controller.filteredHolidays.length, (index) {
                        final holiday = controller.filteredHolidays[index];
                        return {
                          'Holiday Name': holiday.holidayName ?? '',
                          'Holiday Date': holiday.holidayDate != null 
                            ? DateFormat('yyyy-MM-dd').format(holiday.holidayDate!) 
                            : '',
                          'Holiday Year': holiday.holidayDate?.year.toString() ?? '',
                          'Company': holiday.holidayCompany ?? '',
                          'Actions': 'Edit/Delete',
                          'GeoFence': 'Yes', // Added for consistency with ReusableTableAndCard
                        };
                      }),
                      headers: ['Holiday Name', 'Holiday Date', 'Holiday Year', 'Company', 'Actions'],
                      visibleColumns: ['Holiday Name', 'Holiday Date', 'Holiday Year', 'Company', 'Actions'],
                      onEdit: (row) {
                        final index = controller.filteredHolidays.indexWhere(
                          (h) => h.holidayName == row['Holiday Name']
                        );
                        if (index != -1) _showEditDialog(context, index);
                      },
                      onDelete: (row) {
                        final index = controller.filteredHolidays.indexWhere(
                          (h) => h.holidayName == row['Holiday Name']
                        );
                        if (index != -1) _showDeleteConfirmationDialog(context, index);
                      },
                      onSort: (columnName, isAscending) {
                        // Map column names to match controller's sorting method
                        final sortColumnMap = {
                          'Holiday Name': 'Holiday Name',
                          'Holiday Date': 'Holiday Date',
                          'Holiday Year': 'Holiday Year',
                          'Company': 'Company',
                        };

                        final mappedColumnName = sortColumnMap[columnName] ?? columnName;
                        controller.sortHolidays(mappedColumnName, isAscending);
                      },
                    
                    ),
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: _currentPage,
                    builder: (context, currentPage, child) {
                      return ValueListenableBuilder<int>(
                        valueListenable: _itemsPerPage,
                        builder: (context, itemsPerPage, child) {
                          return PaginationWidget(
                            currentPage: currentPage,
                            totalPages: _calculateTotalPages(
                              controller.filteredHolidays.length, 
                              itemsPerPage
                            ),
                            onFirstPage: () => _handlePageChange(1),
                            onPreviousPage: () => _handlePageChange(currentPage - 1),
                            onNextPage: () => _handlePageChange(currentPage + 1),
                            onLastPage: () => _handlePageChange(
                              _calculateTotalPages(
                                controller.filteredHolidays.length, 
                                itemsPerPage
                              )
                            ),
                            onItemsPerPageChange: _handleItemsPerPageChange,
                            itemsPerPage: itemsPerPage,
                            itemsPerPageOptions: [10, 25, 50, 100],
                            totalItems: controller.filteredHolidays.length,
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // Calculate total pages based on total items and items per page
  int _calculateTotalPages(int totalItems, int itemsPerPage) {
    return (totalItems / itemsPerPage).ceil();
  }

  // Show the holiday dialog for adding a new holiday
  void _showSmallHolidayDialog(BuildContext context) {
    showCustomDialog(
      context: context,
      dialogContent: [HolidayDialog(controller: controller)],
    );
  }
  
  // Show the holiday dialog for editing an existing holiday
  void _showEditDialog(BuildContext context, int index) {
    // Set the current holiday for editing
    controller.holiday.value = controller.filteredHolidays[index].copyWith();
    
    showCustomDialog(
      context: context,
      dialogContent: [HolidayDialog(controller: controller)],
    );
  }

  // Show the delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this holiday?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                controller.deleteHoliday(index); // Proceed with deletion
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel deletion
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}