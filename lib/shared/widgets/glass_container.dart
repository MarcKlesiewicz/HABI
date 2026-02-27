import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:habi/config/theme/theme_extensions.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  const GlassContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: context.radiusSM,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: context.radiusSM,
            border: Border.all(
              color: Color.fromRGBO(255, 255, 255, 0.2),
              width: 2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
