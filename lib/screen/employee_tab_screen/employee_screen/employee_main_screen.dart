// employee_main_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/employee_tab_controller/emplyoee_controller.dart';
import 'package:time_attendance/screen/employee_tab_screen/employee_screen/employee_form_screen.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';

class MainEmployeeScreen extends GetView<EmployeeController> {
  MainEmployeeScreen({super.key});

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employees Search',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (MediaQuery.of(context).size.width > 600)
            const SizedBox(width: 20),
         CustomActionButton(
            label: 'Add Employee',
        
          
            onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmployeeForm(),
              ),
            );
          },
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage:
                'Employee management is a crucial aspect of any organization. It involves the recruitment, training, and management of employees to ensure their effective performance and contribution to the organization.',
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              _buildFilterSection(context),
              Expanded(
                child: Obx(
                  () => ReusableTableAndCard(
                    data: controller.filteredEmployees
                        .map((e) => e.toMap())
                        .toList(),
                    headers: controller.headers,
                    onEdit: controller.onEdit,
                    onDelete: (id) async {
                      final result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text('Are you sure you want to delete this employee?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                      if (result == true) {
                        controller.deleteEmployee(id);
                      }
                    },
                    onSort: controller.onSort,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
 
Widget _buildFilterSection(BuildContext context) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      // Determine the device type based on width
      final isDesktop = constraints.maxWidth > 1024;
      final isTablet = constraints.maxWidth > 600 && constraints.maxWidth <= 1024;
      final isMobile = constraints.maxWidth <= 600;

      // For mobile, set the container height to 40% of the screen height
      final containerHeight = isMobile ? MediaQuery.of(context).size.height * 0.4 : null;

      return Container(
        height: containerHeight,
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop) ...[
                _buildDesktopLayout(),
              ] else if (isTablet) ...[
                _buildTabletLayout(),
              ] else ...[
                _buildMobileLayout(),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!isMobile) ...[
                    SizedBox(
                      width: 300,
                      child: _buildDropdown(
                        'Type',
                        controller.types,
                        controller.selectedType,
                      ),
                    ),
                    const Spacer(),
                  ],
                  OutlinedButton.icon(
                    onPressed: controller.clearForm,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      side: BorderSide(color: Theme.of(context).primaryColor),                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: controller.searchEmployees,
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildDesktopLayout() {
  return Column(
    children: [
      Row(
        children: [
          Expanded(child: _buildTextField(controller: controller.employeeIdController, label: 'Employee ID')),
          const SizedBox(width: 12),
          Expanded(child: _buildTextField(controller: controller.employeeNameController, label: 'Employee Name')),
          const SizedBox(width: 12),
          Expanded(child: _buildTextField(controller: controller.enrollIdController, label: 'Enroll ID')),
          const SizedBox(width: 12),
          Expanded(child: _buildDropdown('Company', controller.companies, controller.selectedCompany)),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(child: _buildDropdown('Department', controller.departments, controller.selectedDepartment)),
          const SizedBox(width: 12),
          Expanded(child: _buildDropdown('Designation', controller.designations, controller.selectedDesignation)),
          const SizedBox(width: 12),
          Expanded(child: _buildDropdown('Location', controller.locations, controller.selectedLocation)),
          const SizedBox(width: 12),
          Expanded(child: _buildDropdown('Status', controller.statusOptions, controller.selectedStatus)),
        ],
      ),
    ],
  );
}

Widget _buildTabletLayout() {
  return Column(
    children: [
      Row(
        children: [
          Expanded(child: _buildTextField(controller: controller.employeeIdController, label: 'Employee ID')),
          const SizedBox(width: 12),
          Expanded(child: _buildTextField(controller: controller.employeeNameController, label: 'Employee Name')),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(child: _buildTextField(controller: controller.enrollIdController, label: 'Enroll ID')),
          const SizedBox(width: 12),
          Expanded(child: _buildDropdown('Company', controller.companies, controller.selectedCompany)),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(child: _buildDropdown('Department', controller.departments, controller.selectedDepartment)),
          const SizedBox(width: 12),
          Expanded(child: _buildDropdown('Designation', controller.designations, controller.selectedDesignation)),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(child: _buildDropdown('Location', controller.locations, controller.selectedLocation)),
          const SizedBox(width: 12),
          Expanded(child: _buildDropdown('Status', controller.statusOptions, controller.selectedStatus)),
        ],
      ),
      // const SizedBox(height: 12),
      // _buildDropdown('Type', controller.types, controller.selectedType),
    ],
  );
}

Widget _buildMobileLayout() {
  return Column(
    children: [
      _buildTextField(controller: controller.employeeIdController, label: 'Employee ID'),
      const SizedBox(height: 12),
      _buildTextField(controller: controller.employeeNameController, label: 'Employee Name'),
      const SizedBox(height: 12),
      _buildTextField(controller: controller.enrollIdController, label: 'Enroll ID'),
      const SizedBox(height: 12),
      _buildDropdown('Company', controller.companies, controller.selectedCompany),
      const SizedBox(height: 12),
      _buildDropdown('Department', controller.departments, controller.selectedDepartment),
      const SizedBox(height: 12),
      _buildDropdown('Designation', controller.designations, controller.selectedDesignation),
      const SizedBox(height: 12),
      _buildDropdown('Location', controller.locations, controller.selectedLocation),
      const SizedBox(height: 12),
      _buildDropdown('Status', controller.statusOptions, controller.selectedStatus),
      
    ],
  );
}
  Widget _buildDropdown(
    String label,
    List<String> items,
    Rx<String?> selectedValue,
  ) {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: selectedValue.value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          selectedValue.value = newValue;
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }
}