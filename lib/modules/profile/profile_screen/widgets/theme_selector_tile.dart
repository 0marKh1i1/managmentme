import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managementme/core/constants/app_colors.dart';
import 'package:managementme/core/servicesAndControllers/theme_controller.dart';
import 'package:managementme/core/utils/contrast_color.dart';

class ThemeSelectorTile extends StatelessWidget {
  const ThemeSelectorTile({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final customColors = Theme.of(context).extension<AppColors>()!;
    final accent = customColors.statHighPriorityColor ?? cs.primary;
    final contrastIconColor = ContrastColor.getContrastBlackWhite(accent);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.palette_outlined,
                  color: contrastIconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'appearance'.tr,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  Text(
                    'choose_theme'.tr,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: cs.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          GetBuilder<ThemeController>(
            builder: (controller) => SegmentedButton<int>(
              expandedInsets: EdgeInsets.zero,
              segments: [
                ButtonSegment(
                  value: 1,
                  icon: Icon(Icons.light_mode_rounded, size: 17),
                  label: Text('light'.tr, style: TextStyle(fontSize: 12),),
                  tooltip: 'light'.tr,
                ),
                ButtonSegment(
                  value: 0,
                  icon: Icon(Icons.brightness_auto_rounded, size: 17),
                  label: Text('system'.tr, style: TextStyle(fontSize: 12),),
                  tooltip: 'system'.tr,
                ),
                ButtonSegment(
                  value: 2,
                  icon: Icon(Icons.dark_mode_rounded, size: 17),
                  label: Text('dark'.tr, style: TextStyle(fontSize: 12),),
                  tooltip: 'dark'.tr,
                ),
              ],
              selected: {controller.themeModeInt},
              onSelectionChanged: (Set<int> newSelection) async {
                await controller.setThemeModeInt(newSelection.first);
              },
              style: SegmentedButton.styleFrom(
              
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 38),
                selectedBackgroundColor: cs.primary,
                selectedForegroundColor: cs.onPrimary,
                foregroundColor: cs.onSurface.withValues(alpha: 0.6),
                side: BorderSide(
                  color: cs.outline.withValues(alpha: 0.3),
                ),
              ),
              showSelectedIcon: false,
            ),
          ),
        ],
      ),
    );
  }
}
