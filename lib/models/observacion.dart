class Observacion {
  final int? id;
  final String titulo;
  final String fechaHora;        
  final double? lat;
  final double? lng;
  final String? ubicacionTexto;  
  final int? duracionSeg;
  final String categoria;
  final String condicionesCielo;
  final String descripcion;
  final String? fotoPath;
  final String? audioPath;
  final String creadoEn;

  Observacion({
    this.id,
    required this.titulo,
    required this.fechaHora,
    this.lat,
    this.lng,
    this.ubicacionTexto,
    this.duracionSeg,
    required this.categoria,
    required this.condicionesCielo,
    required this.descripcion,
    this.fotoPath,
    this.audioPath,
    required this.creadoEn,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'titulo': titulo,
        'fecha_hora': fechaHora,
        'lat': lat,
        'lng': lng,
        'ubicacion_texto': ubicacionTexto,
        'duracion_seg': duracionSeg,
        'categoria': categoria,
        'condiciones_cielo': condicionesCielo,
        'descripcion': descripcion,
        'foto_path': fotoPath,
        'audio_path': audioPath,
        'creado_en': creadoEn,
      };

  factory Observacion.fromMap(Map<String, dynamic> m) => Observacion(
        id: m['id'] as int?,
        titulo: m['titulo'],
        fechaHora: m['fecha_hora'],
        lat: m['lat'],
        lng: m['lng'],
        ubicacionTexto: m['ubicacion_texto'],
        duracionSeg: m['duracion_seg'],
        categoria: m['categoria'],
        condicionesCielo: m['condiciones_cielo'],
        descripcion: m['descripcion'],
        fotoPath: m['foto_path'],
        audioPath: m['audio_path'],
        creadoEn: m['creado_en'],
      );
}