import 'package:json_annotation/json_annotation.dart';

part 'hotel_address.g.dart';

@JsonSerializable()
class HotelInfo {
  final String uuid, name, poster;
  final double price, rating;
  final Address address;
  final Services services;
  final List<String> photos;

  HotelInfo({required this.uuid, required this.name, required this.poster, required this.price, required this.rating, required this.address, required this.services, required this.photos});

  factory HotelInfo.fromJson(Map<String, dynamic> json) => _$HotelInfoFromJson(json);
  Map<String, dynamic> toJson() => _$HotelInfoToJson(this);
}

@JsonSerializable()
class Address {
  final String country, street, city;
  @JsonKey(name: 'zip_code')
  final int zipcode;
  final Coords coords;

  Address({required this.country, required this.street, required this.city, required this.zipcode, required this.coords});

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class Coords {
  final double lat, lan;

  Coords({required this.lat, required this.lan});

  factory Coords.fromJson(Map<String, dynamic> json) => _$CoordsFromJson(json);
  Map<String, dynamic> toJson() => _$CoordsToJson(this);
}

@JsonSerializable()
class Services {
  final List<String> free, paid;

  Services({required this.free, required this.paid});

  factory Services.fromJson(Map<String, dynamic> json) => _$ServicesFromJson(json);
  Map<String, dynamic> toJson() => _$ServicesToJson(this);
}