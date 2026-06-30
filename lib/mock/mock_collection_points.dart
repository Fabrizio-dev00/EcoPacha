import '../models/collection_point.dart';
import '../models/recycling_result.dart';

/// Puntos de acopio simulados (Lima). Se conectarán a datos reales en Firebase.
const List<CollectionPoint> mockCollectionPoints = [
  CollectionPoint(
    id: 'p1',
    name: 'Punto Verde Miraflores',
    district: 'Miraflores',
    address: 'Av. Larco 345',
    openingHours: 'Lun-Sáb 9:00 - 18:00',
    acceptedMaterials: [
      WasteCategory.plasticoPet,
      WasteCategory.papelCarton,
      WasteCategory.vidrio,
      WasteCategory.metal,
    ],
    latitude: -12.1211,
    longitude: -77.0297,
  ),
  CollectionPoint(
    id: 'p2',
    name: 'EcoPunto San Isidro',
    district: 'San Isidro',
    address: 'Calle Las Begonias 210',
    openingHours: 'Lun-Vie 8:00 - 17:00',
    acceptedMaterials: [
      WasteCategory.pilas,
      WasteCategory.electronicos,
      WasteCategory.metal,
    ],
    latitude: -12.0976,
    longitude: -77.0365,
  ),
  CollectionPoint(
    id: 'p3',
    name: 'Recicla Surco',
    district: 'Santiago de Surco',
    address: 'Av. Caminos del Inca 1520',
    openingHours: 'Mar-Dom 10:00 - 19:00',
    acceptedMaterials: [
      WasteCategory.plasticoPet,
      WasteCategory.vidrio,
      WasteCategory.organico,
    ],
    latitude: -12.1357,
    longitude: -76.9931,
  ),
  CollectionPoint(
    id: 'p4',
    name: 'Punto Limpio Barranco',
    district: 'Barranco',
    address: 'Av. Grau 480',
    openingHours: 'Lun-Sáb 9:00 - 16:00',
    acceptedMaterials: [
      WasteCategory.papelCarton,
      WasteCategory.plasticoPet,
      WasteCategory.metal,
    ],
    latitude: -12.1464,
    longitude: -77.0211,
  ),
  CollectionPoint(
    id: 'p5',
    name: 'EcoCentro San Borja',
    district: 'San Borja',
    address: 'Av. San Borja Norte 1115',
    openingHours: 'Lun-Vie 9:00 - 18:00',
    acceptedMaterials: [
      WasteCategory.pilas,
      WasteCategory.electronicos,
      WasteCategory.vidrio,
      WasteCategory.papelCarton,
    ],
    latitude: -12.0931,
    longitude: -76.9986,
  ),
];
