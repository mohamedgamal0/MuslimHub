import Foundation

enum DoaaData {
    static let allDoaas: [Doaa] = morningAzkar + eveningAzkar + travelDoaas + healthDoaas + generalDoaas + foodDoaas + sleepDoaas + protectionDoaas

    // MARK: - Morning Azkar
    static let morningAzkar: [Doaa] = [
        Doaa(
            textArabic: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَٰهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
            textEnglish: "We have reached the morning and at this very time the whole kingdom belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah, alone, without partner. To Him belongs all sovereignty and praise, and He is over all things omnipotent.",
            transliteration: "Asbahna wa asbahal-mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa ala kulli shayin qadir.",
            category: .morning,
            source: "Abu Dawud",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ",
            textEnglish: "O Allah, by Your leave we have reached the morning and by Your leave we have reached the evening, by Your leave we live and die and unto You is our resurrection.",
            transliteration: "Allahumma bika asbahna, wa bika amsayna, wa bika nahya, wa bika namutu, wa ilaykan-nushur.",
            category: .morning,
            source: "At-Tirmidhi",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "اللَّهُمَّ أَنْتَ رَبِّي لاَ إِلَٰهَ إِلاَّ أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ لَكَ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لاَ يَغْفِرُ الذُّنُوبَ إِلاَّ أَنْتَ",
            textEnglish: "O Allah, You are my Lord, none has the right to be worshipped except You. You created me and I am Your servant and I abide to Your covenant and promise as best I can. I take refuge in You from the evil of which I have committed. I acknowledge Your favour upon me and I acknowledge my sin, so forgive me, for verily none can forgive sins except You.",
            transliteration: "Allahumma anta rabbi la ilaha illa ant, khalaqtani wa ana abduk, wa ana ala ahdika wa wadika mastata't, a'udhu bika min sharri ma sana't, abu'u laka binimatika alayya, wa abu'u laka bidhanbi faghfir li fa innahu la yaghfirudh-dhunuba illa ant.",
            category: .morning,
            source: "Sahih Al-Bukhari - Sayyidul Istighfar",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "سُبْحَانَ اللهِ وَبِحَمْدِهِ",
            textEnglish: "Glory is to Allah and praise is to Him.",
            transliteration: "Subhanallahi wa bihamdihi.",
            category: .morning,
            source: "Muslim",
            repeatCount: 100
        ),
        Doaa(
            textArabic: "لَا إِلَٰهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
            textEnglish: "None has the right to be worshipped except Allah, alone, without partner. To Him belongs all sovereignty and praise, and He is over all things omnipotent.",
            transliteration: "La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu, wa huwa ala kulli shayin qadir.",
            category: .morning,
            source: "Al-Bukhari & Muslim",
            repeatCount: 10
        ),
    ]

    // MARK: - Evening Azkar
    static let eveningAzkar: [Doaa] = [
        Doaa(
            textArabic: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَٰهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
            textEnglish: "We have reached the evening and at this very time the whole kingdom belongs to Allah. All praise is for Allah. None has the right to be worshipped except Allah, alone, without partner. To Him belongs all sovereignty and praise, and He is over all things omnipotent.",
            transliteration: "Amsayna wa amsal-mulku lillah, walhamdu lillah, la ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu wa huwa ala kulli shayin qadir.",
            category: .evening,
            source: "Abu Dawud",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ",
            textEnglish: "O Allah, by Your leave we have reached the evening and by Your leave we have reached the morning, by Your leave we live and die and unto You is our return.",
            transliteration: "Allahumma bika amsayna, wa bika asbahna, wa bika nahya, wa bika namutu, wa ilaykal-masir.",
            category: .evening,
            source: "At-Tirmidhi",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "أَعُوذُ بِكَلِمَاتِ اللهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
            textEnglish: "I take refuge in Allah's perfect words from the evil He has created.",
            transliteration: "A'udhu bikalimatillahit-tammati min sharri ma khalaq.",
            category: .evening,
            source: "Muslim",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "بِسْمِ اللهِ الَّذِي لاَ يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الأَرْضِ وَلاَ فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
            textEnglish: "In the name of Allah with whose name nothing is harmed on earth nor in the heavens and He is The All-Hearing, The All-Knowing.",
            transliteration: "Bismillahil-ladhi la yadurru ma'asmihi shay'un fil-ardi wa la fis-sama'i wa huwas-sami'ul-alim.",
            category: .evening,
            source: "Abu Dawud & At-Tirmidhi",
            repeatCount: 3
        ),
    ]

    // MARK: - Travel Doaas
    static let travelDoaas: [Doaa] = [
        Doaa(
            textArabic: "اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَىٰ رَبِّنَا لَمُنْقَلِبُونَ",
            textEnglish: "Allah is the greatest, Allah is the greatest, Allah is the greatest. How perfect He is, the One who has placed this at our service, and we ourselves would not have been capable of that, and to our Lord is our final destiny.",
            transliteration: "Allahu Akbar, Allahu Akbar, Allahu Akbar. Subhanal-ladhi sakhkhara lana hadha wa ma kunna lahu muqrinin, wa inna ila rabbina lamunqalibun.",
            category: .travel,
            source: "Muslim",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَٰذَا الْبِرَّ وَالتَّقْوَىٰ، وَمِنَ الْعَمَلِ مَا تَرْضَىٰ",
            textEnglish: "O Allah, we ask You on this our journey for goodness and piety, and for works that are pleasing to You.",
            transliteration: "Allahumma inna nas'aluka fi safarina hadhal-birra wat-taqwa, wa minal-amali ma tarda.",
            category: .travel,
            source: "Muslim",
            repeatCount: 1
        ),
    ]

