import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestify_solution/business/features/businesses/businesses_provider.dart';
import 'package:gestify_solution/business/features/businesses/models/business_model.dart';
import 'package:gestify_solution/common/constants/app_colors.dart';
import 'package:gestify_solution/common/features/side_menu/app_side_menu_provider.dart';
import 'package:gestify_solution/common/routes/routes.dart';
import 'package:gestify_solution/common/services/navigation_service.dart';
import 'package:gestify_solution/common/services/storage_service.dart';
import 'package:gestify_solution/common/widgets/app_dashboard_layout.dart';

class DashboardScreen extends ConsumerWidget {
  final String title;
  const DashboardScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppDashboardLayout(
      title: title,
      subtitle: 'Resumen y accesos rápidos de tu plataforma',
      mobileChild: const DashboardContent(isMobile: true),
      tabletChild: const DashboardContent(isTablet: true),
      desktopChild: const DashboardContent(isDesktop: true),
    );
  }
}

class DashboardContent extends ConsumerWidget {
  final bool isDesktop;
  final bool isTablet;
  final bool isMobile;

  const DashboardContent({
    super.key,
    this.isDesktop = false,
    this.isTablet = false,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rawUsername = StorageService.getUsername() ?? 'Usuario';
    final displayName = rawUsername.isNotEmpty
        ? rawUsername[0].toUpperCase() + rawUsername.substring(1)
        : 'Usuario';
    final businessesAsync = ref.watch(businessesListProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome Banner
          _buildWelcomeBanner(context, ref, displayName),
          const SizedBox(height: 20),

          // Metric Cards Row
          businessesAsync.when(
            data: (businesses) => _buildMetricsRow(context, businesses),
            loading: () => _buildMetricsSkeleton(),
            error: (error, stack) => _buildMetricsRow(context, []),
          ),
          const SizedBox(height: 24),

          // Quick Access & Recent Businesses Section
          businessesAsync.when(
            data: (businesses) => _buildRecentBusinessesSection(context, ref, businesses),
            loading: () => const SizedBox.shrink(),
            error: (error, stack) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context, WidgetRef ref, String name) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff1E1442), Color(0xff2A1668), AppColors.kPrimary600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimary800.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded, color: AppColors.kPrimary200, size: 14),
                      SizedBox(width: 6),
                      Text(
                        'Panel de Administración',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '¡Hola de nuevo, $name!',
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Gestiona tus empresas, configura razones sociales y supervisa operaciones desde este portal centralizado.',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 13.5,
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.kPrimary800,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed: () {
                        ref.read(selectedSideMenuItemProvider.notifier).selectByRoute(Routes.businesses);
                        NavigationService.replaceWith(context, Routes.businesses);
                      },
                      icon: const Icon(Icons.business_rounded, size: 18),
                      label: const Text('Ver Mis Empresas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed: () {
                        ref.read(selectedSideMenuItemProvider.notifier).selectByRoute(Routes.businessAdd);
                        NavigationService.replaceWith(context, Routes.businessAdd);
                      },
                      icon: const Icon(Icons.add_business_rounded, size: 18),
                      label: const Text('Nueva Empresa', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 24),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2),
              ),
              child: const Icon(
                Icons.analytics_outlined,
                size: 50,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricsRow(BuildContext context, List<BusinessModel> businesses) {
    final activeCount = businesses.where((b) => b.active).length;

    final cards = [
      _buildStatCard(
        title: 'Empresas Registradas',
        value: '${businesses.length}',
        subtitle: 'Razones sociales activas',
        icon: Icons.apartment_rounded,
        color: AppColors.kPrimary600,
        bgColor: AppColors.kPrimary50,
      ),
      _buildStatCard(
        title: 'Empresas Activas',
        value: '$activeCount',
        subtitle: 'En operación regular',
        icon: Icons.check_circle_outline_rounded,
        color: AppColors.kSuccess,
        bgColor: const Color(0xffECFDF5),
      ),
      _buildStatCard(
        title: 'Estado del Servicio',
        value: 'En Línea',
        subtitle: 'Backend Spring Boot OK',
        icon: Icons.cloud_done_rounded,
        color: const Color(0xff2563EB),
        bgColor: const Color(0xffEFF6FF),
      ),
    ];

    if (isDesktop) {
      return Row(
        children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList(),
      );
    } else {
      return Column(
        children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList(),
      );
    }
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kNeutral200),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: AppColors.kNeutral500, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.kDark1),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: AppColors.kNeutral400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSkeleton() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kNeutral200),
      ),
    );
  }

  Widget _buildRecentBusinessesSection(BuildContext context, WidgetRef ref, List<BusinessModel> businesses) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kNeutral200),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tus Empresas Recientes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.kDark1),
              ),
              TextButton.icon(
                onPressed: () {
                  ref.read(selectedSideMenuItemProvider.notifier).selectByRoute(Routes.businesses);
                  NavigationService.replaceWith(context, Routes.businesses);
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.kPrimary600),
                label: const Text('Ver todas', style: TextStyle(color: AppColors.kPrimary600, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (businesses.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No tienes empresas registradas aún.',
                  style: TextStyle(color: AppColors.kNeutral400, fontSize: 13),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: businesses.length > 3 ? 3 : businesses.length,
              separatorBuilder: (context, index) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final b = businesses[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.kPrimary100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: b.logoUrl != null && b.logoUrl!.isNotEmpty
                          ? Image.network(
                              b.logoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) =>
                                  const Icon(Icons.business_rounded, color: AppColors.kPrimary800, size: 22),
                            )
                          : const Icon(Icons.business_rounded, color: AppColors.kPrimary800, size: 22),
                    ),
                  ),
                  title: Text(
                    b.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.kDark1),
                  ),
                  subtitle: Text(
                    b.rfc.isNotEmpty ? 'RFC: ${b.rfc}' : 'Sin RFC',
                    style: const TextStyle(fontSize: 12, color: AppColors.kNeutral500),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.kNeutral400),
                  onTap: () {
                    ref.read(selectedBusinessProvider.notifier).select(b);
                    NavigationService.navigateTo(context, Routes.businessDetail, arguments: b);
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
