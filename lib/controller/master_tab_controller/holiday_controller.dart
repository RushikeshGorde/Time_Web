import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_attendance/model/master_tab_model/holiday_model.dart';

class HolidaysController extends GetxController {
  // Reactive observable for the current holiday
  final holiday = holidayModel().obs;

  // Observable lists for holiday companies
  final masterCompanies = <String>[
    'ABC Corporation',
    'XYZ Limited',
    'Global Enterprises',
    'Tech Solutions Inc.',
    'N / A'
  ].obs;

  // Reactive list of holidays
  final masterHolidays = <holidayModel>[].obs;

  // Reactive filtered list for search
  final filteredHolidays = <holidayModel>[].obs;

  // Search query text
  final searchQuery = ''.obs;

  // Sorting variables
  final sortColumn = Rx<String?>(null);
  final isAscending = true.obs;

  // Constructor to initialize the filtered list
  HolidaysController() {
    addIndianHolidays(); // Add Indian holidays during initialization
    updateFilteredHolidays(); // Initial setup of filtered holidays
  }

  // Setter methods for updating holiday properties
  void setHolidayName(String value) {
    holiday.update((val) {
      val?.holidayName = value;
    });
  }

  void setHolidayDate(DateTime value) {
    holiday.update((val) {
      val?.holidayDate = value;
    });
  }

  void setHolidayCompany(String? value) {
    holiday.update((val) {
      val?.holidayCompany = value;
    });
  }

  // Comprehensive sorting method
  void sortHolidays(String columnName, bool ascending) {
    sortColumn.value = columnName;
    isAscending.value = ascending;

    // Sort the holidays based on the selected column
    masterHolidays.sort((a, b) {
      dynamic valueA, valueB;
      switch (columnName) {
        case 'Holiday Name':
          valueA = a.holidayName ?? '';
          valueB = b.holidayName ?? '';
          break;
        case 'Holiday Date':
          valueA = a.holidayDate;
          valueB = b.holidayDate;
          break;
        case 'Holiday Year':
          valueA = a.holidayDate?.year;
          valueB = b.holidayDate?.year;
          break;
        case 'Company':
          valueA = a.holidayCompany ?? '';
          valueB = b.holidayCompany ?? '';
          break;
        default:
          return 0;
      }

      // Handle different sorting logics based on column type
      if (columnName == 'Holiday Date' || columnName == 'Holiday Year') {
        if (valueA == null && valueB == null) return 0;
        if (valueA == null) return ascending ? 1 : -1;
        if (valueB == null) return ascending ? -1 : 1;
        
        return ascending 
          ? (valueA as Comparable).compareTo(valueB)
          : (valueB as Comparable).compareTo(valueA);
      }

      // Perform case-insensitive sorting for string columns
      final comparison = valueA.toString().toLowerCase().compareTo(valueB.toString().toLowerCase());
      return ascending ? comparison : -comparison;
    });

    // Update filtered holidays after sorting
    updateFilteredHolidays();
  }

