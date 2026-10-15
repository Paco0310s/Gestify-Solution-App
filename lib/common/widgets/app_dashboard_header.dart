import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestify_solution/business/features/businesses/businesses_provider.dart';
import 'package:gestify_solution/business/features/sign_in/sign_in_service.dart';
import 'package:gestify_solution/common/constants/app_colors.dart';
import 'package:gestify_solution/common/constants/app_config.dart';
import 'package:gestify_solution/common/routes/routes.dart';
import 'package:gestify_solution/common/services/navigation_service.dart';
import 'package:gestify_solution/common/services/storage_service.dart';
import 'package:gestify_solution/common/widgets/app_text.dart';
import 'package:gestify_solution/common/widgets/responsive.dart';

class AppDashboardHeader extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showSearch;
  final bool showNotifications;
  final bool showUserProfile;

  const AppDashboardHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.showSearch = true,
    this.showNotifications = true,
    this.showUserProfile = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);

    // Resolve user display name and initials
    final rawUsername = StorageService.getUsername() ?? 'Usuario';
    final displayName = rawUsername.isNotEmpty
        ? rawUsername[0].toUpperCase() + rawUsername.substring(1)
        : 'Usuario';
    final initialLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';
    final email = StorageService.getString(AppConfig.emailKey) ??
        (rawUsername.contains('@') ? rawUsername : '$rawUsername@gestify.com');

    // Selected business (if any)
    final selectedBusiness = ref.watch(selectedBusinessProvider);

    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: AppColors.kWhiteColor,
        border: Border(
          bottom: BorderSide(color: AppColors.kNeutral200, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20),
      child: Row(
        children: [
          // Left side: Drawer trigger or custom leading or icon
          if (leading != null)
            leading!
          else if (!isDesktop) ...[
            Builder(
              builder: (ctx) {
                return Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: AppColors.kNeutral50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.kNeutral200),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.menu_rounded, color: AppColors.kDark1, size: 22),
                    tooltip: 'Menú',
                    onPressed: () {
                      final scaffoldState = Scaffold.maybeOf(ctx);
                      if (scaffoldState != null && scaffoldState.hasDrawer) {
                        scaffoldState.openDrawer();
                      }
                    },
                  ),
                );
              },
            ),
          ],

          // Title & icon badge
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.kPrimary100, AppColors.kPrimary50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.kPrimary200.withValues(alpha: 0.6)),
            ),
            child: const Icon(
              Icons.dashboard_customize_outlined,
              size: 18,
              color: AppColors.kPrimary800,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                fontSize: isMobile ? 15 : 17,
                fontWeight: FontWeight.bold,
                color: AppColors.kDark1,
              ),
              AppText(
                subtitle ?? 'Gestify Solution',
                fontSize: 11,
                color: AppColors.kNeutral500,
              ),
            ],
          ),

          // Center: Quick search bar on desktop
          if (isDesktop && showSearch)
            Expanded(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 380),
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.kNeutral50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.kNeutral200),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, size: 18, color: AppColors.kNeutral400),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Buscar empresas, reportes...',
                          style: TextStyle(color: AppColors.kNeutral400, fontSize: 13),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.kNeutral200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '⌘K',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.kNeutral600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            const Spacer(),

          // Right side actions
          ...?actions,

          // Active business pill (if selected on desktop/tablet)
          if (!isMobile && selectedBusiness != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.kPrimary50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.kPrimary200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.storefront_outlined, size: 14, color: AppColors.kPrimary800),
                  const SizedBox(width: 6),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Text(
                      selectedBusiness.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.kPrimary800,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],

          // Notifications bell
          if (showNotifications) ...[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.kNeutral50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.kNeutral200),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.notifications_none_rounded, size: 20, color: AppColors.kDark2),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.kPrimary600,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],

          // Divider before profile
          if (!isMobile)
            Container(
              height: 28,
              width: 1,
              color: AppColors.kNeutral200,
              margin: const EdgeInsets.symmetric(horizontal: 6),
            ),

          // User Profile Dropdown
          if (showUserProfile)
            DropdownButton2<String>(
              underline: const SizedBox.shrink(),
              customButton: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.kNeutral50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.kNeutral200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.kPrimary800, AppColors.kPrimary500],
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
                    if (!isMobile) ...[
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: AppColors.kDark1,
                            ),
                          ),
                          const Text(
                            'Propietario',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.kPrimary700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: AppColors.kNeutral500,
                      ),
                    ],
                  ],
                ),
              ),
              items: [
                DropdownItem(
                  value: 'header',
                  enabled: false,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.kDark1,
                          ),
                        ),
                        Text(
                          email,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.kNeutral500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const DropdownItem(value: 'divider_1', enabled: false, child: Divider(height: 1)),
                DropdownItem(
                  value: 'businesses',
                  child: Row(
                    children: const [
                      Icon(Icons.business_outlined, size: 18, color: AppColors.kDark2),
                      SizedBox(width: 10),
                      Text('Mis Empresas', style: TextStyle(fontSize: 13, color: AppColors.kDark2)),
                    ],
                  ),
                ),
                DropdownItem(
                  value: 'dashboard',
                  child: Row(
                    children: const [
                      Icon(Icons.dashboard_outlined, size: 18, color: AppColors.kDark2),
                      SizedBox(width: 10),
                      Text('Dashboard', style: TextStyle(fontSize: 13, color: AppColors.kDark2)),
                    ],
                  ),
                ),
                const DropdownItem(value: 'divider_2', enabled: false, child: Divider(height: 1)),
                DropdownItem(
                  value: 'logout',
                  child: Row(
                    children: const [
                      Icon(Icons.logout_rounded, size: 18, color: AppColors.kError),
                      SizedBox(width: 10),
                      Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.kError,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              onChanged: (value) async {
                if (value == 'logout') {
                  await SignInService.performLogout(context);
                } else if (value == 'businesses') {
                  NavigationService.replaceWith(context, Routes.businesses);
                } else if (value == 'dashboard') {
                  NavigationService.replaceWith(context, Routes.dashboard);
                }
              },
              dropdownStyleData: DropdownStyleData(
                width: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: AppColors.kNeutral200),
                ),
                offset: const Offset(0, 8),
              ),
              menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 14)),
            ),
        ],
      ),
    );
  }
}
