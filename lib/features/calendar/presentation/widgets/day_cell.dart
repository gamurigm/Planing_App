import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Reusable calendar day cell with hover and pressed states for desktop.
class DayCell extends StatefulWidget {
  final double width;
  final double height;
  final String content;
  final VoidCallback? onTap;
  final Color Function(String content)? colorForContent;

  const DayCell({
    Key? key,
    required this.width,
    required this.height,
    required this.content,
    this.onTap,
    this.colorForContent,
  }) : super(key: key);

  @override
  State<DayCell> createState() => _DayCellState();
}

class _DayCellState extends State<DayCell> {
  bool _hovering = false;
  bool _pressed = false;

  void _setPressed(bool value) {
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    // Default background is white for clarity. Use colorForContent as accent color.
    final accent = widget.colorForContent?.call(widget.content) ?? AppColors.primary;
    final baseColor = AppColors.cellDefault; // white by default

    Color bg = baseColor;
    Color textColor = widget.content.isNotEmpty ? accent : Colors.grey.shade600;

    // If the cell already has content, fill it fully with the accent color
    // (user requested 'colores full'). Empty cells remain white.
    if (widget.content.isNotEmpty) {
      bg = accent;
      textColor = Colors.white;
    }

    // Prepare neon border and glow for hover/pressed states.
    List<BoxShadow>? shadows;
    Border? neonBorder;

    if (_pressed) {
      // stronger neon border + glow
      neonBorder = Border.all(color: AppColors.neonTurquoise, width: 2.4);
      shadows = [
        BoxShadow(
          color: AppColors.neonTurquoiseShadow,
          blurRadius: 10,
          spreadRadius: 0.8,
          offset: const Offset(0, 2),
        ),
      ];
    } else if (_hovering) {
      // hover: neon border and subtle glow
      neonBorder = Border.all(color: AppColors.neonTurquoise, width: 1.8);
      shadows = [
        BoxShadow(
          color: AppColors.neonTurquoiseShadow,
          blurRadius: 6,
          spreadRadius: 0.4,
          offset: const Offset(0, 1),
        ),
      ];
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() {
        _hovering = false;
        _pressed = false;
      }),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
            decoration: BoxDecoration(
            color: bg,
            border: neonBorder ?? Border(
                left: BorderSide(color: AppColors.subtleGrid, width: 0.5),
                right: BorderSide(color: AppColors.subtleGrid, width: 0.5),
                bottom: BorderSide(color: AppColors.subtleGrid, width: 0.5),
              ),
            boxShadow: shadows,
          ),
          child: Center(
            child: Text(
              widget.content,
              style: TextStyle(
                fontSize: 10,
                fontWeight: widget.content.isNotEmpty ? FontWeight.bold : FontWeight.normal,
                color: textColor,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ),
    );
  }
}
