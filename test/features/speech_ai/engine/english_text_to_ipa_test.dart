import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/features/speech_ai/engine/english_text_to_ipa.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late EnglishTextToIpa converter;

  setUp(() {
    converter = EnglishTextToIpa();
  });

  group('EnglishTextToIpa', () {
    test('converts the full sample sentence using bundled CMUdict', () async {
      final ipa = await converter.convert(
        'The quick brown fox jumps over the lazy dog.',
      );

      expect(ipa, 'ðə kwˈɪk bɹˈaʊn fˈɑks d͡ʒˈʌmps ˈoʊvɚ ðə lˈeɪzi dˈɔg');
    });

    test('uses the first dictionary variant and ignores punctuation', () async {
      expect(await converter.convert('A!'), 'ə');
    });

    test('converts unstressed AH to schwa', () async {
      expect(await converter.convert('the'), 'ðə');
    });

    test('reports words not in the local dictionary', () async {
      await expectLater(
        converter.convert('flibbertigibbet'),
        throwsA(
          isA<UnknownPronunciationWordsException>().having(
            (error) => error.words,
            'words',
            ['flibbertigibbet'],
          ),
        ),
      );
    });

    test('rejects text that has no English words', () async {
      await expectLater(converter.convert('123 !!!'), throwsArgumentError);
    });
  });
}
