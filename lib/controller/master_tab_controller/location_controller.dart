import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/model/master_tab_model/location_model.dart';

class LocationController extends GetxController {
  // Controllers for form fields
  final locationNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final distanceController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  // Observable state variables
  final isIncludedInGeoFence = false.obs;
  final isGeoFenceFormVisible = false.obs;
  final currentPage = 0.obs;
  final searchQuery = ''.obs;
  final sortColumn = Rx<String?>(null);
  final isAscending = true.obs;
  final autoDetectLocation = false.obs;

  // Currently selected location for editing
  final Rx<Location?> selectedLocation = Rx<Location?>(null);

  // Dummy list with sample locations (your existing list)
  var locationList = <Location>[
   Location(
    locationName: 'Pune Station',
    address: 'Railway Station',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 5,
    latitude: 18.5289,
    longitude: 73.8745,
    isIncludedInGeoFence: true,
  ),
  Location(
    locationName: 'Shivajinagar',
    address: 'Shivajinagar',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 3,
    latitude: 18.5301,
    longitude: 73.8478,
    isIncludedInGeoFence: true,
  ),
  Location(
    locationName: 'Kothrud',
    address: 'Paud Rd',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 7,
    latitude: 18.5074,
    longitude: 73.8077,
    isIncludedInGeoFence: false,
  ),
  Location(
    locationName: 'Baner',
    address: 'Baner Rd',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 10,
    latitude: 18.5590,
    longitude: 73.7898,
    isIncludedInGeoFence: false,
  ),
  Location(
    locationName: 'Aundh',
    address: 'ITI Rd',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 8,
    latitude: 18.5583,
    longitude: 73.8062,
    isIncludedInGeoFence: true,
  ),
  Location(
    locationName: 'Hadapsar',
    address: 'Magarpatta Rd',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 12,
    latitude: 18.5093,
    longitude: 73.9259,
    isIncludedInGeoFence: true,
  ),
  Location(
    locationName: 'Viman Nagar',
    address: 'Nagar Rd',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 15,
    latitude: 18.5679,
    longitude: 73.9143,
    isIncludedInGeoFence: true,
  ),
  Location(
    locationName: 'Hinjewadi',
    address: 'Phase 1 Rd',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 18,
    latitude: 18.5961,
    longitude: 73.7434,
    isIncludedInGeoFence: false,
  ),
  Location(
    locationName: 'Katraj',
    address: 'Katraj Chowk',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 6,
    latitude: 18.4571,
    longitude: 73.8673,
    isIncludedInGeoFence: true,
  ),
  Location(
    locationName: 'Wakad',
    address: 'Wakad Rd',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 14,
    latitude: 18.5956,
    longitude: 73.7574,
    isIncludedInGeoFence: false,
  ),
  Location(
    locationName: 'Swargate',
    address: 'Satara Rd',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 4,
    latitude: 18.5018,
    longitude: 73.8586,
    isIncludedInGeoFence: true,
  ),
  Location(
    locationName: 'Bavdhan',
    address: 'Chandni Chowk Rd',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 9,
    latitude: 18.5099,
    longitude: 73.7894,
    isIncludedInGeoFence: false,
  ),
  Location(
    locationName: 'Lohegaon',
    address: 'Airport Rd',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 17,
    latitude: 18.5794,
    longitude: 73.9074,
    isIncludedInGeoFence: true,
  ),
  Location(
    locationName: 'Yerwada',
    address: 'Yerwada Gaon',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 13,
    latitude: 18.5677,
    longitude: 73.8842,
    isIncludedInGeoFence: true,
  ),
  Location(
    locationName: 'Chinchwad',
    address: 'Old Mumbai-Pune Rd',
    city: 'Pimpri-Chinchwad',
    state: 'Maharashtra',
    country: 'India',
    distance: 22,
    latitude: 18.6298,
    longitude: 73.7997,
    isIncludedInGeoFence: false,
  ),
  Location(
    locationName: 'Pimple Saudagar',
    address: 'Sai Chowk',
    city: 'Pimpri-Chinchwad',
    state: 'Maharashtra',
    country: 'India',
    distance: 16,
    latitude: 18.5945,
    longitude: 73.8032,
    isIncludedInGeoFence: true,
  ),
  Location(
    locationName: 'Warje',
    address: 'Warje Bridge',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 8,
    latitude: 18.4756,
    longitude: 73.8187,
    isIncludedInGeoFence: false,
  ),
  Location(
    locationName: 'Kharadi',
    address: 'EON IT Park Rd',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 14,
    latitude: 18.5523,
    longitude: 73.9345,
    isIncludedInGeoFence: true,
  ),
  Location(
    locationName: 'Wagholi',
    address: 'Nagar Rd',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 20,
    latitude: 18.5764,
    longitude: 73.9840,
    isIncludedInGeoFence: false,
  ),
  Location(
    locationName: 'Magarpatta',
    address: 'Magarpatta City',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 12,
    latitude: 18.5085,
    longitude: 73.9260,
    isIncludedInGeoFence: true,
  ),
  Location(
    locationName: 'Koregaon Park',
    address: 'North Main Rd',
    city: 'Pune',
    state: 'Maharashtra',
    country: 'India',
    distance: 11,
    latitude: 18.5362,
    longitude: 73.8991,
    isIncludedInGeoFence: true,
  ),
  // Add more similar entries up to 30...


    Location(
      locationName: 'Pune Station',
      address: 'Railway Station Rd',
      city: 'Pune',
      state: 'Maharashtra',
      country: 'India',
      distance: 5,
      latitude: 18.5289,
      longitude: 73.8745,
      isIncludedInGeoFence: true,
    ),
    // ... (rest of your existing locations)
  ].obs;

