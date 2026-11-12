
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/pantauan_bencana.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance =
      DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    const namaDatabase = 'mitigasi_palu.db';

    const buatTabel = '''
      CREATE TABLE pantauan_bencana (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_bencana TEXT NOT NULL UNIQUE,
        waktu TEXT NOT NULL
      )
    ''';

    if (kIsWeb) {
      return databaseFactoryFfiWeb.openDatabase(
        namaDatabase,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute(buatTabel);
          },
        ),
      );
    }

    final lokasi = join(
      await getDatabasesPath(),
      namaDatabase,
    );

    return openDatabase(
      lokasi,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(buatTabel);
      },
    );
  }

  // CREATE
  Future<int> tambahPantauan(
    PantauanBencana pantauan,
  ) async {
    final db = await database;

    return db.insert(
      'pantauan_bencana',
      pantauan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // READ
  Future<List<PantauanBencana>> ambilSemuaPantauan() async {
    final db = await database;

    final hasil = await db.query(
      'pantauan_bencana',
      orderBy: 'id DESC',
    );

    return hasil
        .map((baris) => PantauanBencana.fromMap(baris))
        .toList();
  }

  // DELETE
  Future<int> hapusPantauan(
    String namaBencana,
  ) async {
    final db = await database;

    return db.delete(
      'pantauan_bencana',
      where: 'nama_bencana = ?',
      whereArgs: [namaBencana],
    );
  }
}
