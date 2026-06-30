import 'recycling_result.dart';

/// Punto de acopio donde se pueden llevar residuos.
class CollectionPoint {
  final String id;
  final String name;
  final String district;
  final String address;
  final String openingHours;
  final List<WasteCategory> acceptedMaterials;
  final double latitude;
  final double longitude;

  const CollectionPoint({
    required this.id,
    required this.name,
    required this.district,
    required this.address,
    required this.openingHours,
    required this.acceptedMaterials,
    required this.latitude,
    required this.longitude,
  });

  bool accepts(WasteCategory category) => acceptedMaterials.contains(category);

  CollectionPoint copyWith({
    String? id,
    String? name,
    String? district,
    String? address,
    String? openingHours,
    List<WasteCategory>? acceptedMaterials,
    double? latitude,
    double? longitude,
  }) {
    return CollectionPoint(
      id: id ?? this.id,
      name: name ?? this.name,
      district: district ?? this.district,
      address: address ?? this.address,
      openingHours: openingHours ?? this.openingHours,
      acceptedMaterials: acceptedMaterials ?? this.acceptedMaterials,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory CollectionPoint.fromJson(Map<String, dynamic> json) {
    return CollectionPoint(
      id: json['id'] as String,
      name: json['name'] as String,
      district: json['district'] as String,
      address: json['address'] as String,
      openingHours: json['openingHours'] as String,
      acceptedMaterials: (json['acceptedMaterials'] as List<dynamic>)
          .map((e) => WasteCategoryX.fromKey(e as String))
          .toList(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'district': district,
      'address': address,
      'openingHours': openingHours,
      'acceptedMaterials': acceptedMaterials.map((e) => e.key).toList(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
