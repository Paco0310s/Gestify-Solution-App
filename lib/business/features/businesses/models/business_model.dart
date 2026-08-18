class BusinessModel {
  final String id;
  final String name;
  final String description;
  final String rfc;

  BusinessModel({required this.id, required this.name, required this.description, required this.rfc});

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(id: json['id'], name: json['name'], description: json['description'], rfc: json['rfc']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description, 'rfc': rfc};
  }
}
