import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/master_tab_controller/location_controller.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class LocationDialog extends StatelessWidget {
  LocationDialog({Key? key}) : super(key: key);

  final LocationController controller = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to get constraints
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate screen dimensions
        double screenWidth = constraints.maxWidth;
        double screenHeight = constraints.maxHeight;

        // Use a Dialog with a custom shape and content
        return Container(
          child: Container(
            width: screenWidth * 0.5, // Responsive width
            height: screenHeight * 0.8, // Responsive height
            child: Column(
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
                      Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
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

                // Dialog Content - Expanded and Scrollable
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildMainForm(screenWidth),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Obx(
                                () => Checkbox(
                                  value: controller.isIncludedInGeoFence.value,
                                  onChanged: (value) {
                                    controller.toggleGeoFenceForm(value);
                                  },
                                  activeColor: Colors.blue,
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'Is Included in Geo Fence Employee Logs',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildGeoFenceSection(screenWidth),
                          const SizedBox(height: 24),
                          CustomButtons(
                            onSavePressed: () {
                              controller.saveLocation();
                              Navigator.of(context).pop();
                            },
                            onCancelPressed: () {
                              controller.cancelForm();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

  }
  Widget _buildMainForm(double screenWidth) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTextField(
                controller: controller.locationNameController,
                label: 'Location Name *',
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 2,
              child: _buildTextField(
                controller: controller.cityController,
                label: 'City',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                controller: controller.addressController,
                label: 'Address *',
                maxLines: 3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTextField(
                controller: controller.stateController,
                label: 'State',
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 2,
              child: _buildTextField(
                controller: controller.countryController,
                label: 'Country',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGeoFenceSection(double screenWidth) {
    return Obx(() => controller.isGeoFenceFormVisible.value
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
                child: Text(
                  '(Allowed Distance From Center of Location To Mark Employee Punch In/Out)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              // Auto detect toggle
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Obx(
                      () => Switch(
                        value: controller.autoDetectLocation.value,
                        onChanged: (value) {
                          controller.toggleAutoDetect(value);
                        },

                        activeColor: Get.theme.colorScheme.primary,
                      ),
                    ),
                    const Text(
                      'Auto detect',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(

                      controller: controller.longitudeController,
                      label: 'Longitude',
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildTextField(
                      controller: controller.latitudeController,
                      label: 'Latitude',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: controller.distanceController,
                label: 'Distance',
                suffix: Text(
                  '(in meters)',

                  style: TextStyle(color: Get.theme.colorScheme.primary, fontSize: 14),
                ),
              )
            ],
          )
        : const SizedBox.shrink());

  }  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        suffix: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}