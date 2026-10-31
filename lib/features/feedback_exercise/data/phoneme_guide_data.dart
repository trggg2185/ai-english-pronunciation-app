/// Model thông tin hướng dẫn khẩu hình miệng và mẹo luyện âm
class PhonemeGuide {
  final String phoneme; // Ký tự IPA (vd: 'θ', 's', 'ʃ')
  final String name; // Tên âm vị tiếng Việt (vd: "Âm th vô thanh")
  final String category; // Phân loại (Fricative, Plosive, Vowel...)
  final bool isVoiced; // Hữu thanh (true) hay vô thanh (false)
  final String mouthShapeGuide; // Hướng dẫn chi tiết khẩu hình miệng
  final String tonguePlacement; // Vị trí đặt lưỡi
  final String lipsAndTeeth; // Vị trí răng và môi
  final String commonVietnameseError; // Lỗi thường gặp của người Việt
  final String proTip; // Mẹo luyện tập nhanh
  final List<DrillWord> drillWords; // 5 từ luyện tập chuyên sâu

  const PhonemeGuide({
    required this.phoneme,
    required this.name,
    required this.category,
    required this.isVoiced,
    required this.mouthShapeGuide,
    required this.tonguePlacement,
    required this.lipsAndTeeth,
    required this.commonVietnameseError,
    required this.proTip,
    required this.drillWords,
  });
}

/// Model từ vựng luyện tập chuyên sâu cho từng âm vị
class DrillWord {
  final String word; // Từ vựng tiếng Anh
  final String ipa; // Phiên âm IPA
  final String targetPhoneme; // Âm vị trọng tâm
  final String position; // Vị trí âm: 'initial' (đầu), 'medial' (giữa), 'final' (cuối)
  final String meaningVi; // Nghĩa tiếng Việt
  final String exampleSentence; // Câu ví dụ
  final String audioAsset; // File âm thanh mẫu

  const DrillWord({
    required this.word,
    required this.ipa,
    required this.targetPhoneme,
    required this.position,
    required this.meaningVi,
    required this.exampleSentence,
    this.audioAsset = '',
  });
}

