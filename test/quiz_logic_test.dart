import 'package:flutter_test/flutter_test.dart';
import 'package:sazotech_coran/quiz_screen.dart';

void main() {
  test('Le quiz comporte cinq questions avec une bonne reponse et trois choix uniques', () {
    expect(LogiqueQuizFatiha.nombreQuestions, 5);
    for (var q = 0; q < LogiqueQuizFatiha.nombreQuestions; q++) {
      final options = LogiqueQuizFatiha.choix(q);
      expect(options.length, 3);
      expect(options.toSet().length, 3);
      expect(options, contains(LogiqueQuizFatiha.bonneReponse(q)));
      expect(options.every((index) => index >= 0 && index < 7), isTrue);
    }
  });
}
