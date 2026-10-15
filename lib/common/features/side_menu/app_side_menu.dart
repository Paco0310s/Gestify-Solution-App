import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestify_solution/business/features/sign_in/sign_in_service.dart';
import 'package:gestify_solution/common/constants/app_assets.dart';
import 'package:gestify_solution/common/constants/app_colors.dart';
import 'package:gestify_solution/common/constants/app_config.dart';
import 'package:gestify_solution/common/features/side_menu/app_side_menu_provider.dart';
import 'package:gestify_solution/common/models/files/adapted_file.dart';
import 'package:gestify_solution/common/services/navigation_service.dart';
import 'package:gestify_solution/common/services/storage_service.dart';
import 'package:gestify_solution/common/widgets/app_image.dart';
import 'package:gestify_solution/common/widgets/responsive.dart';

class AppSideMenu extends ConsumerWidget implements PreferredSizeWidget {
  const AppSideMenu({super.key});

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Duration durationOnExpandAndCollapse = ref.watch(durationOnExpandAndCollapseProvider);
    final bool isExpanded = ref.watch(isExpandedSideMenuProvider);
    final List<AppSideMenuModel> sideMenuItems = ref.watch(sideMenuItemsProvider);
    final isDesktop = Responsive.isDesktop(context);

    // Resolve user data for bottom profile card
    final rawUsername = StorageService.getUsername() ?? 'Usuario';
    final displayName = rawUsername.isNotEmpty
        ? rawUsername[0].toUpperCase() + rawUsername.substring(1)
        : 'Usuario';
    final initialLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';
    final email = StorageService.getString(AppConfig.emailKey) ??
        (rawUsername.contains('@') ? rawUsername : '$rawUsername@gestify.com');

    return AnimatedContainer(
      duration: durationOnExpandAndCollapse,
      width: isExpanded ? 260 : 76,
      child: Drawer(
        elevation: 0,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff120D26), Color(0xff0D091F)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border(
              right: BorderSide(color: Color(0xff1E173E), width: 1),
            ),
          ),
          child: Column(
            children: [
              // Brand Header
              _buildBrandHeader(context, ref, isExpanded, isDesktop),

              // Navigation List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: [
                    if (isExpanded)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          'MENÚ PRINCIPAL',
                          style: TextStyle(
                            color: Color(0xff7E7599),
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ...sideMenuItems.map((menu) {
                      return DrawerMenuItem(
                        key: ValueKey(menu.id),
                        menu: menu,
                        onTap: () {
                          // Close drawer if open on mobile/tablet
                          final scaffoldState = Scaffold.maybeOf(context);
                          if (scaffoldState != null && scaffoldState.isDrawerOpen) {
                            Navigator.of(context).pop();
                          }

                          NavigationService.replaceWith(context, menu.route);
                          ref.read(selectedSideMenuItemProvider.notifier).select(menu.id);
                        },
                      );
                    }),
                  ],
                ),
              ),

