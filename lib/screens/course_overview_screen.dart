import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_style.dart';
import '../widgets/lesson_row.dart';

/// ECRANUL 2 - "Course Overview" (frame-ul 1641:428 din Figma, varianta 4).
///
/// Se deschide atunci cand utilizatorul apasa pe un element de pe prima pagina.
class CourseOverviewScreen extends StatefulWidget {
  const CourseOverviewScreen({super.key});

  static const String route = '/course';

  @override
  State<CourseOverviewScreen> createState() => _CourseOverviewScreenState();
}

class _CourseOverviewScreenState extends State<CourseOverviewScreen> {
  // --- Marginile din design (latimea artboard-ului Figma este 393 px) ---
  static const double _padLeft = 36;
  static const double _padRight = 22;

  /// Tab-ul activ: 0 = Lessons, 1 = Description.
  int _tab = 0;

  /// Lectiile cursului, exact ca in design.
  static const List<Lesson> _lessons = [
    Lesson(title: 'Introduction to React', duration: '04:28 min'),
    Lesson(title: 'Understanding React', duration: '06:12 min'),
    Lesson(title: 'Create first React project', duration: '43:58 min'),
    Lesson(title: 'Build React', duration: '26:18 min'),
  ];

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);
    // Inaltimea barei de jos (gradient + butoane), ca sa nu acopere continutul
    final double bottomBarHeight = 41 + 48 + 16 + mq.padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Fundal deschis => iconitele barei de status sunt inchise la culoare
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.pageBg,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // ===================== CONTINUTUL DERULABIL =====================
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomBarHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 3),
                    _buildAppBar(),

                    const SizedBox(height: 44),

                    // -------- Imaginea cursului + butonul mare de "play" --------
                    Padding(
                      padding: const EdgeInsets.only(
                        left: _padLeft,
                        right: _padRight,
                      ),
                      child: AspectRatio(
                        aspectRatio: 335 / 207,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(14),
                              ),
                              child: Image.asset(
                                'assets/images/course_cover.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            _buildBigPlayButton(),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 34),

                    // -------------------- Titlul cursului --------------------
                    const Padding(
                      padding: EdgeInsets.only(
                        left: _padLeft,
                        right: _padRight,
                      ),
                      child: Text(
                        'React Front To back',
                        style: TextStyle(
                          fontFamily: kFontCourse,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.15,
                          color: AppColors.ink2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ------------- Durata, numarul de lectii, nota -------------
                    const Padding(
                      padding: EdgeInsets.only(
                        left: _padLeft,
                        right: _padRight,
                      ),
                      child: _MetaRow(),
                    ),

                    const SizedBox(height: 22),

                    // ------------------ Tab-urile + linia activa ------------------
                    _buildTabs(),

                    const SizedBox(height: 26),

                    // ------------------- Continutul tab-ului -------------------
                    ..._buildTabContent(),
                  ],
                ),
              ),

              // ============ BARA DE JOS: gradient + butoanele de actiune ============
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomBar(mq.padding.bottom),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Lista de widget-uri afisata sub tab-uri (lectii sau descriere).
  List<Widget> _buildTabContent() {
    if (_tab == 1) {
      return const [
        Padding(
          padding: EdgeInsets.only(left: _padLeft, right: _padRight),
          child: Text(
            'Invata React de la zero: componente, state, props, hooks si '
            'lucrul cu un backend. Cursul contine 7 lectii video, '
            'in total 6h 30min.',
            style: TextStyle(
              fontFamily: kFontCourse,
              fontSize: 16,
              height: 1.6,
              color: AppColors.duration,
            ),
          ),
        ),
      ];
    }

    final List<Widget> rows = [];
    for (int i = 0; i < _lessons.length; i++) {
      if (i > 0) rows.add(const SizedBox(height: 28));
      rows.add(
        Padding(
          // sageata din dreapta se opreste la x=361 in design (393 - 32)
          padding: const EdgeInsets.only(left: _padLeft, right: 32),
          child: LessonRow(
            lesson: _lessons[i],
            highlighted: i == 0,
            onTap: () {},
          ),
        ),
      );
    }
    return rows;
  }

  // --------------------------- Bara de sus ---------------------------
  Widget _buildAppBar() {
    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          // Sageata de intoarcere (cadru de 40x40 la x=11 in design)
          Positioned(
            left: 11,
            top: 0,
            width: 40,
            height: 40,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 21,
                color: Colors.black,
              ),
            ),
          ),
          // Titlul incepe la x=42 in design
          const Positioned(
            left: 42,
            top: 0,
            bottom: 0,
            child: Center(
              child: Text(
                'Course Overview',
                style: TextStyle(
                  fontFamily: kFontCourse,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ Butonul mare de "play" de pe imagine ------------------
  Widget _buildBigPlayButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 54,
        height: 54,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [AppShadows.bigPlay],
        ),
        child: const Icon(
          Icons.play_arrow_rounded,
          size: 30,
          color: AppColors.accent,
        ),
      ),
    );
  }

  // ------------------------ Tab-urile Lessons / Description ------------------------
  Widget _buildTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 21,
          child: Row(
            children: [
              const SizedBox(width: 113),
              _tabLabel('Lessons', 0),
              const SizedBox(width: 36),
              _tabLabel('Description', 1),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Linia portocalie de sub tab-ul activ (100 x 2 in design)
        SizedBox(
          height: 2,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                left: _tab == 0 ? 97 : 213.5,
                top: 0,
                child: Container(
                  width: 100,
                  height: 2,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.all(Radius.circular(1)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tabLabel(String text, int index) {
    return GestureDetector(
      onTap: () => setState(() => _tab = index),
      behavior: HitTestBehavior.opaque,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: kFontCourse,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.17,
          color: _tab == index ? AppColors.accent : AppColors.tabOff,
        ),
      ),
    );
  }

  // ------------------------ Bara de jos cu butoane ------------------------
  Widget _buildBottomBar(double safeBottom) {
    return Container(
      padding: EdgeInsets.only(
        left: _padLeft,
        right: _padRight,
        top: 41,
        bottom: 16 + safeBottom,
      ),
      decoration: const BoxDecoration(
        // Estompeaza lista de lectii pe sub butoane, exact ca in design
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xCEF9FBFF), AppColors.pageBg],
          stops: [0.05, 0.575],
        ),
      ),
      child: Row(
        children: [
          // Butonul "Free"
          Container(
            width: 70,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: const BorderRadius.all(Radius.circular(14)),
            ),
            child: const Text(
              'Free',
              style: TextStyle(
                fontFamily: kFontCourse,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Butonul "Enroll Now"
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                child: const Text(
                  'Enroll Now',
                  style: TextStyle(
                    fontFamily: kFontCourse,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Randul cu durata cursului, numarul de lectii si nota (4.9).
class _MetaRow extends StatelessWidget {
  const _MetaRow();

  @override
  Widget build(BuildContext context) {
    const TextStyle metaStyle = TextStyle(
      fontFamily: kFontCourse,
      fontSize: 14.28,
      height: 1.19,
      color: AppColors.meta,
    );

    return SizedBox(
      height: 24,
      child: Row(
        children: [
          const Icon(Icons.access_time_rounded, size: 14.28, color: AppColors.meta),
          const SizedBox(width: 4),
          const Text('6h 30min', style: metaStyle),
          const SizedBox(width: 8),
          Container(
            width: 2,
            height: 2,
            decoration: const BoxDecoration(
              color: AppColors.meta,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text('7 lessons', style: metaStyle),
          const Spacer(),
          // Eticheta cu nota
          Container(
            width: 54,
            height: 24,
            padding: const EdgeInsets.only(left: 6, right: 5),
            decoration: const BoxDecoration(
              color: AppColors.pillBg,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_rounded, size: 20, color: AppColors.star),
                SizedBox(width: 2),
                Flexible(
                  child: Text(
                    '4.9',
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontFamily: kFontCourse,
                      fontSize: 14.28,
                      fontWeight: FontWeight.w500,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
