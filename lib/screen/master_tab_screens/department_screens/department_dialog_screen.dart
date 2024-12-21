// department_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/master_tab_controller/department_controller.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class DepartmentDialog extends StatelessWidget {
  final DepartmentsController controller;

  const DepartmentDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dialog Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              const Text(
                'Department',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black87),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),

        // Dialog Content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Department Name *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: controller.setdepartmentName,
              ),
              const SizedBox(height: 20),
              Obx(() => DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Master Department',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                items: controller.masterdepartments.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: controller.setMasterdepartment,
              )),
              const SizedBox(height: 40),
              CustomButtons(
                onSavePressed: () {
                  controller.savedepartment();
                  Navigator.of(context).pop();
                },
                onCancelPressed: () {
                  controller.canceldepartment();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}