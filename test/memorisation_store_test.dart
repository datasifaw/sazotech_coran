import 'package:flutter_test/flutter_test.dart';
import 'package:sazotech_coran/memorisation_store.dart';
import 'package:sazotech_coran/coran_114_store.dart';

void main() {
  test('Clés uniques par sourate et dernier verset', () {
    expect(MemorisationStore.cle, 'sazotech_coran_sourates_apprises_v1');
    expect(DernierVerset114.cle(1), isNot(DernierVerset114.cle(114)));
  });
  test('Modèle du corpus avec lecture par numéro', () {
    final corpus = Corpus114(source: 'test', url: 'test', sourates: [
      const Sourate114(numero: 1, nom: 'Test', nomArabe: 'اختبار', versets: ['نص']),
    ]);
    expect(corpus.trouver(1)?.versets.length, 1);
    expect(corpus.trouver(114), isNull);
  });
}