/// Cơ sở dữ liệu tri thức âm vị học tiếng Anh chuẩn dành cho người Việt
class PhonemeGuideDatabase {
  static final Map<String, PhonemeGuide> _guideMap = {
    // 1. Âm /θ/ (Voiceless dental fricative - think, thank)
    'θ': const PhonemeGuide(
      phoneme: 'θ',
      name: 'Âm "th" vô thanh (/θ/)',
      category: 'Phụ âm xát răng (Dental Fricative)',
      isVoiced: false,
      mouthShapeGuide:
          'Đặt đầu lưỡi nhẹ giữa hai hàm răng trên và dưới. Nhẹ nhàng thổi luồng không khí qua khe giữa lưỡi và răng trên. Dây thanh quản KHÔNG rung.',
      tonguePlacement: 'Đầu lưỡi hơi thè ra ngoài khoảng 2mm giữa hai hàm răng, thả lỏng.',
      lipsAndTeeth: 'Hai hàm răng khép nhẹ vào lưỡi (không cắn chặt), môi hơi mở tự nhiên.',
      commonVietnameseError:
          'Người Việt hay biến thành âm /t/ (vd: think -> tink) hoặc âm /s/ (think -> sink).',
      proTip:
          'Soi gương khi phát âm: Nếu không nhìn thấy đầu lưỡi thè ra một chút giữa hai hàm răng là chưa đúng khẩu hình.',
      drillWords: [
        DrillWord(
          word: 'think',
          ipa: '/θɪŋk/',
          targetPhoneme: 'θ',
          position: 'initial',
          meaningVi: 'suy nghĩ, ngẫm nghĩ',
          exampleSentence: 'I think you are right.',
        ),
        DrillWord(
          word: 'thank',
          ipa: '/θæŋk/',
          targetPhoneme: 'θ',
          position: 'initial',
          meaningVi: 'cảm ơn',
          exampleSentence: 'Thank you very much.',
        ),
        DrillWord(
          word: 'birthday',
          ipa: '/ˈbɜːrθdeɪ/',
          targetPhoneme: 'θ',
          position: 'medial',
          meaningVi: 'ngày sinh nhật',
          exampleSentence: 'Happy birthday to my best friend.',
        ),
        DrillWord(
          word: 'tooth',
          ipa: '/tuːθ/',
          targetPhoneme: 'θ',
          position: 'final',
          meaningVi: 'răng (số ít)',
          exampleSentence: 'I need to brush my tooth carefully.',
        ),
        DrillWord(
          word: 'mouth',
          ipa: '/maʊθ/',
          targetPhoneme: 'θ',
          position: 'final',
          meaningVi: 'miệng',
          exampleSentence: 'Open your mouth and breathe slowly.',
        ),
      ],
    ),

    // 2. Âm /ð/ (Voiced dental fricative - this, that, mother)
    'ð': const PhonemeGuide(
      phoneme: 'ð',
      name: 'Âm "th" hữu thanh (/ð/)',
      category: 'Phụ âm xát răng hữu thanh',
      isVoiced: true,
      mouthShapeGuide:
          'Khẩu hình miệng giống hệt âm /θ/, nhưng cần làm RUNG dây thanh quản trong cổ họng khi luồng hơi thoát ra.',
      tonguePlacement: 'Đầu lưỡi đặt giữa hai hàm răng, rung nhẹ khi luồng âm thoát ra.',
      lipsAndTeeth: 'Răng trên chạm nhẹ mặt trên của đầu lưỡi.',
      commonVietnameseError:
          'Hay bị phát âm thành âm /d/ trong tiếng Việt (this -> đít, that -> đát).',
      proTip: 'Đặt một ngón tay lên cổ họng, bạn phải cảm nhận được sự rung rõ rệt khi phát âm âm này.',
      drillWords: [
        DrillWord(
          word: 'this',
          ipa: '/ðɪs/',
          targetPhoneme: 'ð',
          position: 'initial',
          meaningVi: 'cái này, điều này',
          exampleSentence: 'This is my favorite English app.',
        ),
        DrillWord(
          word: 'that',
          ipa: '/ðæt/',
          targetPhoneme: 'ð',
          position: 'initial',
          meaningVi: 'cái kia, điều đó',
          exampleSentence: 'That was an amazing pronunciation session.',
        ),
        DrillWord(
          word: 'mother',
          ipa: '/ˈmʌðər/',
          targetPhoneme: 'ð',
          position: 'medial',
          meaningVi: 'người mẹ',
          exampleSentence: 'My mother always encourages my daily practice.',
        ),
        DrillWord(
          word: 'weather',
          ipa: '/ˈweðər/',
          targetPhoneme: 'ð',
          position: 'medial',
          meaningVi: 'thời tiết',
          exampleSentence: 'The weather is great for outdoor study.',
        ),
        DrillWord(
          word: 'breathe',
          ipa: '/briːð/',
          targetPhoneme: 'ð',
          position: 'final',
          meaningVi: 'thở, hít thở',
          exampleSentence: 'Take a deep breath and relax.',
        ),
      ],
    ),

    // 3. Âm /s/ (Voiceless alveolar fricative - see, likes, books)
    's': const PhonemeGuide(
      phoneme: 's',
      name: 'Âm xì vô thanh (/s/)',
      category: 'Phụ âm xát chân răng',
      isVoiced: false,
      mouthShapeGuide:
          'Khép nhẹ hai hàm răng. Mỉm cười kéo khóe môi sang hai bên. Đặt đầu lưỡi ngay sau chân răng trên, ép luồng hơi xì mạnh ra ngoài kẽ răng.',
      tonguePlacement: 'Đầu lưỡi nâng lên gần chạm vòm chân răng trên nhưng không được bịt kín.',
      lipsAndTeeth: 'Hai hàm răng gần chạm nhau, môi bẹt sang hai bên như đang cười.',
      commonVietnameseError:
          'Rất hay bị nuốt (bỏ quên) âm /s/ ở vị trí cuối từ (likes, books, cats) hoặc nhầm sang /ʃ/.',
      proTip:
          'Âm đuôi /s/ trong tiếng Anh cực kỳ quan trọng vì nó thể hiện số nhiều và thì hiện tại ngôi thứ ba!',
      drillWords: [
        DrillWord(
          word: 'see',
          ipa: '/siː/',
          targetPhoneme: 's',
          position: 'initial',
          meaningVi: 'nhìn thấy, trông thấy',
          exampleSentence: 'I see your progress every day.',
        ),
        DrillWord(
          word: 'likes',
          ipa: '/laɪks/',
          targetPhoneme: 's',
          position: 'final',
          meaningVi: 'thích (ngôi thứ 3)',
          exampleSentence: 'She likes reading English books.',
        ),
        DrillWord(
          word: 'books',
          ipa: '/bʊks/',
          targetPhoneme: 's',
          position: 'final',
          meaningVi: 'những cuốn sách (số nhiều)',
          exampleSentence: 'These books are very helpful.',
        ),
        DrillWord(
          word: 'lesson',
          ipa: '/ˈlesn/',
          targetPhoneme: 's',
          position: 'medial',
          meaningVi: 'bài học',
          exampleSentence: 'Today lesson focuses on ending consonants.',
        ),
        DrillWord(
          word: 'cats',
          ipa: '/kæts/',
          targetPhoneme: 's',
          position: 'final',
          meaningVi: 'những con mèo',
          exampleSentence: 'The two cats sleep peacefully.',
        ),
      ],
    ),

    // 4. Âm /z/ (Voiced alveolar fricative - zoo, days, dogs)
    'z': const PhonemeGuide(
      phoneme: 'z',
      name: 'Âm rung chân răng (/z/)',
      category: 'Phụ âm xát hữu thanh',
      isVoiced: true,
      mouthShapeGuide:
          'Khẩu hình tương tự âm /s/ nhưng rung dây thanh quản tạo tiếng kêu "dzzzz" như tiếng ong vỗ cánh.',
      tonguePlacement: 'Đầu lưỡi gần chạm chân răng trên.',
      lipsAndTeeth: 'Hai hàm răng khép hờ, luồng hơi đi kèm tiếng rung cổ họng.',
      commonVietnameseError:
          'Thường bị đọc thành /s/ (mất rung) hoặc phát âm thành /d/ hoặc /j/.',
      proTip: 'Tập phát âm kéo dài âm /s/, sau đó bật thêm rung giọng từ thanh quản để chuyển mượt sang /z/.',
      drillWords: [
        DrillWord(
          word: 'zoo',
          ipa: '/zuː/',
          targetPhoneme: 'z',
          position: 'initial',
          meaningVi: 'sở thú',
          exampleSentence: 'We visited the city zoo yesterday.',
        ),
        DrillWord(
          word: 'easy',
          ipa: '/ˈiːzi/',
          targetPhoneme: 'z',
          position: 'medial',
          meaningVi: 'dễ dàng',
          exampleSentence: 'Pronunciation becomes easy with consistent practice.',
        ),
        DrillWord(
          word: 'days',
          ipa: '/deɪz/',
          targetPhoneme: 'z',
          position: 'final',
          meaningVi: 'những ngày',
          exampleSentence: 'I maintained a streak of seven days.',
        ),
        DrillWord(
          word: 'music',
          ipa: '/ˈmjuːzɪk/',
          targetPhoneme: 'z',
          position: 'medial',
          meaningVi: 'âm nhạc',
          exampleSentence: 'Listen to English music to improve listening.',
        ),
        DrillWord(
          word: 'dogs',
          ipa: '/dɔːɡz/',
          targetPhoneme: 'z',
          position: 'final',
          meaningVi: 'những chú chó',
          exampleSentence: 'Friendly dogs played on the lawn.',
        ),
      ],
    ),

    // 5. Âm /ʃ/ (Voiceless postalveolar fricative - she, shoe, fish)
    'ʃ': const PhonemeGuide(
      phoneme: 'ʃ',
      name: 'Âm "s" nặng / cong lưỡi (/ʃ/)',
      category: 'Phụ âm xát vòm miệng',
      isVoiced: false,
      mouthShapeGuide:
          'Môi chu tròn hướng về phía trước. Nâng thân lưỡi lên gần vòm miệng cứng, thổi luồng hơi mạnh ra tạo âm thanh như tiếng yêu cầu giữ im lặng "suỵt".',
      tonguePlacement: 'Thân lưỡi hơi lùi về phía sau so với âm /s/, uốn nhẹ.',
      lipsAndTeeth: 'Môi hơi chu tròn mở ra trước.',
      commonVietnameseError:
          'Thường bị nói bẹt miệng thành âm /s/ nhẹ thông thường.',
      proTip: 'Hãy nhớ chu môi tròn rõ rệt khi phát âm âm này.',
      drillWords: [
        DrillWord(
          word: 'she',
          ipa: '/ʃiː/',
          targetPhoneme: 'ʃ',
          position: 'initial',
          meaningVi: 'cô ấy, bà ấy',
          exampleSentence: 'She speaks English with confidence.',
        ),
        DrillWord(
          word: 'shoe',
          ipa: '/ʃuː/',
          targetPhoneme: 'ʃ',
          position: 'initial',
          meaningVi: 'chiếc giày',
          exampleSentence: 'He put on his favorite running shoe.',
        ),
        DrillWord(
          word: 'fashion',
          ipa: '/ˈfæʃn/',
          targetPhoneme: 'ʃ',
          position: 'medial',
          meaningVi: 'thời trang',
          exampleSentence: 'Modern fashion embraces individuality.',
        ),
        DrillWord(
          word: 'fish',
          ipa: '/fɪʃ/',
          targetPhoneme: 'ʃ',
          position: 'final',
          meaningVi: 'con cá',
          exampleSentence: 'Fresh fish is packed with nutrients.',
        ),
        DrillWord(
          word: 'English',
          ipa: '/ˈɪŋɡlɪʃ/',
          targetPhoneme: 'ʃ',
          position: 'final',
          meaningVi: 'tiếng Anh',
          exampleSentence: 'Practice English every single day.',
        ),
      ],
    ),

    // 6. Âm /d/ (Voiced alveolar stop - day, good, and)
    'd': const PhonemeGuide(
      phoneme: 'd',
      name: 'Âm "d" bật hơi hữu thanh (/d/)',
      category: 'Phụ âm tắc chân răng',
      isVoiced: true,
      mouthShapeGuide:
          'Đầu lưỡi chặn chặt vào phần chân răng trên để giữ khí trong khoang miệng, sau đó hạ nhanh lưỡi để luồng hơi bật ra đồng thời làm rung thanh quản.',
      tonguePlacement: 'Đầu lưỡi áp sát chân răng trên.',
      lipsAndTeeth: 'Môi mở tự nhiên.',
      commonVietnameseError:
          'Khi ở cuối từ (good, and, hard), người Việt rất hay bỏ quên âm đuôi /d/.',
      proTip: 'Ở cuối từ, chỉ cần chặn hơi nhẹ ở chân răng trên và nhả âm /d/ tinh tế, không cần bật quá to.',
      drillWords: [
        DrillWord(
          word: 'day',
          ipa: '/deɪ/',
          targetPhoneme: 'd',
          position: 'initial',
          meaningVi: 'ngày, ban ngày',
          exampleSentence: 'Have a wonderful day!',
        ),
        DrillWord(
          word: 'good',
          ipa: '/ɡʊd/',
          targetPhoneme: 'd',
          position: 'final',
          meaningVi: 'tốt, hay',
          exampleSentence: 'You did a very good job.',
        ),
        DrillWord(
          word: 'and',
          ipa: '/ænd/',
          targetPhoneme: 'd',
          position: 'final',
          meaningVi: 'và',
          exampleSentence: 'Practice listening and speaking regularly.',
        ),
        DrillWord(
          word: 'ready',
          ipa: '/ˈredi/',
          targetPhoneme: 'd',
          position: 'medial',
          meaningVi: 'sẵn sàng',
          exampleSentence: 'Are you ready for the test?',
        ),
        DrillWord(
          word: 'card',
          ipa: '/kɑːrd/',
          targetPhoneme: 'd',
          position: 'final',
          meaningVi: 'thẻ, danh thiếp',
          exampleSentence: 'Tap the flash card to see details.',
        ),
      ],
    ),
  };