    // MARK: - Health Doaas
    static let healthDoaas: [Doaa] = [
        Doaa(
            textArabic: "اللَّهُمَّ رَبَّ النَّاسِ، أَذْهِبِ الْبَاسَ، اشْفِ أَنْتَ الشَّافِي، لاَ شِفَاءَ إِلاَّ شِفَاؤُكَ، شِفَاءً لاَ يُغَادِرُ سَقَماً",
            textEnglish: "O Allah, Lord of the people, remove the difficulty and bring about healing as You are the Healer. There is no healing but Your healing, a healing that will leave no ailment.",
            transliteration: "Allahumma Rabban-nas, adhhibil-ba's, ishfi antash-shafi, la shifa'a illa shifa'uk, shifa'an la yughadiru saqama.",
            category: .health,
            source: "Al-Bukhari & Muslim",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "أَسْأَلُ اللهَ الْعَظِيمَ رَبَّ الْعَرْشِ الْعَظِيمِ أَنْ يَشْفِيَكَ",
            textEnglish: "I ask Allah the Almighty, the Lord of the Magnificent Throne, to cure you.",
            transliteration: "As'alullahil-azim, rabbal-arshil-azim, an yashfiyak.",
            category: .health,
            source: "Abu Dawud & At-Tirmidhi",
            repeatCount: 7
        ),
    ]

    // MARK: - General Doaas
    static let generalDoaas: [Doaa] = [
        Doaa(
            textArabic: "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ",
            textEnglish: "Our Lord, give us in this world that which is good and in the Hereafter that which is good and protect us from the punishment of the Fire.",
            transliteration: "Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina adhabannaar.",
            category: .general,
            source: "Quran 2:201",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي",
            textEnglish: "My Lord, expand for me my breast and ease for me my task.",
            transliteration: "Rabbish-rahli sadri wa yassir li amri.",
            category: .general,
            source: "Quran 20:25-26",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَى وَالتُّقَى وَالْعَفَافَ وَالْغِنَى",
            textEnglish: "O Allah, I ask You for guidance, piety, chastity, and self-sufficiency.",
            transliteration: "Allahumma inni as'alukal-huda wat-tuqa wal-afafa wal-ghina.",
            category: .general,
            source: "Muslim",
            repeatCount: 1
        ),
    ]

    // MARK: - Food Doaas
    static let foodDoaas: [Doaa] = [
        Doaa(
            textArabic: "بِسْمِ اللهِ",
            textEnglish: "In the name of Allah.",
            transliteration: "Bismillah.",
            category: .food,
            source: "Muslim",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَٰذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلاَ قُوَّةٍ",
            textEnglish: "All praise is for Allah who fed me this and provided it for me without any might nor power from myself.",
            transliteration: "Alhamdu lillahil-ladhi at'amani hadha wa razaqanihi min ghayri hawlin minni wa la quwwah.",
            category: .food,
            source: "At-Tirmidhi",
            repeatCount: 1
        ),
    ]

    // MARK: - Sleep Doaas
    static let sleepDoaas: [Doaa] = [
        Doaa(
            textArabic: "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا",
            textEnglish: "In Your name O Allah, I live and die.",
            transliteration: "Bismika Allahumma amutu wa ahya.",
            category: .sleep,
            source: "Al-Bukhari",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ",
            textEnglish: "O Allah, protect me from Your punishment on the day Your servants are resurrected.",
            transliteration: "Allahumma qini adhabaka yawma tab'athu ibadak.",
            category: .sleep,
            source: "Abu Dawud",
            repeatCount: 3
        ),
    ]

    // MARK: - Protection Doaas
    static let protectionDoaas: [Doaa] = [
        Doaa(
            textArabic: "أَعُوذُ بِكَلِمَاتِ اللهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
            textEnglish: "I seek refuge in the perfect words of Allah from the evil of what He has created.",
            transliteration: "A'udhu bikalimatillahit-tammati min sharri ma khalaq.",
            category: .protection,
            source: "Muslim",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "بِسْمِ اللهِ الَّذِي لاَ يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الأَرْضِ وَلاَ فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
            textEnglish: "In the name of Allah, with whose name nothing on earth or in heaven can cause harm, and He is the All-Hearing, All-Knowing.",
            transliteration: "Bismillahil-ladhi la yadurru ma'asmihi shay'un fil-ardi wa la fis-sama'i wa huwas-sami'ul-alim.",
            category: .protection,
            source: "Abu Dawud & At-Tirmidhi",
            repeatCount: 3
        ),
    ]
}
