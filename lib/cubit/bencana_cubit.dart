import 'package:flutter_bloc/flutter_bloc.dart';

import '../db/database_helper.dart';
import '../models/pantauan_bencana.dart';

class BencanaCubit extends Cubit<Set<String>> {
  BencanaCubit() : super(<String>{});

  // READ - Membaca pantauan dari SQLite.
  Future<void> muatPantauan() async {
    final daftar =
        await DatabaseHelper.instance.ambilSemuaPantauan();

    if (isClosed) return;

    emit(
      daftar.map((item) => item.namaBencana).toSet(),
    );
  }

  // CREATE - Menyimpan pantauan ke SQLite.
  Future<void> tambahPantauan(String namaBencana) async {
    if (state.contains(namaBencana)) return;

    await DatabaseHelper.instance.tambahPantauan(
      PantauanBencana(
        namaBencana: namaBencana,
        waktu: DateTime.now().toString(),
      ),
    );

    if (isClosed) return;

    emit({...state, namaBencana});
  }

  // DELETE - Menghapus pantauan dari SQLite.
  Future<void> hapusPantauan(String namaBencana) async {
    await DatabaseHelper.instance.hapusPantauan(
      namaBencana,
    );

    if (isClosed) return;

    final daftarBaru = Set<String>.from(state);
    daftarBaru.remove(namaBencana);

    emit(daftarBaru);
  }

  bool sedangDipantau(String namaBencana) {
    return state.contains(namaBencana);
  }

  int get totalPantauan => state.length;
}
