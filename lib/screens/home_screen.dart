import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_style.dart';
import '../widgets/ads_card.dart';
import '../widgets/learned_today_card.dart';
import '../widgets/learning_plan_card.dart';
import 'course_overview_screen.dart';

/// ECRANUL 1 - "Home" (frame-ul 3:1402 din Figma, varianta 4).
///
/// Ecranul este dinamic (StatefulWidget) pentru ca slider-ul cu casete
/// isi schimba pagina curenta atunci cand utilizatorul gliseaza.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String route = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- Dimensiunile din design (latimea artboard-ului Figma este 375 px) ---
  static const double _pagePad = 20; // marginea laterala a continutului
  static const double _designContent = 335; // 375 - 2 * 20
  static const double _designCardW = 249; // latimea unei casete din slider
  static const double _designGap = 12; // spatiul dintre casete
  static const double _adsHeight = 154; // inaltimea casetelor din slider

  // --- Starea slider-ului de casete ---
  PageController? _adsController;
  double _adsFraction = 0;
  int _adsPage = 0;

  // --- Datele afisate pe ecran ---
  final int _learnedMinutes = 46;
  final int _goalMinutes = 60;
  final List<PlanItem> _plan = const [
    PlanItem(title: 'Packaging Design', done: 40, total: 48),
    PlanItem(title: 'Product Design', done: 6, total: 24),
  ];

  /// Dimensiunile slider-ului, calculate proportional cu latimea ecranului,
  /// ca sa pastram exact proportiile din Figma (249 + 12 dintr-un artboard
  /// de 375 px, adica din 355 px vizibili).
  ///
  /// La primul frame Android poate raporta inca 0x0, de aceea latimea este
  /// limitata inferior: altfel ar rezulta un `padding` negativ si aplicatia
  /// ar arunca exceptie in `PageView`.
  ({double cardW, double gap, double fraction}) _adsMetrics(double rawWidth) {
    final double screenW = rawWidth < 2 * _pagePad + 1 ? 375 : rawWidth;
    final double contentW = screenW - 2 * _pagePad;
    final double cardW = contentW * _designCardW / _designContent;
    final double gap = contentW * _designGap / _designContent;
    final double fraction =
        ((cardW + gap) / (screenW - _pagePad)).clamp(0.1, 1.0);
    return (cardW: cardW, gap: gap, fraction: fraction);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final double fraction =
        _adsMetrics(MediaQuery.of(context).size.width).fraction;

    if (_adsController == null || (fraction - _adsFraction).abs() > 0.001) {
      _adsController?.dispose();
      _adsFraction = fraction;
      _adsController = PageController(viewportFraction: fraction);
    }
  }

  @override
  void dispose() {
    _adsController?.dispose();
    super.dispose();
  }

  /// Navigheaza spre ecranul al doilea (Course Overview).
  void _openCourse() {
    Navigator.of(context).pushNamed(CourseOverviewScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);
    final metrics = _adsMetrics(mq.size.width);
    final double cardW = metrics.cardW;
    final double gap = metrics.gap;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Iconitele barei de status sunt albe peste header-ul albastru
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // ---------- Fundalul albastru al header-ului (375 x 183) ----------
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: mq.padding.top + 139, // 183 - 44 (bara de status) = 139
              child: const ColoredBox(color: AppColors.blue),
            ),

            SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ================= HEADER: salut + avatar =================
                    SizedBox(
                      height: 93, // de la y=44 la y=137 in design
                      child: Stack(
                        children: [
                          const Positioned(
                            left: _pagePad,
                            top: 17,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi, Kristin',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Let’s start learning',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 21, // x=318..354 pe artboard-ul de 375 px
                            top: 7,
                            child: Image.asset(
                              'assets/images/avatar.png',
                              width: 36,
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ========== CARD: "Learned today" + bara de progres ==========
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: _pagePad),
                      child: LearnedTodayCard(
                        minutes: _learnedMinutes,
                        goalMinutes: _goalMinutes,
                        onMyCourses: _openCourse,
                      ),
                    ),

                    const SizedBox(height: 17),

                    // ================= SLIDER-UL DE CASETE (ads) =================
                    SizedBox(
                      height: _adsHeight,
                      child: PageView(
                        controller: _adsController,
                        padEnds: false,
                        onPageChanged: (i) => setState(() => _adsPage = i),
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: _pagePad, right: gap),
                            child: AdsCard.promo(
                              width: cardW,
                              onGetStarted: _openCourse,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: gap),
                            child: AdsCard.image(
                              width: cardW,
                              asset: 'assets/images/ads_2.png',
                              onTap: _openCourse,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ================= SECTIUNEA "Learning Plan" =================
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: _pagePad),
                      child: Text(
                        'Learning Plan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: _pagePad),
                      child: LearningPlanCard(items: _plan, onTap: _openCourse),
                    ),

                    const SizedBox(height: 14),

                    // ===================== CARDUL "Meetup" =====================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: _pagePad),
                      child: GestureDetector(
                        onTap: _openCourse,
                        child: Container(
                          height: 120,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            boxShadow: [AppShadows.card],
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                            child: Image.asset(
                              'assets/images/meetup.png',
                              fit: BoxFit.cover,
                              alignment: Alignment.centerLeft,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Punctele slider-ului (ajutor vizual, in afara zonei din Figma)
                    const SizedBox(height: 24),
                    _AdsDots(count: 2, current: _adsPage),
                    SizedBox(height: 24 + mq.padding.bottom),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Punctele care arata la ce caseta din slider ne aflam.
class _AdsDots extends StatelessWidget {
  const _AdsDots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final bool active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? AppColors.blue : AppColors.greyLight,
            borderRadius: const BorderRadius.all(Radius.circular(3)),
          ),
        );
      }),
    );
  }
}