  // Method to toggle auto-detect location
  void toggleAutoDetect(bool value) {
    autoDetectLocation.value = value;
    if (value) {
      // Implement your location detection logic here
      // For example, using geolocator package to get current location
      // Update latitudeController and longitudeController with detected values
    }
  }

  // Method to prepare form for editing a location
  void editLocation(Location location) {
    // Populate controllers with the selected location's data
    selectedLocation.value = location;
    locationNameController.text = location.locationName;
    addressController.text = location.address;
    cityController.text = location.city;
    stateController.text = location.state;
    countryController.text = location.country;
    
    // Geofence-related fields
    isIncludedInGeoFence.value = location.isIncludedInGeoFence;
    isGeoFenceFormVisible.value = location.isIncludedInGeoFence;
    
    if (location.isIncludedInGeoFence) {
      distanceController.text = location.distance?.toString() ?? '';
      latitudeController.text = location.latitude?.toString() ?? '';
      longitudeController.text = location.longitude?.toString() ?? '';
    }
  }

  // Method to update the existing location
  void updateLocation() {
    if (validateForm() && selectedLocation.value != null) {
      // Find the index of the selected location
      final index = locationList.indexWhere(
        (loc) => loc == selectedLocation.value
      );

      if (index != -1) {
        // Update the location
        locationList[index] = Location(
          locationName: locationNameController.text,
          address: addressController.text,
          city: cityController.text,
          state: stateController.text,
          country: countryController.text,
          isIncludedInGeoFence: isIncludedInGeoFence.value,
          distance: isIncludedInGeoFence.value ? int.tryParse(distanceController.text) : null,
          latitude: isIncludedInGeoFence.value ? double.tryParse(latitudeController.text) : null,
          longitude: isIncludedInGeoFence.value ? double.tryParse(longitudeController.text) : null,
        );

        Get.snackbar(
          'Success',
          'Location updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        clearForm();
        selectedLocation.value = null;
        Get.back(); // Close the dialog
      }
    }
  }

  // Enhanced filtered and sorted list getter
  List<Location> get filteredAndSortedList {
    List<Location> filteredList = List.from(locationList);

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filteredList = filteredList.where((location) {
        return location.locationName.toLowerCase().contains(query) ||
            location.address.toLowerCase().contains(query) ||
            location.city.toLowerCase().contains(query) ||
            location.state.toLowerCase().contains(query);
      }).toList();
    }

    // Apply sorting
    if (sortColumn.value != null) {
      filteredList.sort((a, b) {
        int compare(dynamic va, dynamic vb) {
          if (va == null && vb == null) return 0;
          if (va == null) return -1;
          if (vb == null) return 1;

          if (va is String && vb is String) {
            return va.toLowerCase().compareTo(vb.toLowerCase());
          }
          if (va is num && vb is num) {
            return va.compareTo(vb);
          }
          if (va is bool && vb is bool) {
            return va == vb ? 0 : (va ? 1 : -1);
          }
          return 0;
        }

        dynamic va, vb;
        switch (sortColumn.value) {
          case 'locationName':
            va = a.locationName;
            vb = b.locationName;
            break;
          case 'address':
            va = a.address;
            vb = b.address;
            break;
          case 'city':
            va = a.city;
            vb = b.city;
            break;
          case 'state':
            va = a.state;
            vb = b.state;
            break;
          case 'distance':
            va = a.distance;
            vb = b.distance;
            break;
          case 'isIncludedInGeoFence':
            va = a.isIncludedInGeoFence;
            vb = b.isIncludedInGeoFence;
            break;
          case 'latitude':
            va = a.latitude;
            vb = b.latitude;
            break;
          case 'longitude':
            va = a.longitude;
            vb = b.longitude;
            break;
        }

        final comparisonResult = compare(va, vb);
        return isAscending.value ? comparisonResult : -comparisonResult;
      });
    }

    return filteredList;
  }

