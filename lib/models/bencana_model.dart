
import 'package:flutter/foundation.dart';

class BencanaModel extends ChangeNotifier {
  final Set<String> _dipantau = {};

  Set<String> get dipantau => _dipantau;

  bool sedangDipantau(String namaBencana) {
    return _dipantau.contains(namaBencana);
  }

  void tambahPantauan(String namaBencana) {
    _dipantau.add(namaBencana);
    notifyListeners();
  }

  void hapusPantauan(String namaBencana) {
    _dipantau.remove(namaBencana);
    notifyListeners();
  }
}
