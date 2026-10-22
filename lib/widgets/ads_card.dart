import 'package:flutter/material.dart';

import '../theme/app_style.dart';

/// O caseta din slider-ul de pe prima pagina (nodul 3:1594 "ads" din Figma).
///
/// In design: 249 x 154, colturi rotunjite 16, fundal #CEECFE.
/// Exista doua variante:
///  * [AdsCard.promo]  - caseta cu text si butonul "Get Started";
///  * [AdsCard.image]  - caseta care contine doar ilustratia.
class AdsCard extends StatelessWidget {
  const AdsCard.promo({
    super.key,
    required this.width,
    VoidCallback? onGetStarted,
  })  : asset = 'assets/images/ads_1.png',
        isPromo = true,
        onTap = onGetStarted;

  const AdsCard.image({
    super.key,
    required this.width,
    required this.asset,
    this.onTap,
  }) : isPromo = false;

  /// Latimea casetei (calculata proportional cu latimea ecranului).
  final double width;

  /// Ilustratia exportata din Figma.
  final String asset;

  /// `true` pentru caseta cu text + buton.
  final bool isPromo;

  final VoidCallback? onTap;

  /// Inaltimea casetei, din design.
  static const double height = 154;

  /// Raza colturilor, din design.
  static const double radius = 16;

  /// Ilustratia primei casete depaseste cu ~4 px marginea din dreapta
  /// a fundalului (253.17 fata de 249 in Figma) si este taiata de card.
  static const double _promoOverflow = 760 / 462 * height - 249;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isPromo ? null : onTap,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(radius)),
        child: Container(
          width: width,
          height: height,
          color: AppColors.adsBlue,
          child: isPromo ? _buildPromo() : _buildImage(),
        ),
      ),
    );
  }

  // ---------- Caseta 1: text + buton peste ilustratie ----------
  Widget _buildPromo() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          right: -_promoOverflow,
          child: Image.asset(asset, fit: BoxFit.fitHeight),
        ),
        Positioned(
          left: 18,
          top: 19.5,
          // Textul ramane in jumatatea libera din stanga, peste fundal
          width: width * 0.63,
          child: const Text(
            'What do you want to learn today ?',
            maxLines: 2,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.5,
              color: AppColors.ink,
            ),
          ),
        ),
        Positioned(
          left: 18,
          top: 104.5,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: 85,
              height: 31,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------- Caseta 2: doar ilustratia ----------
  Widget _buildImage() {
    return Align(
      alignment: Alignment.center,
      child: Image.asset(asset, height: height, fit: BoxFit.fitHeight),
    );
  }
}
