class TypesRegimensTaxesModel {
  final int id;
  final String regimen;
  final String? description;

  TypesRegimensTaxesModel({
    required this.id,
    required this.regimen,
    this.description,
  });

  factory TypesRegimensTaxesModel.fromJson(Map<String, dynamic> json) {
    return TypesRegimensTaxesModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      regimen: (json['regimen'] ?? json['name']) as String? ?? '',
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'regimen': regimen,
      'description': description,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypesRegimensTaxesModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  /// Default catalog matching backend TypesRegimensTaxesSeeder
  static List<TypesRegimensTaxesModel> get defaultTaxRegimens => [
        TypesRegimensTaxesModel(
          id: 1,
          regimen: 'Régimen General de Ley de Personas Morales',
          description: 'Para personas morales con cálculo de impuestos conforme a la ley general del ISR.',
        ),
        TypesRegimensTaxesModel(
          id: 2,
          regimen: 'Régimen de Incorporación Fiscal (RIF)',
          description: 'Para pequeños contribuyentes con tributación simplificada y reducción progresiva.',
        ),
        TypesRegimensTaxesModel(
          id: 3,
          regimen: 'Régimen de Actividades Empresariales y Profesionales',
          description: 'Para personas físicas con actividades comerciales, industriales o servicios profesionales.',
        ),
        TypesRegimensTaxesModel(
          id: 4,
          regimen: 'Régimen de Arrendamiento',
          description: 'Para personas físicas que obtienen ingresos por alquiler de bienes inmuebles.',
        ),
        TypesRegimensTaxesModel(
          id: 5,
          regimen: 'Régimen de Sueldos y Salarios',
          description: 'Para personas físicas que reciben ingresos por trabajo personal subordinado.',
        ),
        TypesRegimensTaxesModel(
          id: 6,
          regimen: 'Régimen de Dividendos',
          description: 'Para accionistas que reciben utilidades o dividendos de empresas.',
        ),
        TypesRegimensTaxesModel(
          id: 7,
          regimen: 'Régimen de Actividades Agrícolas, Ganaderas, Silvícolas y Pesqueras',
          description: 'Sector primario: agricultura, ganadería, silvicultura o pesca.',
        ),
        TypesRegimensTaxesModel(
          id: 8,
          regimen: 'Régimen de Enajenación de Bienes',
          description: 'Ingresos por venta de bienes como inmuebles o vehículos.',
        ),
        TypesRegimensTaxesModel(
          id: 9,
          regimen: 'Régimen de Personas Morales con Fines no Lucrativos',
          description: 'Asociaciones civiles, fundaciones y organizaciones sin fines de lucro exentas de ISR.',
        ),
        TypesRegimensTaxesModel(
          id: 10,
          regimen: 'Régimen de Asalariados',
          description: 'Empleados con retención directa de impuestos por el empleador.',
        ),
      ];
}

