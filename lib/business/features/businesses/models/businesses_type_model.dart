class BusinessesTypeModel {
  final int id;
  final String code;
  final String type;
  final String? description;

  BusinessesTypeModel({
    required this.id,
    required this.code,
    required this.type,
    this.description,
  });

  factory BusinessesTypeModel.fromJson(Map<String, dynamic> json) {
    return BusinessesTypeModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      code: json['code'] as String? ?? '',
      type: json['type'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'type': type,
      'description': description,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessesTypeModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  /// Default catalog matching backend BusinessesTypeSeeder
  static List<BusinessesTypeModel> get defaultBusinessTypes => [
        BusinessesTypeModel(
          id: 1,
          code: 'PF',
          type: 'Persona Física',
          description: 'Es un individuo que realiza actividades comerciales, empresariales o profesionales.',
        ),
        BusinessesTypeModel(
          id: 2,
          code: 'PM',
          type: 'Persona Moral',
          description: 'Entidad jurídica formada por dos o más personas físicas o morales.',
        ),
        BusinessesTypeModel(
          id: 3,
          code: 'SA',
          type: 'Sociedad Anónima (S.A.)',
          description: 'Tipo de persona moral con responsabilidad limitada a sus aportaciones.',
        ),
        BusinessesTypeModel(
          id: 4,
          code: 'SACV',
          type: 'Sociedad Anónima de Capital Variable (S.A. de C.V.)',
          description: 'Variante de S.A. con capital social variable.',
        ),
        BusinessesTypeModel(
          id: 5,
          code: 'SAPI',
          type: 'Sociedad Anónima Promotora de Inversión (S.A.P.I.)',
          description: 'Flexibilidad en la emisión de acciones para atraer inversionistas.',
        ),
        BusinessesTypeModel(
          id: 6,
          code: 'SAS',
          type: 'Sociedad por Acciones Simplificada (S.A.S.)',
          description: 'Sociedad constituida por una o más personas físicas vía electrónica.',
        ),
        BusinessesTypeModel(
          id: 7,
          code: 'SC',
          type: 'Sociedad Civil (S.C.)',
          description: 'Persona moral sin fines de lucro para profesionales con fines comunes.',
        ),
        BusinessesTypeModel(
          id: 8,
          code: 'SRL',
          type: 'Sociedad de Responsabilidad Limitada (S. de R.L.)',
          description: 'Socios sólo responden hasta el monto de sus aportaciones.',
        ),
        BusinessesTypeModel(
          id: 9,
          code: 'AC',
          type: 'Asociación Civil (A.C.)',
          description: 'Entidad sin fines de lucro para asistencia social, cultural, educativa.',
        ),
        BusinessesTypeModel(
          id: 10,
          code: 'RIF',
          type: 'Régimen de Incorporación Fiscal (RIF)',
          description: 'Régimen para pequeños contribuyentes con tributación simplificada.',
        ),
        BusinessesTypeModel(
          id: 11,
          code: 'SCP',
          type: 'Sociedad Cooperativa de Producción (S.C. de P.)',
          description: 'Trabajadores asociados para producir bienes o servicios.',
        ),
        BusinessesTypeModel(
          id: 12,
          code: 'SCC',
          type: 'Sociedad Cooperativa de Consumo (S.C. de C.)',
          description: 'Consumidores asociados para adquirir bienes y servicios en común.',
        ),
      ];
}

