import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import the custom reusable widgets
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';

// Import the controller and dialog
import 'package:time_attendance/controller/master_tab_controller/location_controller.dart';
import 'package:time_attendance/screen/master_tab_screens/location_screens/location_dialog_screen.dart';
import 'package:time_attendance/model/master_tab_model/location_model.dart';

class MainLocationScreen extends StatefulWidget {
  const MainLocationScreen({Key? key}) : super(key: key);

  @override
  _MainLocationScreenState createState() => _MainLocationScreenState();
}

class _MainLocationScreenState extends State<MainLocationScreen> {
  // Initialize the location controller
  final LocationController controller = Get.put(LocationController());

  // Search controller for the search text field
  final TextEditingController _searchController = TextEditingController();

  // Pagination variables
  int _currentPage = 1;
  int _itemsPerPage = 10;
  int _totalPages = 1;

  // Method to show the location dialog (for both add and edit)
  void _showLocationDialog({Location? location}) {
    // If editing, set the selected location in the controller
    if (location != null) {
      controller.editLocation(location);
    }

    showCustomDialog(
      context: context,
      dialogContent: LocationDialog(),
    );
  }

  // Handle page change for pagination
  void _handlePageChange(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  // Handle items per page change
  void _handleItemsPerPageChange(int itemsPerPage) {
    setState(() {
      _itemsPerPage = itemsPerPage;
      _currentPage = 1; // Reset to first page when items per page changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Location List', 
          style: TextStyle(color: Colors.black87)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          // Responsive search field for larger screens
          if (MediaQuery.of(context).size.width > 600)
            ReusableSearchField(
              searchController: _searchController,
              onSearchChanged: controller.updateSearchQuery,
            ),

          const SizedBox(width: 20),

          // Add Location button
          CustomActionButton(
            label: 'Add Location',
            onPressed: () => _showLocationDialog(),
          ),

          const SizedBox(width: 8),

          // Help tooltip button
          HelpTooltipButton(
            tooltipMessage:
                'Add / View company locations. You can add multiple locations for a company.',
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        children: [
          // Mobile search field
          if (MediaQuery.of(context).size.width <= 600)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReusableSearchField(
                searchController: _searchController,
                onSearchChanged: controller.updateSearchQuery,
                responsiveWidth: false,
              ),
            ),

          // Expanded content with locations list
          Expanded(
            child: Obx(() {
              // Get filtered and sorted locations
              final locations = controller.filteredAndSortedList;

              // Calculate total pages
              _totalPages = (locations.length / _itemsPerPage).ceil();

              // Prepare paginated data
              final data = locations
                  .skip((_currentPage - 1) * _itemsPerPage)
                  .take(_itemsPerPage)
                  .map((location) {
                return {
                  "Location Name": location.locationName,
                  "Address": location.address,
                  "City": location.city,
                  "State": location.state,
                  "GeoFence": location.isIncludedInGeoFence ? "Yes" : "No",
                  "Actions": "",
                };
              }).toList();

              return Column(
                children: [
                  // Locations table
                  Expanded(
                    child: ReusableTableAndCard(
                      data: data,
                      headers: [
                        "Location Name",
                        "Address",
                        "City",
                        "State",
                        "GeoFence",
                        "Actions"
                      ],
                      onEdit: (row) {
                        // Find the corresponding location to edit
                        final locationToEdit = locations.firstWhere(
                          (location) => 
                            location.locationName == row["Location Name"] &&
                            location.address == row["Address"]
                        );
                        
                        // Show dialog for editing
                        _showLocationDialog(location: locationToEdit);
                      },
                      onDelete: (row) async {
                        // Show confirmation dialog for deletion
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text(
                                'Are you sure you want to delete this location?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        // Perform deletion if confirmed
                        if (confirmed == true) {
                          final locationToRemove = locations.firstWhere(
                            (location) =>
                                location.locationName == row["Location Name"] &&
                                location.address == row["Address"],
                          );
                          controller.locationList.remove(locationToRemove);
                        }
                      },
                      visibleColumns: [
                        "Location Name",
                        "Address",
                        "City",
                        "State",
                        "GeoFence",
                        "Actions"
                      ],
                      onSort: (columnName, isAscending) {
                        // Map the displayed column names to the model's property names
                        final sortMap = {
                          'Location Name': 'locationName',
                          'Address': 'address',
                          'City': 'city',
                          'State': 'state',
                          'GeoFence': 'isIncludedInGeoFence'
                        };

                        // Get the corresponding model property name
                        final modelColumn = sortMap[columnName];
                        
                        if (modelColumn != null) {
                          // Call the controller's toggle sort method
                          controller.sortColumn.value = modelColumn;
                          controller.isAscending.value = isAscending;
                        }
                      },
                    ),
                  ),

                  // Pagination widget
                  PaginationWidget(
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                    totalItems: locations.length,
                    onFirstPage: () => _handlePageChange(1),
                    onPreviousPage: () => _handlePageChange(_currentPage - 1),
                    onNextPage: () => _handlePageChange(_currentPage + 1),
                    onLastPage: () => _handlePageChange(_totalPages),
                    onItemsPerPageChange: _handleItemsPerPageChange,
                    itemsPerPage: _itemsPerPage,
                    itemsPerPageOptions: [10, 25, 50, 100],
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

// Custom dialog function remains the same as in the original implementation
void showCustomDialog({
  required BuildContext context,
  required Widget dialogContent,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 600,
                  minHeight: 0,
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: dialogContent,
              ),
            );
          },
        ),
      );
    },
  );
}