  // Save holiday method with validation
  void saveHoliday() {
    if (holiday.value.holidayName?.isEmpty ?? true) {
      Get.snackbar(
        'Error',
        'Holiday name is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (holiday.value.holidayDate == null) {
      Get.snackbar(
        'Error',
        'Holiday date is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Check if this is a new holiday or editing an existing one
    final existingIndex = masterHolidays.indexWhere(
      (h) => h.holidayName == holiday.value.holidayName && 
             h.holidayDate == holiday.value.holidayDate
    );
    
    if (existingIndex != -1) {
      // Update existing holiday
      masterHolidays[existingIndex] = holiday.value;
    } else {
      // Add new holiday
      masterHolidays.add(holiday.value);
    }

    // Update the filtered list
    updateFilteredHolidays();

    Get.snackbar(
      'Success',
      'Holiday saved successfully',
      snackPosition: SnackPosition.BOTTOM,
    );

    cancelHoliday(); // Reset holiday
  }

  // Cancel and reset holiday
  void cancelHoliday() {
    holiday.value = holidayModel();
    Get.back();
  }

  // Method to delete a holiday
  void deleteHoliday(int index) {
    if (index >= 0 && index < filteredHolidays.length) {
      // Find the actual index in masterHolidays
      final actualHoliday = filteredHolidays[index];
      final masterIndex = masterHolidays.indexWhere(
        (h) => h.holidayName == actualHoliday.holidayName && 
               h.holidayDate == actualHoliday.holidayDate
      );

      if (masterIndex != -1) {
        masterHolidays.removeAt(masterIndex);
      }

      // Update the filtered list
      updateFilteredHolidays();

      Get.snackbar(
        'Success',
        'Holiday deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Update filtered holidays based on search query and current sorting
  void updateFilteredHolidays() {
    if (searchQuery.value.isEmpty) {
      filteredHolidays.assignAll(masterHolidays);
    } else {
      filteredHolidays.assignAll(
        masterHolidays.where((holiday) => 
          (holiday.holidayName?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false) ||
          (holiday.holidayCompany?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false) ||
          (holiday.holidayDate != null && 
           DateFormat('yyyy-MM-dd').format(holiday.holidayDate!).contains(searchQuery.value))
        ),
      );
    }

    // Re-apply current sorting if a sort column is set
    if (sortColumn.value != null) {
      sortHolidays(sortColumn.value!, isAscending.value);
    }
  }

  // Method to update the search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    updateFilteredHolidays();
  }

  // Method to get company options
  List<String> getCompanyOptions() {
    return masterCompanies;
  }

  // Add Indian holidays to the masterHolidays list
  void addIndianHolidays() {
    final indianHolidays = [
      holidayModel(holidayName: 'Diwali', holidayDate: DateTime(2024, 11, 1), holidayCompany: 'ABC Corporation'),
      holidayModel(holidayName: 'Dussehra', holidayDate: DateTime(2024, 10, 20), holidayCompany: 'XYZ Limited'),
      holidayModel(holidayName: 'Holi', holidayDate: DateTime(2024, 3, 25), holidayCompany: 'Global Enterprises'),
      holidayModel(holidayName: 'Independence Day', holidayDate: DateTime(2024, 8, 15), holidayCompany: 'Tech Solutions Inc.'),
      holidayModel(holidayName: 'Republic Day', holidayDate: DateTime(2024, 1, 26), holidayCompany: 'N / A'),
      holidayModel(holidayName: 'Gandhi Jayanti', holidayDate: DateTime(2024, 10, 2), holidayCompany: 'ABC Corporation'),
      holidayModel(holidayName: 'Christmas', holidayDate: DateTime(2024, 12, 25), holidayCompany: 'XYZ Limited'),
      holidayModel(holidayName: 'Eid al-Fitr', holidayDate: DateTime(2024, 4, 10), holidayCompany: 'Global Enterprises'),
      holidayModel(holidayName: 'Eid al-Adha', holidayDate: DateTime(2024, 6, 17), holidayCompany: 'Tech Solutions Inc.'),
      holidayModel(holidayName: 'Janmashtami', holidayDate: DateTime(2024, 8, 26), holidayCompany: 'N / A'),
      holidayModel(holidayName: 'Raksha Bandhan', holidayDate: DateTime(2024, 8, 19), holidayCompany: 'ABC Corporation'),
      holidayModel(holidayName: 'Makar Sankranti', holidayDate: DateTime(2024, 1, 14), holidayCompany: 'XYZ Limited'),
      holidayModel(holidayName: 'Ganesh Chaturthi', holidayDate: DateTime(2024, 9, 9), holidayCompany: 'Global Enterprises'),
      holidayModel(holidayName: 'Onam', holidayDate: DateTime(2024, 8, 29), holidayCompany: 'Tech Solutions Inc.'),
      holidayModel(holidayName: 'Pongal', holidayDate: DateTime(2024, 1, 15), holidayCompany: 'N / A'),
      holidayModel(holidayName: 'Baisakhi', holidayDate: DateTime(2024, 4, 13), holidayCompany: 'ABC Corporation'),
      holidayModel(holidayName: 'Mahavir Jayanti', holidayDate: DateTime(2024, 4, 17), holidayCompany: 'XYZ Limited'),
      holidayModel(holidayName: 'Buddha Purnima', holidayDate: DateTime(2024, 5, 23), holidayCompany: 'Global Enterprises'),
      holidayModel(holidayName: 'Chhath Puja', holidayDate: DateTime(2024, 11, 8), holidayCompany: 'Tech Solutions Inc.'),
      holidayModel(holidayName: 'Guru Nanak Jayanti', holidayDate: DateTime(2024, 11, 15), holidayCompany: 'N / A'),
    ];

    masterHolidays.assignAll(indianHolidays);
  }
}