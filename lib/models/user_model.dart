class UserModel {
  String id;
  String name;
  String avatarUrl;
  String email;
  String phone;
  String gender;
  int age;
  String country;

  UserModel({
    this.id,
    this.name,
    this.avatarUrl,
    this.age,
    this.email,
    this.phone,
    this.country,
    this.gender,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          avatarUrl == other.avatarUrl &&
          age == other.age &&
          email == other.email &&
          phone == other.phone &&
          country == other.country &&
          gender == other.gender);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      avatarUrl.hashCode ^
      age.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      country.hashCode ^
      gender.hashCode;

  @override
  String toString() {
    return 'User{' +
        ' id: $id,' +
        ' name: $name,' +
        ' avatarUrl: $avatarUrl,' +
        ' age: $age,' +
        ' email: $email,' +
        ' phone: $phone,' +
        ' country: $country,' +
        ' gender: $gender,' +
        '}';
  }

  UserModel copyWith({
    String id,
    String displayName,
    String avatarUrl,
    String location,
    String age,
    String email,
    String phone,
    String country,
  }) {
    return new UserModel(
      id: id ?? this.id,
      name: displayName ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      age: age ?? this.age,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'avatarUrl': this.avatarUrl,
      'age': this.age,
      'email': this.email,
      'phone': this.phone,
      'country': this.country,
      'gender': this.gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      avatarUrl: map['avatarUrl'] as String,
      age: map['age'] as int,
      email: map['email'] as String,
      phone: map['phone'] as String,
      country: map['country'] as String,
      gender: map['gender'] as String,
    );
  }
}
