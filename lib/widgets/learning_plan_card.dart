import 'package:flutter/material.dart';

import '../theme/app_style.dart';

/// O linie din planul de invatare: titlul cursului si lectiile parcurse.
class PlanItem {
  const PlanItem({
    required this.title,
    required this.done,
    required this.total,
  });

  final String title;
  final int done;
  final int total;

  double get progress => total == 0 ? 0 : (done / total).clamp(0.0, 1.0);
}

/// Cardul alb "Learning Plan" de pe prima pagina (nodul 3:1560 din Figma).
///
/// In design: 335 x 133, colturi rotunjite 12, aceeasi umbra ca la cardul de sus.
class LearningPlanCard extends StatelessWidget {
  const LearningPlanCard({super.key, required this.items, this.onTap});

  final List<PlanItem> items;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 133,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [AppShadows.card],
      ),
      // 14.5 la stanga pentru ca inelul de progres are conturul de 3 px
      // desenat in afara patratului de 18 px din design.
      padding: const EdgeInsets.only(left: 14.5, right: 16, top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(height: 17),
            _PlanRow(item: items[i], onTap: onTap),
          ],
        ],
      ),
    );
  }
}

/// Un rand: inel de progres + denumirea cursului + "40/48".
class _PlanRow extends StatelessWidget {
  const _PlanRow({required this.item, this.onTap});

  final PlanItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 21,
        child: Row(
          children: [
            // Inelul de progres (18 px diametru, contur de 3 px)
            SizedBox(
              width: 21,
              height: 21,
              child: CircularProgressIndicator(
                value: item.progress,
                strokeWidth: 3,
                backgroundColor: AppColors.trackGrey,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.ringValue,
                ),
              ),
            ),
            const SizedBox(width: 11.5),
            Expanded(
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  color: AppColors.ink,
                ),
              ),
            ),
            // "40" inchis + "/48" gri deschis
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '${item.done}'),
                  TextSpan(
                    text: '/${item.total}',
                    style: const TextStyle(color: AppColors.greyLight),
                  ),
                ],
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
