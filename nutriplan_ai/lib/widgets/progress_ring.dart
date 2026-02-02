import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../theme/app_theme.dart';

class ProgressRing extends StatelessWidget {
  final double percent;
  final double radius;
  final double lineWidth;
  final String? centerText;
  final String? footerText;
  final Color? progressColor;
  final Color? backgroundColor;
  final Widget? centerWidget;

  const ProgressRing({
    super.key,
    required this.percent,
    this.radius = 80,
    this.lineWidth = 12,
    this.centerText,
    this.footerText,
    this.progressColor,
    this.backgroundColor,
    this.centerWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: radius,
      lineWidth: lineWidth,
      percent: percent.clamp(0.0, 1.0),
      center: centerWidget ??
          (centerText != null
              ? Text(
                  centerText!,
                  style: TextStyle(
                    fontSize: radius * 0.25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              : null),
      footer: footerText != null
          ? Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                footerText!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            )
          : null,
      progressColor: progressColor ?? AppTheme.primaryGreen,
      backgroundColor: backgroundColor ?? Colors.white12,
      circularStrokeCap: CircularStrokeCap.round,
      animation: true,
      animationDuration: 1000,
    );
  }
}
