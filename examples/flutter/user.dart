/// User model representing a user in the system.
class User {
  final String phoneNumber;
  final String name;
  int? code;
  Vehicle? vehicle;

  /// Creates a new User instance.
  User({
    required this.phoneNumber,
    required this.name,
    this.code,
    this.vehicle,
  });

  /// Creates a User instance from JSON data.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      phoneNumber: json['phone_number'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code: (json['code'] is String)
          ? int.tryParse(json['code'])
          : json['code'] as int?,
      vehicle: Vehicle.fromJson(json),
    );
  }

  /// Converts the User instance to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'name': name,
      'code': code,
      ...vehicle?.toJson() ??
          {'model': '', 'tag': '', 'year': '', 'brand': '', 'color': ''},
    };
  }

  /// Checks if the user has a valid vehicle.
  bool hasVehicle() => vehicle != null && !vehicle!.isEmpty();

  /// Checks if the user has a valid code.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.phoneNumber == phoneNumber &&
        other.name == name &&
        other.code == code &&
        other.vehicle == vehicle;
  }

  /// Generates a hash code for the User instance.
  @override
  int get hashCode {
    return phoneNumber.hashCode ^
        name.hashCode ^
        code.hashCode ^
        vehicle.hashCode;
  }

  /// Returns a string representation of the User instance.
  @override
  String toString() {
    return 'User(phoneNumber: $phoneNumber, name: $name, code: $code, vehicle: ${vehicle.toString()})';
  }
}

/// Vehicle model representing a user's vehicle.
class Vehicle {
  final String model;
  final String tag;

  /// Creates a new Vehicle instance.
  const Vehicle({required this.model, required this.tag});

  /// Creates a Vehicle instance from JSON data.
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      model: json['model'] as String? ?? '',
      tag: json['tag'] as String? ?? '',
    );
  }

  /// Converts the Vehicle instance to JSON format.
  Map<String, dynamic> toJson() {
    return {'model': model, 'tag': tag};
  }

  /// Checks if the vehicle model and tag are empty.
  bool isEmpty() => model.isEmpty || tag.isEmpty;

  /// Checks if the vehicle is equal to another Vehicle instance.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Vehicle && other.model == model && other.tag == tag;
  }

  /// Generates a hash code for the Vehicle instance.
  @override
  int get hashCode {
    return model.hashCode ^ tag.hashCode;
  }

  /// Returns a string representation of the Vehicle instance.
  @override
  String toString() {
    return 'Vehicle(model: $model, tag: $tag)';
  }
}
