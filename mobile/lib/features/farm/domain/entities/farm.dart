class Farm {
  final String id;
  final String name;
  final String crop;
  final String area;
  final String health;
  final String lastScan;
  final double lat;
  final double lng;
  final DateTime? plantedAt;

  const Farm({
    required this.id,
    required this.name,
    required this.crop,
    required this.area,
    required this.health,
    required this.lastScan,
    this.lat = 0,
    this.lng = 0,
    this.plantedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'crop': crop,
        'area': area,
        'health': health,
        'lastScan': lastScan,
        'lat': lat,
        'lng': lng,
        if (plantedAt != null) 'plantedAt': plantedAt!.toIso8601String(),
      };

  factory Farm.fromJson(Map<String, dynamic> json) => Farm(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        crop: json['crop'] ?? '',
        area: json['area'] ?? '',
        health: json['health'] ?? 'healthy',
        lastScan: json['lastScan'] ?? '',
        lat: (json['lat'] ?? 0).toDouble(),
        lng: (json['lng'] ?? 0).toDouble(),
        plantedAt: json['plantedAt'] != null && json['plantedAt'].toString().isNotEmpty
            ? DateTime.tryParse(json['plantedAt'].toString())
            : null,
      );
}
