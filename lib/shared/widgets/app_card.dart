import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:habi/config/theme/app_constants.dart';

/// A restrained Forui surface used by the first migrated screens.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppConstants.spacingLG),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return FCard.raw(
      child: Padding(padding: padding, child: child),
    );
  }
}