  /// Lấy hướng dẫn khẩu hình theo ký tự âm vị, có fallback mặc định
  static PhonemeGuide getGuide(String phoneme) {
    // Chuẩn hóa ký tự loại bỏ dấu gạch chéo nếu có
    final clean = phoneme.replaceAll('/', '').trim();
    if (_guideMap.containsKey(clean)) {
      return _guideMap[clean]!;
    }
    // Fallback nếu gặp âm chưa có trong map cố định
    return PhonemeGuide(
      phoneme: phoneme,
      name: 'Âm vị /$phoneme/',
      category: 'Âm vị chuẩn IPA',
      isVoiced: false,
      mouthShapeGuide:
          'Thả lỏng cơ hàm, mở khẩu hình theo phiên âm chuẩn IPA và chú ý vị trí luồng hơi thoát ra.',
      tonguePlacement: 'Giữ vị trí lưỡi tự nhiên, không gồng cứng.',
      lipsAndTeeth: 'Mở khẩu hình vừa phải theo âm thanh mẫu.',
      commonVietnameseError: 'Phát âm chưa tròn vành rõ chữ hoặc ngắt âm quá sớm.',
      proTip: 'Lắng nghe kỹ âm mẫu bản ngữ và lặp lại 5 lần liên tiếp trước gương.',
      drillWords: [
        DrillWord(
          word: 'example',
          ipa: '/ɪɡˈzæmpl/',
          targetPhoneme: phoneme,
          position: 'medial',
          meaningVi: 'ví dụ mẫu',
          exampleSentence: 'Follow this pronunciation example.',
        ),
      ],
    );
  }

  /// Kiểm tra xem một âm vị có trong từ điển hướng dẫn không
  static bool hasGuide(String phoneme) {
    final clean = phoneme.replaceAll('/', '').trim();
    return _guideMap.containsKey(clean);
  }
}
