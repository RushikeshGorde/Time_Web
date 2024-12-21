// holiday_dialog_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_attendance/controller/master_tab_controller/holiday_controller.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class HolidayDialog extends GetView<HolidaysController> {
  const HolidayDialog({super.key, required HolidaysController controller});

  @override
  Widget build(BuildContext context) {
    final dateController = TextEditingController(
      text: controller.holiday.value.holidayDate != null
          ? DateFormat('yyyy-MM-dd').format(controller.holiday.value.holidayDate!)
          : '',
    );

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
                'Holiday',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black87),
                onPressed: () => Get.back(),
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
                  labelText: 'Holiday Name *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: controller.setHolidayName,
                initialValue: controller.holiday.value.holidayName,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Holiday Date *',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: controller.holiday.value.holidayDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                        controller.setHolidayDate(pickedDate);
                      }
                    },
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 20),
              Obx(() => DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Holiday Company',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                value: controller.holiday.value.holidayCompany,
                items: controller.masterCompanies.map((String company) {
                  return DropdownMenuItem<String>(
                    value: company,
                    child: Text(company),
                  );
                }).toList(),
                onChanged: controller.setHolidayCompany,
              )),
              const SizedBox(height: 40),
              CustomButtons(
                onSavePressed: () {
                  controller.saveHoliday();
                  Get.back();
                },
                onCancelPressed: () {
                  controller.cancelHoliday();
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}