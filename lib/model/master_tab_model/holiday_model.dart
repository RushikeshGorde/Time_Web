// holiday_model.dart
class holidayModel {
  String? holidayName;
  DateTime? holidayDate;
  String? holidayCompany;

  holidayModel({this.holidayName, this.holidayDate, this.holidayCompany});

  // Optional: Add method to create a copy of the model
  holidayModel copyWith({
    String? holidayName,
    DateTime? holidayDate,
    String? holidayCompany,
  }) {
    return holidayModel(
      holidayName: holidayName ?? this.holidayName,
      holidayDate: holidayDate ?? this.holidayDate,
      holidayCompany: holidayCompany ?? this.holidayCompany,
    );
  }
}