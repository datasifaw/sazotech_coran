import 'package:flutter_test/flutter_test.dart';
import 'package:sazotech_coran/audio_sourate_widget.dart';
import 'package:sazotech_coran/favoris_store.dart';
import 'package:sazotech_coran/sourates_screen.dart';

void main() {
  test('Les 4 sourates disposent de chemins audio distincts', () {
    expect(cheminsAudio.keys.toSet(), {1, 112, 113, 114});
    expect(cheminsAudio.values.toSet().length, 4);
    expect(cheminsAudio.values.every((path) => path.endsWith('.mp3')), isTrue);
  });
  test('Les favoris utilisent des identifiants uniques', () {
    expect(FavorisStore.id(1, 1), '1:1');
    expect(FavorisStore.id(112, 1), '112:1');
    expect(FavorisStore.id(114, 6), '114:6');
  });
  test('Les 3 nouvelles sourates conservent 4, 5 et 6 versets', () {
    expect(petitesSourates.map((s) => s.numero), [112, 113, 114]);
    expect(petitesSourates.map((s) => s.versets.length), [4, 5, 6]);
  });
}
