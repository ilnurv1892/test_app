import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  @JsonKey(name: 'username')
  final String userName;
  final String email;
  final String phone;
  final String website;
  final Company company;
  final Address address;

  User(this.id, this.name, this.userName, this.email, this.phone, this.website, this.company, this.address);

  factory User.fromJson(json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Address {
  final String street;
  final String suite;
  final String city;
  @JsonKey(name: 'zipcode')
  final String zipCode;

  Address(this.street, this.suite, this.city, this.zipCode);

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class Company {
  @JsonKey(name: 'name')
  final String companyName;
  final String bs;
  final String catchPhrase;

  Company(this.companyName, this.bs, this.catchPhrase);

  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
