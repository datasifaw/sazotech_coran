import 'package:flutter_test/flutter_test.dart';
import 'package:sazotech_coran/sourates_screen.dart';

void main() {
  test('La bibliotheque contient Al-Fatiha et 3 sourates courtes', () {
    expect(petitesSourates.map((s) => s.numero).toList(), [112, 113, 114]);
    expect(petitesSourates.map((s) => s.versets.length).toList(), [4, 5, 6]);
    expect(petitesSourates.every((s) => s.versets.every((v) => v.trim().isNotEmpty)), isTrue);
    expect(petitesSourates.every((s) => !s.versets.contains(basmalaSouratesCourtes)), isTrue);
  });
}
