import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/observacion.dart';
import '../models/perfil.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();
  Database? _db;

  Future<Database> get db async => _db ??= await _initDB();

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'cielo_obs.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE observacion (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            fecha_hora TEXT NOT NULL,
            lat REAL,
            lng REAL,
            ubicacion_texto TEXT,
            duracion_seg INTEGER,
            categoria TEXT NOT NULL,
            condiciones_cielo TEXT NOT NULL,
            descripcion TEXT NOT NULL,
            foto_path TEXT,
            audio_path TEXT,
            creado_en TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE perfil (
            id INTEGER PRIMARY KEY,
            nombre TEXT NOT NULL,
            apellido TEXT NOT NULL,
            matricula TEXT NOT NULL,
            foto_path TEXT,
            frase TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertObservacion(Observacion o) async =>
      (await db).insert('observacion', o.toMap()..remove('id'));

  Future<List<Observacion>> getObservaciones({
    String? categoria,
    String? fechaDesde,
    String? fechaHasta,
    String? lugarTexto,
  }) async {
    final where = <String>[];
    final args = <dynamic>[];
    if (categoria != null) { where.add('categoria = ?'); args.add(categoria); }
    if (fechaDesde != null) { where.add('fecha_hora >= ?'); args.add(fechaDesde); }
    if (fechaHasta != null) { where.add('fecha_hora <= ?'); args.add(fechaHasta); }
    if (lugarTexto != null) { where.add('ubicacion_texto LIKE ?'); args.add('%$lugarTexto%'); }

    final rows = await (await db).query(
      'observacion',
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args,
      orderBy: 'fecha_hora DESC',
    );
    return rows.map(Observacion.fromMap).toList();
  }

  Future<Observacion?> getObservacionById(int id) async {
    final rows = await (await db).query('observacion', where: 'id = ?', whereArgs: [id]);
    return rows.isEmpty ? null : Observacion.fromMap(rows.first);
  }

  Future<int> deleteObservacion(int id) async =>
      (await db).delete('observacion', where: 'id = ?', whereArgs: [id]);

  Future<void> savePerfil(Perfil p) async =>
      (await db).insert('perfil', p.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

  Future<Perfil?> getPerfil() async {
    final rows = await (await db).query('perfil', where: 'id = 1');
    return rows.isEmpty ? null : Perfil.fromMap(rows.first);
  }

  Future<void> deleteAllObservaciones() async => (await db).delete('observacion');
}