              // Bottom User Profile & Logout Section
              _buildBottomProfile(context, isExpanded, displayName, email, initialLetter),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandHeader(BuildContext context, WidgetRef ref, bool isExpanded, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isExpanded ? 16 : 10,
        vertical: 16,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xff1E173E), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: isExpanded ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo icon container
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.kPrimary700, AppColors.kPrimary500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kPrimary600.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: AppImage(AdaptedFile.asset(AppAssets.logo), fit: BoxFit.contain),
              ),
              if (isExpanded) ...[
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'GESTIFY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: AppColors.kPrimary500.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.kPrimary400.withValues(alpha: 0.5)),
                          ),
                          child: const Text(
                            'PRO',
                            style: TextStyle(
                              color: AppColors.kPrimary200,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Solution Platform',
                      style: TextStyle(
                        color: Color(0xff948BAF),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          // Toggle button on Desktop
          if (isDesktop && isExpanded)
            IconButton(
              icon: const Icon(Icons.menu_open_rounded, color: Color(0xff948BAF), size: 20),
              tooltip: 'Contraer menú',
              onPressed: () {
                ref.read(isExpandedSideMenuProvider.notifier).toggle();
              },
            ),
          if (isDesktop && !isExpanded)
            IconButton(
              icon: const Icon(Icons.menu_rounded, color: Color(0xff948BAF), size: 20),
              tooltip: 'Expandir menú',
              onPressed: () {
                ref.read(isExpandedSideMenuProvider.notifier).toggle();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBottomProfile(
    BuildContext context,
    bool isExpanded,
    String displayName,
    String email,
    String initialLetter,
  ) {
    return Container(
      padding: EdgeInsets.all(isExpanded ? 14 : 10),
      decoration: const BoxDecoration(
        color: Color(0xff0E0A22),
        border: Border(
          top: BorderSide(color: Color(0xff1E173E), width: 1),
        ),
      ),
      child: isExpanded
          ? Row(
              children: [
                // Avatar with green status dot
                Stack(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.kPrimary700, AppColors.kPrimary500],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initialLetter,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.kSuccess,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xff0E0A22), width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        'Propietario',
                        style: TextStyle(
                          color: AppColors.kPrimary300,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.power_settings_new_rounded, size: 20, color: Color(0xffEF4444)),
                  tooltip: 'Cerrar Sesión',
                  onPressed: () async {
                    await SignInService.performLogout(context);
                  },
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: displayName,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.kPrimary700, AppColors.kPrimary500],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initialLetter,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                IconButton(
                  icon: const Icon(Icons.logout_rounded, size: 18, color: Color(0xffEF4444)),
                  tooltip: 'Cerrar Sesión',
                  onPressed: () async {
                    await SignInService.performLogout(context);
                  },
                ),
              ],
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
    final sideMenuItems = ref.watch(sideMenuItemsProvider);

    final matchingItem = sideMenuItems.firstWhere(
      (item) => item.title == menu.title,
      orElse: () => menu,
    );
    final isSelected = selectedMenuId == matchingItem.id;
    final isSubMenuSelected = menu.subItems.any((subItem) => subItem.id == selectedMenuId);

    // Collapsed single menu item
    if (!isExpanded && menu.subItems.isEmpty) {
      return FadeInRight(
        delay: delayOnMenuItemAnimation,
        duration: durationOnMenuItemAnimation,
        child: Tooltip(
          message: menu.title,
          waitDuration: const Duration(milliseconds: 300),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              height: 46,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [AppColors.kPrimary700, AppColors.kPrimary500],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.kPrimary600.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                menu.icon,
                color: isSelected ? Colors.white : const Color(0xff948BAF),
                size: 22,
              ),
            ),
          ),
        ),
      );
    }

    // Collapsed expansion tile item
    if (!isExpanded) {
      return FadeInRight(
        delay: delayOnMenuItemAnimation,
        duration: durationOnMenuItemAnimation,
        child: Tooltip(
          message: menu.title,
          waitDuration: const Duration(milliseconds: 300),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              controller: menu.controller,
              tilePadding: EdgeInsets.zero,
              collapsedIconColor: const Color(0xff948BAF),
              iconColor: Colors.white,
              title: Container(
                height: 46,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  gradient: isSubMenuSelected
                      ? const LinearGradient(
                          colors: [AppColors.kPrimary700, AppColors.kPrimary500],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  menu.icon,
                  color: isSubMenuSelected ? Colors.white : const Color(0xff948BAF),
                  size: 22,
                ),
              ),
              children: [
                ...menu.subItems.map((subMenu) {
                  final isCurrentSubSelected = selectedMenuId == subMenu.id;
                  return Tooltip(
                    message: subMenu.title,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        final scaffoldState = Scaffold.maybeOf(context);
                        if (scaffoldState != null && scaffoldState.isDrawerOpen) {
                          Navigator.of(context).pop();
                        }
                        NavigationService.replaceWith(context, subMenu.route);
                        ref.read(selectedSideMenuItemProvider.notifier).select(subMenu.id);
                      },
                      child: Container(
                        height: 38,
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                          color: isCurrentSubSelected
                              ? AppColors.kPrimary500.withValues(alpha: 0.25)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          subMenu.icon,
                          size: 18,
                          color: isCurrentSubSelected ? AppColors.kPrimary300 : const Color(0xff7E7599),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      );
    }

    // Expanded single menu item
    if (menu.subItems.isEmpty) {
      return FadeInLeft(
        delay: delayOnMenuItemAnimation,
        duration: durationOnMenuItemAnimation,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            height: 46,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [AppColors.kPrimary700, AppColors.kPrimary500],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.kPrimary600.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  menu.icon,
                  color: isSelected ? Colors.white : const Color(0xff948BAF),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    menu.title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xffCBD5E1),
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    // Expanded expansion tile menu item
    return FadeInLeft(
      delay: delayOnMenuItemAnimation,
      duration: durationOnMenuItemAnimation,
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          controller: menu.controller,
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          collapsedIconColor: const Color(0xff948BAF),
          iconColor: Colors.white,
          title: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              gradient: isSubMenuSelected && !isSelected
                  ? LinearGradient(
                      colors: [
                        AppColors.kPrimary800.withValues(alpha: 0.4),
                        AppColors.kPrimary600.withValues(alpha: 0.2),
                      ],
                    )
                  : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  menu.icon,
                  color: isSubMenuSelected ? AppColors.kPrimary300 : const Color(0xff948BAF),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    menu.title,
                    style: TextStyle(
                      color: isSubMenuSelected ? Colors.white : const Color(0xffCBD5E1),
                      fontSize: 14,
                      fontWeight: isSubMenuSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          children: [
            ...menu.subItems.map((subMenu) {
              final isCurrentSubSelected = selectedMenuId == subMenu.id;
              return Padding(
                padding: const EdgeInsets.only(left: 28, right: 12, bottom: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    final scaffoldState = Scaffold.maybeOf(context);
                    if (scaffoldState != null && scaffoldState.isDrawerOpen) {
                      Navigator.of(context).pop();
                    }
                    NavigationService.replaceWith(context, subMenu.route);
                    ref.read(selectedSideMenuItemProvider.notifier).select(subMenu.id);
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isCurrentSubSelected
                          ? AppColors.kPrimary500.withValues(alpha: 0.25)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: isCurrentSubSelected
                          ? Border.all(color: AppColors.kPrimary400.withValues(alpha: 0.4))
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isCurrentSubSelected ? AppColors.kPrimary300 : const Color(0xff554C75),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          subMenu.icon,
                          size: 16,
                          color: isCurrentSubSelected ? Colors.white : const Color(0xff948BAF),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            subMenu.title,
                            style: TextStyle(
                              color: isCurrentSubSelected ? Colors.white : const Color(0xffB5ADC9),
                              fontSize: 13,
                              fontWeight: isCurrentSubSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
