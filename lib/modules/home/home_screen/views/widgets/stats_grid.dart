import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managementme/core/constants/app_colors.dart';

class StatsGridView extends StatelessWidget {
  final List<Map<String, dynamic>> stats;

  const StatsGridView({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<AppColors>()!;
    final textColor = customColors.statTextColor;

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.75,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Container(
          decoration: BoxDecoration(
            color: stat['color'] as Color?,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  stat['title'].toString(),
                  style: GoogleFonts.beVietnamPro(
                    color: textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Text(
                  stat['count'].toString(),
                  style: GoogleFonts.beVietnamPro(
                    color: textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
