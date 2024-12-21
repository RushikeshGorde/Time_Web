// designation_model.dart
class DesignationModel {
  String? designationName;
  String? masterDesignation;

  DesignationModel({this.designationName, this.masterDesignation});

  // Optional: Add method to create a copy of the model
  DesignationModel copyWith({
    String? designationName,
    String? masterDesignation,
  }) {
    return DesignationModel(
      designationName: designationName ?? this.designationName,
      masterDesignation: masterDesignation ?? this.masterDesignation,
    );
  }
}