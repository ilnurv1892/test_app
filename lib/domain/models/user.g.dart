// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as int,
      json['name'] as String,
      json['username'] as String,
      json['email'] as String,
      json['phone'] as String,
      json['website'] as String,
      Company.fromJson(json['company'] as Map<String, dynamic>),
      Address.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.userName,
      'email': instance.email,
      'phone': instance.phone,
      'website': instance.website,
      'company': instance.company,
      'address': instance.address,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      json['street'] as String,
      json['suite'] as String,
      json['city'] as String,
      json['zipcode'] as String,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'street': instance.street,
      'suite': instance.suite,
      'city': instance.city,
      'zipcode': instance.zipCode,
    };

Company _$CompanyFromJson(Map<String, dynamic> json) => Company(
      json['name'] as String,
      json['bs'] as String,
      json['catchPhrase'] as String,
    );

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'name': instance.companyName,
      'bs': instance.bs,
      'catchPhrase': instance.catchPhrase,
    };
