class BranchModel {
  String? branchName;
  String? address;
  String? contact;
  String? website;
  String? masterBranch;

  BranchModel({
    this.branchName, 
    this.address, 
    this.contact, 
    this.website, 
    this.masterBranch
  });

  // Method to create a copy of the model
  BranchModel copyWith({
    String? branchName,
    String? address,
    String? contact,
    String? website,
    String? masterBranch,
  }) {
    return BranchModel(
      branchName: branchName ?? this.branchName,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      website: website ?? this.website,
      masterBranch: masterBranch ?? this.masterBranch,
    );
  }

  // Method to convert the model to a map (useful for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'branchName': branchName,
      'address': address,
      'contact': contact,
      'website': website,
      'masterBranch': masterBranch,
    };
  }

  // Method to create a model from a map (useful for JSON deserialization)
  factory BranchModel.fromMap(Map<String, dynamic> map) {
    return BranchModel(
      branchName: map['branchName'],
      address: map['address'],
      contact: map['contact'],
      website: map['website'],
      masterBranch: map['masterBranch'],
    );
  }

  // Optional: Add toString method for debugging
  @override
  String toString() {
    return 'BranchModel(branchName: $branchName, address: $address, contact: $contact, website: $website, masterBranch: $masterBranch)';
  }

  // Optional: Add equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BranchModel &&
      other.branchName == branchName &&
      other.address == address &&
      other.contact == contact &&
      other.website == website &&
      other.masterBranch == masterBranch;
  }

  // Optional: Add hashCode for proper object comparison
  @override
  int get hashCode {
    return branchName.hashCode ^
      address.hashCode ^
      contact.hashCode ^
      website.hashCode ^
      masterBranch.hashCode;
  }
}