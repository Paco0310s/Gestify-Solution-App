import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:gestify_solution/common/constants/app_assets.dart';
import 'package:gestify_solution/common/constants/app_colors.dart';
import 'package:gestify_solution/common/constants/app_texts.dart';
import 'package:gestify_solution/common/features/side_menu/app_side_menu_provider.dart';
import 'package:gestify_solution/common/models/files/adapted_file.dart';
import 'package:gestify_solution/common/services/navigation_service.dart';
import 'package:gestify_solution/common/widgets/app_image.dart';
import 'package:gestify_solution/common/widgets/app_text.dart';
import 'package:gestify_solution/common/widgets/responsive.dart';

class AppSideMenu extends ConsumerWidget implements PreferredSizeWidget {
  const AppSideMenu({super.key});

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Duration durationOnExpandAndCollapse = ref.watch(durationOnExpandAndCollapseProvider);
    final Duration delayOnMenuItemAnimation = ref.watch(delayOnMenuItemAnimationProvider);
    final Duration durationOnMenuItemAnimation = ref.watch(durationOnMenuItemAnimationProvider);
    final bool isExpanded = ref.watch(isExpandedSideMenuProvider);
    final List<AppSideMenuModel> sideMenuItems = ref.watch(sideMenuItemsProvider);

    return AnimatedContainer(
      duration: durationOnExpandAndCollapse,
      width: isExpanded ? 250 : 70,
      child: Drawer(
        backgroundColor: AppColors.kPrimary800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) {
                      if (Responsive.isDesktop(context)) {
                        return IconButton(
                          onPressed: () {
                            ref.read(isExpandedSideMenuProvider.notifier).toggle();
                          },
                          icon: Icon(Icons.menu, color: AppColors.kNeutral100),
                        );
                      }
                      return SizedBox(height: 25);
                    },
                  ),
                  Builder(
                    builder: (context) {
                      if (!isExpanded) {
                        return Expanded(
                          child: Center(
                            child: FadeInRight(
                              delay: delayOnMenuItemAnimation,
                              duration: durationOnMenuItemAnimation,
                              child: AppImage(AdaptedFile.asset(AppAssets.logo), height: 50, width: 50),
                            ),
                          ),
                        );
                      }

                      return Expanded(
                        child: Center(
                          child: FadeInLeft(
                            delay: delayOnMenuItemAnimation,
                            duration: durationOnMenuItemAnimation,
                            child: Column(
                              children: [
                                AppImage(AdaptedFile.asset(AppAssets.logo), height: 50, width: 50),
                                Flexible(
                                  child: AppText(AppTexts.home, color: AppColors.kNeutral100, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            ...sideMenuItems.map((menu) {
              return DrawerMenuItem(
                key: ValueKey(menu.id),
                menu: menu,
                onTap: () {
                  NavigationService.replaceWith(context, menu.route);

                  ref.read(selectedSideMenuItemProvider.notifier).select(menu.id);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class DrawerMenuItem extends ConsumerWidget {
  final AppSideMenuModel menu;
  final VoidCallback onTap;

  const DrawerMenuItem({super.key, required this.menu, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(isExpandedSideMenuProvider);
    final delayOnMenuItemAnimation = ref.watch(delayOnMenuItemAnimationProvider);
    final durationOnMenuItemAnimation = ref.watch(durationOnMenuItemAnimationProvider);
    final selectedMenuId = ref.watch(selectedSideMenuItemProvider);
    final isSelected = selectedMenuId == (ref.read(sideMenuItemsProvider).firstWhere((item) => item.title == menu.title).id);
    // final isSubMenuSelected = menu.subItems.any((subItem) => subItem.id == selectedMenuId);
    final isSubMenuSelected = false;

    return Builder(
      builder: (context) {
        if (!isExpanded && menu.subItems.isEmpty) {
          return FadeInRight(
            delay: delayOnMenuItemAnimation,
            duration: durationOnMenuItemAnimation,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTap,
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                decoration: BoxDecoration(color: isSelected ? AppColors.kNeutral100 : null, borderRadius: BorderRadius.circular(10)),
                child: Icon(menu.icon, color: isSelected ? AppColors.kPrimary800 : AppColors.kNeutral100),
              ),
            ),
          );
        }

        if (!isExpanded) {
          return FadeInRight(
            delay: delayOnMenuItemAnimation,
            duration: durationOnMenuItemAnimation,
            child: ExpansionTile(
              controller: menu.controller,
              tilePadding: EdgeInsets.only(right: 10, top: 0, bottom: 0, left: 0),
              backgroundColor: AppColors.kPrimary600,
              iconColor: AppColors.kNeutral100,
              collapsedIconColor: AppColors.kNeutral100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                decoration: BoxDecoration(color: isSubMenuSelected ? AppColors.kNeutral100 : null, borderRadius: BorderRadius.circular(10)),
                child: Icon(menu.icon, color: isSubMenuSelected ? AppColors.kPrimary800 : AppColors.kNeutral100),
              ),
              children: [
                const SizedBox(height: 5),
                ListView.builder(
                  itemBuilder: (context, index) {
                    final subMenu = menu.subItems[index];
                    final isSubMenuSelected = selectedMenuId == subMenu.id;

                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          NavigationService.replaceWith(context, subMenu.route);

                          ref.read(selectedSideMenuItemProvider.notifier).select(subMenu.id);
                        },
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          decoration: BoxDecoration(color: isSubMenuSelected ? AppColors.kNeutral100 : null, borderRadius: BorderRadius.circular(10)),
                          child: Icon(subMenu.icon, color: isSubMenuSelected ? AppColors.kPrimary800 : AppColors.kNeutral100),
                        ),
                      ),
                    );
                  },
                  itemCount: menu.subItems.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ],
            ),
          );
        }

        if (menu.subItems.isEmpty) {
          return FadeInLeft(
            delay: delayOnMenuItemAnimation,
            duration: durationOnMenuItemAnimation,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTap,
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                decoration: BoxDecoration(color: isSelected ? AppColors.kNeutral100 : null, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Icon(menu.icon, color: isSelected ? AppColors.kPrimary800 : AppColors.kNeutral100),
                    const SizedBox(width: 5),
                    Expanded(child: AppText(menu.title, color: isSelected ? AppColors.kPrimary800 : AppColors.kNeutral100, fontSize: 16)),
                  ],
                ),
              ),
            ),
          );
        }

        return FadeInLeft(
          delay: delayOnMenuItemAnimation,
          duration: durationOnMenuItemAnimation,
          child: ExpansionTile(
            controller: menu.controller,
            tilePadding: EdgeInsets.only(right: 10, top: 0, bottom: 0, left: 0),
            backgroundColor: AppColors.kPrimary600,
            iconColor: AppColors.kNeutral100,
            collapsedIconColor: AppColors.kNeutral100,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              decoration: BoxDecoration(color: isSubMenuSelected ? AppColors.kNeutral100 : null, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Icon(menu.icon, color: isSubMenuSelected ? AppColors.kPrimary800 : AppColors.kNeutral100),
                  const SizedBox(width: 5),
                  Expanded(child: AppText(menu.title, color: isSubMenuSelected ? AppColors.kPrimary800 : AppColors.kNeutral100, fontSize: 16)),
                ],
              ),
            ),
            children: [
              const SizedBox(height: 5),
              ListView.builder(
                itemBuilder: (context, index) {
                  final subMenu = menu.subItems[index];
                  final isSubMenuSelected = selectedMenuId == subMenu.id;

                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        NavigationService.replaceWith(context, subMenu.route);

                        ref.read(selectedSideMenuItemProvider.notifier).select(subMenu.id);
                      },
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        decoration: BoxDecoration(color: isSubMenuSelected ? AppColors.kNeutral100 : null, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Icon(Icons.circle, size: 8, color: isSubMenuSelected ? AppColors.kPrimary800 : AppColors.kNeutral100),
                            const SizedBox(width: 10),
                            Icon(subMenu.icon, size: 18, color: isSubMenuSelected ? AppColors.kPrimary800 : AppColors.kNeutral100),
                            const SizedBox(width: 5),
                            Expanded(child: AppText(subMenu.title, color: isSubMenuSelected ? AppColors.kPrimary800 : AppColors.kNeutral100, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: menu.subItems.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ],
          ),
        );
      },
    );
  }
}
