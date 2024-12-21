// department_model.dart
class departmentModel {
  String? departmentName;
  String? masterdepartment;

  departmentModel({this.departmentName, this.masterdepartment});

  // Optional: Add method to create a copy of the model
  departmentModel copyWith({
    String? departmentName,
    String? masterdepartment,
  }) {
    return departmentModel(
      departmentName: departmentName ?? this.departmentName,
      masterdepartment: masterdepartment ?? this.masterdepartment,
    );
  }
}