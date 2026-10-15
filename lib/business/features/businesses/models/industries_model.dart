class IndustriesModel {
  final int id;
  final String industry;
  final String? description;

  IndustriesModel({
    required this.id,
    required this.industry,
    this.description,
  });

  factory IndustriesModel.fromJson(Map<String, dynamic> json) {
    return IndustriesModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      industry: (json['industry'] ?? json['name']) as String? ?? '',
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'industry': industry,
      'description': description,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IndustriesModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  /// Default catalog matching backend IndustriesSeeder
  static List<IndustriesModel> get defaultIndustries => [
        IndustriesModel(
          id: 1,
          industry: 'Manufactura',
          description: 'Transformación de materias primas en productos terminados o semielaborados.',
        ),
        IndustriesModel(
          id: 2,
          industry: 'Tecnología',
          description: 'Desarrollo de software, hardware, telecomunicaciones y servicios tecnológicos.',
        ),
        IndustriesModel(
          id: 3,
          industry: 'Construcción',
          description: 'Diseño, construcción y mantenimiento de infraestructuras y edificaciones.',
        ),
        IndustriesModel(
          id: 4,
          industry: 'Comercio',
          description: 'Compra y venta de bienes y servicios al por mayor o al por menor.',
        ),
        IndustriesModel(
          id: 5,
          industry: 'Finanzas',
          description: 'Bancos, aseguradoras, fondos de inversión y servicios financieros.',
        ),
        IndustriesModel(
          id: 6,
          industry: 'Energía',
          description: 'Petróleo, gas, electricidad y energías renovables.',
        ),
        IndustriesModel(
          id: 7,
          industry: 'Salud',
          description: 'Servicios médicos, farmacéuticos, hospitales y bienestar.',
        ),
        IndustriesModel(
          id: 8,
          industry: 'Agricultura',
          description: 'Cultivo de alimentos, productos agrícolas, ganadería y silvicultura.',
        ),
        IndustriesModel(
          id: 9,
          industry: 'Educación',
          description: 'Enseñanza y formación en instituciones educativas.',
        ),
        IndustriesModel(
          id: 10,
          industry: 'Transporte y Logística',
          description: 'Transporte de bienes y personas, cadenas de suministro y distribución.',
        ),
        IndustriesModel(
          id: 11,
          industry: 'Turismo',
          description: 'Servicios relacionados con viajes, alojamiento y recreación.',
        ),
        IndustriesModel(
          id: 12,
          industry: 'Medios y Entretenimiento',
          description: 'Creación y distribución de contenido mediático, eventos y producción.',
        ),
        IndustriesModel(
          id: 13,
          industry: 'Alimentos y Bebidas',
          description: 'Producción, procesamiento y distribución de alimentos y bebidas.',
        ),
      ];
}

