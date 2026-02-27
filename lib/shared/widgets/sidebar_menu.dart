import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:habi/config/routes/routes.dart';
import 'package:habi/config/theme/theme_extensions.dart';
import 'package:habi/shared/widgets/glass_container.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: SizedBox(
        height: double.infinity,
        child: Column(
          children: [
            SvgPicture.asset('lib/assets/svg/habi_logo.svg', height: 50),
            const SizedBox(height: 32),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => context.go(AppRoutePath.dashboard),
                  icon: Icon(
                    Icons.dashboard,
                    color: context.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                IconButton(
                  onPressed: () => context.go(AppRoutePath.airbnb),
                  icon: Icon(Icons.home, color: context.colorScheme.secondary),
                ),
              ],
            ),
          ],
        ),
      ).paddingAll(8),
    );
  }
}
