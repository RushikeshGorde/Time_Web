import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/master_tab_controller/location_controller.dart';
import 'package:time_attendance/model/master_tab_model/location_model.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';




class GeoFenceForm extends StatelessWidget {
  GeoFenceForm({Key? key, required Location locationData}) : super(key: key);

  final LocationController controller = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dialog Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.deepPurple[100],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              const Text(
                'Geo Fence Details',
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

        // Form Content
        Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildGeoFenceForm(),
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
      ],
    );
  }

  Widget _buildGeoFenceForm() {
    return Column(
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
                  activeColor: Colors.blue,
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
                controller: controller.latitudeController,
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
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        )
      ],
    );
  }

  Widget _buildTextField({
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