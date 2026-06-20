// lib/features/publish_job/data/model/company_model.dart

class CompanyModel {
  final String id;
  final String name;
  final String type;
  final String address;
  final String? taxNumber;
  final String? city;
  final List<String>? images;

  CompanyModel({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    this.taxNumber,
    this.city,
    this.images,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'address': address,
    'taxNumber': taxNumber,
    'city': city ?? '',
    'images': images ?? [],
  };

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    type: json['type'] ?? '',
    address: json['address'] ?? '',
    taxNumber: json['taxNumber'],
    city: json['city'],
    images: json['images'] != null
        ? List<String>.from(json['images'])
        : [],
  );
}