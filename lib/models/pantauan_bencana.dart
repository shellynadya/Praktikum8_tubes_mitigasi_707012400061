
class PantauanBencana {
  final int? id;
  final String namaBencana;
  final String waktu;

  const PantauanBencana({
    this.id,
    required this.namaBencana,
    required this.waktu,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_bencana': namaBencana,
      'waktu': waktu,
    };
  }

  factory PantauanBencana.fromMap(
    Map<String, dynamic> map,
  ) {
    return PantauanBencana(
      id: map['id'] as int?,
      namaBencana: map['nama_bencana'] as String,
      waktu: map['waktu'] as String,
    );
  }
}
