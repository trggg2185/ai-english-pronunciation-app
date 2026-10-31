import 'package:flutter/services.dart';

class EnglishTextToIpa {
  EnglishTextToIpa({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const _dictionaryAsset = 'assets/speech_ai/cmudict.dict';
  static final _wordPattern = RegExp(r"[a-z]+(?:['’][a-z]+)*");
  static final _variantSuffix = RegExp(r'\(\d+\)$');
  static const _phonemeToIpa = <String, String>{
    'AA': 'ɑ',
    'AE': 'æ',
    'AH': 'ʌ',
    'AO': 'ɔ',
    'AW': 'aʊ',
    'AY': 'aɪ',
    'B': 'b',
    'CH': 't͡ʃ',
    'D': 'd',
    'DH': 'ð',
    'EH': 'ɛ',
    'ER': 'ɝ',
    'EY': 'eɪ',
    'F': 'f',
    'G': 'g',
    'HH': 'h',
    'IH': 'ɪ',
    'IY': 'i',
    'JH': 'd͡ʒ',
    'K': 'k',
    'L': 'l',
    'M': 'm',
    'N': 'n',
    'NG': 'ŋ',
    'OW': 'oʊ',
    'OY': 'ɔɪ',
    'P': 'p',
    'R': 'ɹ',
    'S': 's',
    'SH': 'ʃ',
    'T': 't',
    'TH': 'θ',
    'UH': 'ʊ',
    'UW': 'u',
    'V': 'v',
    'W': 'w',
    'Y': 'j',
    'Z': 'z',
    'ZH': 'ʒ',
  };

  final AssetBundle _bundle;
  Future<Map<String, String>>? _dictionary;

  Future<String> convert(String text) async {
    final words = await convertWords(text);
    return words.map((word) => word.ipa).join(' ');
  }

  Future<WordPronunciation> convertWord(String word) async {
    final pronunciations = await convertWords(word);
    if (pronunciations.length != 1) {
      throw ArgumentError.value(
        word,
        'word',
        'Must contain exactly one English word.',
      );
    }
    return pronunciations.single;
  }

  Future<List<WordPronunciation>> convertWords(String text) async {
    final words = _wordPattern
        .allMatches(text.toLowerCase().replaceAll('’', "'"))
        .map((match) => match[0]!)
        .toList(growable: false);
    if (words.isEmpty) {
      throw ArgumentError.value(
        text,
        'text',
        'Must contain at least one English word.',
      );
    }

    final dictionary = await (_dictionary ??= _loadDictionary());
    final missingWords = <String>{};
    final pronunciations = <WordPronunciation>[];
    for (final word in words) {
      final pronunciation = dictionary[word];
      if (pronunciation == null) {
        missingWords.add(word);
      } else {
        pronunciations.add(_toPronunciation(word, pronunciation));
      }
    }
    if (missingWords.isNotEmpty) {
      throw UnknownPronunciationWordsException(missingWords.toList());
    }
    return List.unmodifiable(pronunciations);
  }

  Future<Map<String, String>> _loadDictionary() async {
    final contents = await _bundle.loadString(_dictionaryAsset);
    final dictionary = <String, String>{};
    for (final line in contents.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith(';;;')) continue;
      final separator = trimmed.indexOf(' ');
      if (separator <= 0 || separator == trimmed.length - 1) continue;

      final entryWord = trimmed.substring(0, separator);
      final word = entryWord.replaceFirst(_variantSuffix, '').toLowerCase();
      dictionary.putIfAbsent(word, () => trimmed.substring(separator + 1));
    }
    return dictionary;
  }

  WordPronunciation _toPronunciation(String word, String arpabet) {
    final ipa = StringBuffer();
    final phonemes = <String>[];
    for (final symbol in arpabet.split(RegExp(r'\s+'))) {
      final match = RegExp(r'^([A-Z]+)([012]?)$').firstMatch(symbol);
      if (match == null) {
        throw FormatException('Invalid CMUdict phoneme "$symbol".');
      }
      final phoneme = switch (match[1]) {
        'AH' when match[2] == '0' => 'ə',
        'ER' when match[2] == '0' => 'ɚ',
        _ => _phonemeToIpa[match[1]!],
      };
      if (phoneme == null) {
        throw FormatException(
          'CMUdict phoneme "${match[1]}" has no IPA mapping.',
        );
      }

      if (match[2] == '1') {
        ipa.write('ˈ');
      } else if (match[2] == '2') {
        ipa.write('ˌ');
      }
      ipa.write(phoneme);
      phonemes.add(phoneme);
    }
    return WordPronunciation(
      word: word,
      ipa: ipa.toString(),
      phonemes: List.unmodifiable(phonemes),
    );
  }
}

class WordPronunciation {
  const WordPronunciation({
    required this.word,
    required this.ipa,
    required this.phonemes,
  });

  final String word;
  final String ipa;
  final List<String> phonemes;
}

class UnknownPronunciationWordsException implements Exception {
  const UnknownPronunciationWordsException(this.words);

  final List<String> words;

  @override
  String toString() =>
      'No offline pronunciation is available for: ${words.join(', ')}.';
}
