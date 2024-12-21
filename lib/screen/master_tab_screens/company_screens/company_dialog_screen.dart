import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/master_tab_controller/company_controller.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class BranchDialog extends StatelessWidget {
  final BranchController controller;

  const BranchDialog({super.key, required this.controller});

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
                'Company',
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
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                label: 'Company Name *',
                onChanged: controller.setBranchName,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Address',
                onChanged: controller.setAddress,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Contact',
                onChanged: controller.setContact,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Website',
                onChanged: controller.setWebsite,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Master Branch',
                onChanged: controller.setMasterBranch,
              ),
               
              const SizedBox(height: 24),
              CustomButtons(
                onSavePressed: () {
                  controller.saveBranch();
                  Navigator.of(context).pop();
                },
                onCancelPressed: () {
                  controller.cancelBranch();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      onChanged: onChanged,
    );
  }
}