  // Override saveLocation to handle both add and edit scenarios
  void saveLocation() {
    if (selectedLocation.value != null) {
      updateLocation();
    } else {
      // Existing save logic for new locations
      if (validateForm()) {
        final location = Location(
          locationName: locationNameController.text,
          address: addressController.text,
          city: cityController.text,
          state: stateController.text,
          country: countryController.text,
          isIncludedInGeoFence: isIncludedInGeoFence.value,
          distance: isIncludedInGeoFence.value ? int.tryParse(distanceController.text) : null,
          latitude: isIncludedInGeoFence.value ? double.tryParse(latitudeController.text) : null,
          longitude: isIncludedInGeoFence.value ? double.tryParse(longitudeController.text) : null,
        );

        locationList.add(location);
        resetPage();
        Get.snackbar(
          'Success',
          'Location saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        clearForm();
      }
    }
  }

  // Toggle geofence form visibility
  void toggleGeoFenceForm(bool? value) {
    isIncludedInGeoFence.value = value ?? false;
    isGeoFenceFormVisible.value = isIncludedInGeoFence.value;
  }

  // Form validation
  bool validateForm() {
    if (locationNameController.text.isEmpty) {
      _showError('Location Name is required');
      return false;
    }
    if (addressController.text.isEmpty) {
      _showError('Address is required');
      return false;
    }
    if (isIncludedInGeoFence.value) {
      if (distanceController.text.isEmpty) {
        _showError('Distance is required for Geo Fence');
        return false;
      }
      if (latitudeController.text.isEmpty || longitudeController.text.isEmpty) {
        _showError('Latitude and Longitude are required for Geo Fence');
        return false;
      }
    }
    return true;
  }

  // Show error snackbar
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  // Cancel form
  void cancelForm() {
    clearForm();
    selectedLocation.value = null;
    Get.back();
  }

  // Clear form fields
  void clearForm() {
    locationNameController.clear();
    addressController.clear();
    cityController.clear();
    stateController.clear();
    countryController.clear();
    distanceController.clear();
    latitudeController.clear();
    longitudeController.clear();
    isIncludedInGeoFence.value = false;
    isGeoFenceFormVisible.value = false;
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    resetPage();
  }

  // Reset page
  void resetPage() {
    currentPage.value = 0;
  }

  // Dispose controllers
  @override
  void onClose() {
    locationNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    distanceController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.onClose();
  }
}