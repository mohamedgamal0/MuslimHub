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
        Doaa(
            textArabic: "اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لاَ إِلَٰهَ إِلاَّ أَنْتَ",
            textEnglish: "O Allah, grant me health in my body. O Allah, grant me health in my hearing. O Allah, grant me health in my sight. There is no god but You.",
            transliteration: "Allahumma afini fi badani, Allahumma afini fi sam'i, Allahumma afini fi basari, la ilaha illa ant.",
            category: .morning,
            source: "Abu Dawud",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَأَعُوذُ بِكَ مِنَ الْعَجْزِ وَالْكَسَلِ، وَأَعُوذُ بِكَ مِنَ الْجُبْنِ وَالْبُخْلِ، وَأَعُوذُ بِكَ مِنْ غَلَبَةِ الدَّيْنِ وَقَهْرِ الرِّجَالِ",
            textEnglish: "O Allah, I take refuge in You from worry and grief, from incapacity and laziness, from cowardice and miserliness, and from being overcome by debt and the oppression of men.",
            transliteration: "Allahumma inni a'udhu bika minal-hammi wal-hazan, wa a'udhu bika minal-ajzi wal-kasal, wa a'udhu bika minal-jubni wal-bukhl, wa a'udhu bika min ghalabatid-dayni wa qahrir-rijal.",
            category: .morning,
            source: "Abu Dawud",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "قُلْ هُوَ اللَّهُ أَحَدٌ",
            textEnglish: "Say: He is Allah, the One.",
            transliteration: "Qul Huwallahu Ahad.",
            category: .morning,
            source: "Quran 112:1",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ",
            textEnglish: "Say: I seek refuge in the Lord of the daybreak.",
            transliteration: "Qul A'udhu bi Rabbil-falaq.",
            category: .morning,
            source: "Quran 113:1",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "قُلْ أَعُوذُ بِرَبِّ النَّاسِ",
            textEnglish: "Say: I seek refuge in the Lord of mankind.",
            transliteration: "Qul A'udhu bi Rabbin-nas.",
            category: .morning,
            source: "Quran 114:1",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "أَعُوذُ بِكَلِمَاتِ اللهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
            textEnglish: "I take refuge in Allah's perfect words from the evil He has created.",
            transliteration: "A'udhu bikalimatillahit-tammati min sharri ma khalaq.",
            category: .morning,
            source: "Muslim",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "بِسْمِ اللهِ الَّذِي لاَ يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الأَرْضِ وَلاَ فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
            textEnglish: "In the name of Allah with whose name nothing is harmed on earth nor in the heavens and He is The All-Hearing, The All-Knowing.",
            transliteration: "Bismillahil-ladhi la yadurru ma'asmihi shay'un fil-ardi wa la fis-sama'i wa huwas-sami'ul-alim.",
            category: .morning,
            source: "Abu Dawud & At-Tirmidhi",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "رَضِيتُ بِاللهِ رَبّاً وَبِالإِسْلاَمِ دِيناً وَبِمُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ نَبِيّاً",
            textEnglish: "I am pleased with Allah as my Lord, with Islam as my religion, and with Muhammad (peace be upon him) as my Prophet.",
            transliteration: "Raditu billahi rabban wa bil-Islami dinan wa bi-Muhammadin sallallahu alayhi wa sallama nabiyya.",
            category: .morning,
            source: "Abu Dawud & At-Tirmidhi",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "اللَّهُمَّ مَا أَصْبَحَ بِي مِنْ نِعْمَةٍ أَوْ بِأَحَدٍ مِنْ خَلْقِكَ فَمِنْكَ وَحْدَكَ لاَ شَرِيكَ لَكَ فَلَكَ الْحَمْدُ وَلَكَ الشُّكْرُ",
            textEnglish: "O Allah, whatever blessing has been received by me or any of Your creation is from You alone. You have no partner. So to You alone is all praise and thanks.",
            transliteration: "Allahumma ma asbaha bi min ni'matin aw bi-ahadin min khalqik fa minka wahdaka la sharika lak, fa lakal-hamdu wa lakash-shukr.",
            category: .morning,
            source: "Abu Dawud",
            repeatCount: 1
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
        Doaa(
            textArabic: "سُبْحَانَ اللهِ وَبِحَمْدِهِ",
            textEnglish: "Glory is to Allah and praise is to Him.",
            transliteration: "Subhanallahi wa bihamdihi.",
            category: .evening,
            source: "Muslim",
            repeatCount: 100
        ),
        Doaa(
            textArabic: "لَا إِلَٰهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
            textEnglish: "None has the right to be worshipped except Allah, alone, without partner. To Him belongs all sovereignty and praise, and He is over all things omnipotent.",
            transliteration: "La ilaha illallahu wahdahu la sharika lah, lahul-mulku wa lahul-hamdu, wa huwa ala kulli shayin qadir.",
            category: .evening,
            source: "Al-Bukhari & Muslim",
            repeatCount: 10
        ),
        Doaa(
            textArabic: "اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لاَ إِلَٰهَ إِلاَّ أَنْتَ",
            textEnglish: "O Allah, grant me health in my body. O Allah, grant me health in my hearing. O Allah, grant me health in my sight. There is no god but You.",
            transliteration: "Allahumma afini fi badani, Allahumma afini fi sam'i, Allahumma afini fi basari, la ilaha illa ant.",
            category: .evening,
            source: "Abu Dawud",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "اللَّهُمَّ إِنِّي أَمْسَيْتُ أُشْهِدُكَ وَأُشْهِدُ حَمَلَةَ عَرْشِكَ وَمَلاَئِكَتَكَ وَجَمِيعَ خَلْقِكَ أَنَّكَ أَنْتَ اللَّهُ لاَ إِلَٰهَ إِلاَّ أَنْتَ وَأَنَّ مُحَمَّداً عَبْدُكَ وَرَسُولُكَ",
            textEnglish: "O Allah, I have reached the evening and call upon You and the bearers of Your Throne and Your angels and all Your creation to witness that You are Allah, there is no god but You, and Muhammad is Your servant and Messenger.",
            transliteration: "Allahumma inni amsaytu ushiduka wa ushidu hamalata arshika wa mala'ikatak wa jami'a khalqik, annaka Antallah la ilaha illa Ant wa anna Muhammadan abduka wa rasuluk.",
            category: .evening,
            source: "Abu Dawud",
            repeatCount: 4
        ),
        Doaa(
            textArabic: "قُلْ هُوَ اللَّهُ أَحَدٌ",
            textEnglish: "Say: He is Allah, the One.",
            transliteration: "Qul Huwallahu Ahad.",
            category: .evening,
            source: "Quran 112:1",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ",
            textEnglish: "Say: I seek refuge in the Lord of the daybreak.",
            transliteration: "Qul A'udhu bi Rabbil-falaq.",
            category: .evening,
            source: "Quran 113:1",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "قُلْ أَعُوذُ بِرَبِّ النَّاسِ",
            textEnglish: "Say: I seek refuge in the Lord of mankind.",
            transliteration: "Qul A'udhu bi Rabbin-nas.",
            category: .evening,
            source: "Quran 114:1",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "رَضِيتُ بِاللهِ رَبّاً وَبِالإِسْلاَمِ دِيناً وَبِمُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ نَبِيّاً",
            textEnglish: "I am pleased with Allah as my Lord, with Islam as my religion, and with Muhammad (peace be upon him) as my Prophet.",
            transliteration: "Raditu billahi rabban wa bil-Islami dinan wa bi-Muhammadin sallallahu alayhi wa sallama nabiyya.",
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
        Doaa(
            textArabic: "سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَىٰ رَبِّنَا لَمُنْقَلِبُونَ، اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَٰذَا الْبِرَّ وَالتَّقْوَىٰ وَمِنَ الْعَمَلِ مَا تَرْضَىٰ، اللَّهُمَّ هَوِّنْ عَلَيْنَا سَفَرَنَا هَٰذَا وَاطْوِ عَنَّا بُعْدَهُ",
            textEnglish: "Glory to Him who has placed this at our service, and we could not have done it ourselves. And to our Lord we are returning. O Allah, we ask You for righteousness and piety in this journey and for deeds that please You. O Allah, make this journey easy for us and shorten its distance.",
            transliteration: "Subhanal-ladhi sakhkhara lana hadha wa ma kunna lahu muqrinin wa inna ila rabbina lamunqalibun. Allahumma inna nas'aluka fi safarina hadhal-birra wat-taqwa wa minal-amali ma tarda. Allahumma hawwin alayna safarana hadha watwi anna bu'dah.",
            category: .travel,
            source: "Muslim",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "اللَّهُمَّ إِنَّا نَعُوذُ بِكَ مِنْ وَعْثَاءِ السَّفَرِ وَكَآبَةِ الْمَنْظَرِ وَسُوءِ الْمُنْقَلَبِ فِي الْمَالِ وَالأَهْلِ",
            textEnglish: "O Allah, we seek refuge in You from the hardships of travel, from a gloomy sight, and from an evil return in property and family.",
            transliteration: "Allahumma inna na'udhu bika min wa'thaa'is-safari wa ka'abatil-manzari wa su'il-munqalabi fil-mali wal-ahl.",
            category: .travel,
            source: "Muslim",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "رَبَّنَا أَنزِلْنَا مُنزَلاً مُّبَارَكاً وَأَنتَ خَيْرُ الْمُنزِلِينَ",
            textEnglish: "Our Lord, cause us to land at a blessed landing-place; indeed You are the best of those who bring to land.",
            transliteration: "Rabbana anzilna munzalan mubarakan wa Anta khayrul-munzilin.",
            category: .travel,
            source: "Quran 23:29 (on arrival)",
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
        Doaa(
            textArabic: "بِسْمِ اللهِ أَرْقِيكَ، مِنْ كُلِّ شَيْءٍ يُؤْذِيكَ، مِنْ شَرِّ كُلِّ نَفْسٍ أَوْ عَيْنِ حَاسِدٍ، اللَّهُمَّ يَشْفِيكَ",
            textEnglish: "In the name of Allah I perform ruqyah for you, from everything that harms you, from the evil of every soul or envious eye. O Allah, heal you.",
            transliteration: "Bismillahi arqik, min kulli shay'in yu'dhik, min sharri kulli nafsin aw ayni hasidin, Allahumma yashfik.",
            category: .health,
            source: "Muslim",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "اللَّهُمَّ اشْفِ عَبْدَكَ يَنْكَأُ لَكَ عَدُوّاً أَوْ يَمْشِي لَكَ إِلَى صَلاَةٍ",
            textEnglish: "O Allah, heal Your servant so that he may strike a blow for You or walk to prayer for You.",
            transliteration: "Allahumma ishfi abdak, yanka'u laka duwwan aw yamshi laka ila salatin.",
            category: .health,
            source: "Abu Dawud",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "لاَ بَأْسَ طَهُورٌ إِنْ شَاءَ اللهُ",
            textEnglish: "There is no harm; it is a purification, if Allah wills.",
            transliteration: "La ba'sa tahurun in sha' Allah.",
            category: .health,
            source: "Al-Bukhari",
            repeatCount: 1
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
        Doaa(
            textArabic: "اللَّهُمَّ اغْفِرْ لِي وَارْحَمْنِي وَاهْدِنِي وَعَافِنِي وَارْزُقْنِي",
            textEnglish: "O Allah, forgive me, have mercy on me, guide me, grant me health, and provide for me.",
            transliteration: "Allahumma ghfir li warhamni wahdini wa afini warzuqni.",
            category: .general,
            source: "Muslim",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنَ الْخَيْرِ كُلِّهِ الْعَاجِلِ وَالآجِلِ، مَا عَلِمْتُ مِنْهُ وَمَا لَمْ أَعْلَمْ، وَأَعُوذُ بِكَ مِنَ الشَّرِّ كُلِّهِ",
            textEnglish: "O Allah, I ask You for all that is good, in this world and the next, what I know and what I do not know. And I seek refuge in You from all evil.",
            transliteration: "Allahumma inni as'aluka minal-khayri kullihi al-ajili wal-ajil, ma alimtu minhu wa ma lam a'lam, wa a'udhu bika minash-sharri kullih.",
            category: .general,
            source: "Ibn Majah",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ زَوَالِ نِعْمَتِكَ وَتَحَوُّلِ عَافِيَتِكَ وَفُجَاءَةِ نِقْمَتِكَ وَجَمِيعِ سَخَطِكَ",
            textEnglish: "O Allah, I seek refuge in You from the withdrawal of Your blessing, from the change of Your protection, from the sudden onset of Your punishment, and from all Your displeasure.",
            transliteration: "Allahumma inni a'udhu bika min zawali ni'matik wa tahawwuli afiyatik wa fuja'ati niqmatik wa jami'i sakhatik.",
            category: .general,
            source: "Muslim",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْماً نَافِعاً وَرِزْقاً طَيِّباً وَعَمَلاً مُتَقَبَّلاً",
            textEnglish: "O Allah, I ask You for beneficial knowledge, wholesome provision, and accepted deeds.",
            transliteration: "Allahumma inni as'aluka ilman nafi'an wa rizqan tayyiban wa amalan mutaqabbalan.",
            category: .general,
            source: "Ibn Majah",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "رَبَّنَا لاَ تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً إِنَّكَ أَنْتَ الْوَهَّابُ",
            textEnglish: "Our Lord, do not let our hearts deviate after You have guided us. Grant us mercy from Yourself; indeed You are the Bestower.",
            transliteration: "Rabbana la tuzigh qulubana ba'da idh hadaytana wa hab lana min ladunka rahmah, innaka Antal-Wahhab.",
            category: .general,
            source: "Quran 3:8",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ التَّوْفِيقَ وَالْعَافِيَةَ وَالْمَعَافَاةَ وَالْمُعَافَاةَ فِي الدِّينِ وَالدُّنْيَا وَالآخِرَةِ",
            textEnglish: "O Allah, I ask You for success, health, safety, and well-being in religion, this world, and the Hereafter.",
            transliteration: "Allahumma inni as'alukat-tawfiq wal-afiyah wal-ma'afata wal-mu'afata fid-dini wad-dunya wal-akhirah.",
            category: .general,
            source: "Authentic",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "لاَ إِلَٰهَ إِلاَّ أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ",
            textEnglish: "There is no god but You; glory be to You. Indeed I have been among the wrongdoers.",
            transliteration: "La ilaha illa Anta subhanak, inni kuntu minaz-zalimin.",
            category: .general,
            source: "Quran 21:87 - Dua of Yunus",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ يَا اللهُ الأَحَدُ الصَّمَدُ الَّذِي لَمْ يَلِدْ وَلَمْ يُولَدْ وَلَمْ يَكُنْ لَهُ كُفُواً أَحَدٌ أَنْ تَغْفِرَ لِي ذُنُوبِي إِنَّكَ أَنْتَ الْغَفُورُ الرَّحِيمُ",
            textEnglish: "O Allah, I ask You, O Allah the One, the Self-Sufficient, who has not begotten nor was begotten, and there is none comparable to Him, to forgive my sins. Indeed You are the Forgiving, the Merciful.",
            transliteration: "Allahumma inni as'aluka ya Allahul-Ahadus-Samad, alladhi lam yalid wa lam yulad wa lam yakun lahu kufuwan ahad, an taghfira li dhunubi, innaka Antal-Ghafurur-Rahim.",
            category: .general,
            source: "Abu Dawud",
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
            textArabic: "بِسْمِ اللهِ فِي أَوَّلِهِ وَآخِرِهِ",
            textEnglish: "In the name of Allah at the beginning and the end.",
            transliteration: "Bismillahi fi awwalihi wa akhirih.",
            category: .food,
            source: "Abu Dawud & At-Tirmidhi",
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
        Doaa(
            textArabic: "الْحَمْدُ لِلَّهِ حَمْداً كَثِيراً طَيِّباً مُبَارَكاً فِيهِ، غَيْرَ مَكْفِيٍّ وَلاَ مُوَدَّعٍ وَلاَ مُسْتَغْنًى عَنْهُ رَبَّنَا",
            textEnglish: "All praise is for Allah, much good and blessed praise. He is not to be left, nor abandoned, nor is He to be dispensed with, our Lord.",
            transliteration: "Alhamdu lillahi hamdan kathiran tayyiban mubarakan fih, ghayra makfiyyin wa la muwadda'in wa la mustaghnan anhu Rabbana.",
            category: .food,
            source: "Al-Bukhari",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "اللَّهُمَّ بَارِكْ لَنَا فِيمَا رَزَقْتَنَا وَقِنَا عَذَابَ النَّارِ",
            textEnglish: "O Allah, bless us in what You have provided for us and protect us from the punishment of the Fire.",
            transliteration: "Allahumma barik lana fima razaqtana wa qina adhaban-nar.",
            category: .food,
            source: "Ibn As-Sunni",
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
        Doaa(
            textArabic: "اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ وَوَجَّهْتُ وَجْهِي إِلَيْكَ وَفَوَّضْتُ أَمْرِي إِلَيْكَ وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ رَغْبَةً وَرَهْبَةً إِلَيْكَ لاَ مَلْجَأَ وَلاَ مَنْجَا مِنْكَ إِلاَّ إِلَيْكَ آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ وَبِنَبِيِّكَ الَّذِي أَرْسَلْتَ",
            textEnglish: "O Allah, I have submitted myself to You, turned my face to You, entrusted my affair to You, and committed my back to You out of hope and fear of You. There is no refuge or escape from You except to You. I believe in Your Book which You have sent down and in Your Prophet whom You have sent.",
            transliteration: "Allahumma aslamtu nafsi ilayk wa wajjahtu wajhi ilayk wa fawwadtu amri ilayk wa alja'tu zahri ilayk raghbatan wa rahbatan ilayk, la malja'a wa la manja minka illa ilayk. Amantu bikitabikal-ladhi anzalt wa binabiyyikal-ladhi arsalt.",
            category: .sleep,
            source: "Al-Bukhari & Muslim",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "بِاسْمِكَ اللَّهُمَّ وَضَعْتُ جَنْبِي وَبِكَ أَرْفَعُهُ، فَإِنْ أَمْسَكْتَ نَفْسِي فَارْحَمْهَا، وَإِنْ أَرْسَلْتَهَا فَاحْفَظْهَا بِمَا تَحْفَظُ بِهِ عِبَادَكَ الصَّالِحِينَ",
            textEnglish: "In Your name, O Allah, I lay my side down and by You I raise it. If You take my soul then have mercy on it, and if You release it then protect it with that which You protect Your righteous servants.",
            transliteration: "Bismika Allahumma wada'tu janbi wa bika arfa'uh. Fa-in amsakta nafsi farhamha, wa in arsaltaha fahfazha bima tahfazu bihi ibadakas-salihin.",
            category: .sleep,
            source: "Al-Bukhari & Muslim",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَكَفَانَا وَآوَانَا فَكَمْ مِمَّنْ لاَ كَافِيَ لَهُ وَلاَ مُؤْوِي",
            textEnglish: "All praise is for Allah who has fed us, given us drink, sufficed us and given us shelter. For how many are those who have none to suffice them or give them shelter.",
            transliteration: "Alhamdu lillahil-ladhi at'amana wa saqana wa kafana wa awana, fakam mimman la kafiya lahu wa la mu'wi.",
            category: .sleep,
            source: "Muslim",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "اللَّهُمَّ خَلَقْتَ نَفْسِي وَأَنْتَ تَوَفَّاهَا، لَكَ مَمَاتُهَا وَمَحْيَاهَا، إِنْ أَحْيَيْتَهَا فَاحْفَظْهَا وَإِنْ أَمَتَّهَا فَاغْفِرْ لَهَا، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ",
            textEnglish: "O Allah, You have created my soul and You will take it. To You belongs its death and its life. If You give it life then protect it, and if You cause it to die then forgive it. O Allah, I ask You for well-being.",
            transliteration: "Allahumma khalaqta nafsi wa Anta tawaffaha, laka mamatuha wa mahyaha. In ahyaytaha fahfazha, wa in amattaha faghfir laha. Allahumma inni as'alukal-afiyah.",
            category: .sleep,
            source: "Muslim",
            repeatCount: 1
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
        Doaa(
            textArabic: "أَعُوذُ بِاللهِ وَكَلِمَاتِهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
            textEnglish: "I seek refuge in Allah and His perfect words from the evil of what He has created.",
            transliteration: "A'udhu billahi wa kalimatihit-tammati min sharri ma khalaq.",
            category: .protection,
            source: "Muslim",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "اللَّهُ لاَ إِلَٰهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ، لاَ تَأْخُذُهُ سِنَةٌ وَلاَ نَوْمٌ، لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الأَرْضِ، مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلاَّ بِإِذْنِهِ، يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ، وَلاَ يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلاَّ بِمَا شَاءَ، وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالأَرْضَ، وَلاَ يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ",
            textEnglish: "Allah—there is no deity except Him, the Ever-Living, the Sustainer. Neither drowsiness nor sleep overtakes Him. To Him belongs whatever is in the heavens and whatever is on the earth. Who is it that can intercede with Him except by His permission? He knows what is before them and what is behind them, and they encompass nothing of His knowledge except what He wills. His Kursi extends over the heavens and the earth, and their preservation tires Him not. And He is the Most High, the Most Great.",
            transliteration: "Allahu la ilaha illa Huwal-Hayyul-Qayyum. La ta'khudhuhu sinatun wa la nawm. Lahu ma fis-samawati wa ma fil-ard. Man dhal-ladhi yashfa'u indahu illa bi-idhnih. Ya'lamu ma bayna aydayhim wa ma khalfahum. Wa la yuhituna bishay'in min ilmihi illa bima sha'. Wasi'a kursiyyuhus-samawati wal-ard. Wa la ya'uduhu hifzuhuma wa Huwal-Aliyyul-Azim.",
            category: .protection,
            source: "Quran 2:255 - Ayatul Kursi",
            repeatCount: 1
        ),
        Doaa(
            textArabic: "قُلْ هُوَ اللَّهُ أَحَدٌ، اللَّهُ الصَّمَدُ، لَمْ يَلِدْ وَلَمْ يُولَدْ، وَلَمْ يَكُنْ لَهُ كُفُواً أَحَدٌ",
            textEnglish: "Say: He is Allah, the One. Allah, the Self-Sufficient. He begets not nor was He begotten. And there is none comparable to Him.",
            transliteration: "Qul Huwallahu Ahad. Allahus-Samad. Lam yalid wa lam yulad. Wa lam yakun lahu kufuwan ahad.",
            category: .protection,
            source: "Quran 112",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ، مِنْ شَرِّ مَا خَلَقَ",
            textEnglish: "Say: I seek refuge in the Lord of the daybreak, from the evil of what He has created.",
            transliteration: "Qul A'udhu bi Rabbil-falaq. Min sharri ma khalaq.",
            category: .protection,
            source: "Quran 113",
            repeatCount: 3
        ),
        Doaa(
            textArabic: "قُلْ أَعُوذُ بِرَبِّ النَّاسِ، مَلِكِ النَّاسِ، إِلَٰهِ النَّاسِ، مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ",
            textEnglish: "Say: I seek refuge in the Lord of mankind, the Sovereign of mankind, the God of mankind, from the evil of the retreating whisperer.",
            transliteration: "Qul A'udhu bi Rabbin-nas. Malikin-nas. Ilahin-nas. Min sharil-waswasil-khannas.",
            category: .protection,
            source: "Quran 114",
            repeatCount: 3
        ),
    ]
}
