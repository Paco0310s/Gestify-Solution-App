import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestify_solution/business/features/businesses/businesses_provider.dart';
import 'package:gestify_solution/business/features/businesses/models/business_model.dart';
import 'package:gestify_solution/common/constants/app_colors.dart';
import 'package:gestify_solution/common/constants/app_texts.dart';
import 'package:gestify_solution/common/features/side_menu/app_side_menu_provider.dart';
import 'package:gestify_solution/common/routes/routes.dart';
import 'package:gestify_solution/common/services/navigation_service.dart';
import 'package:gestify_solution/common/widgets/app_button.dart';
import 'package:gestify_solution/common/widgets/app_dashboard_layout.dart';
import 'package:gestify_solution/common/widgets/app_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BusinessesScreen extends ConsumerWidget {
  final String title;
  const BusinessesScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<BusinessModel>> businessesAsyncValue = ref.watch(businessesListProvider);

    return businessesAsyncValue.when(
      data: (businesses) {
        return AppDashboardLayout(
          title: title,
          subtitle: 'Administra tus empresas y razones sociales',
          mobileChild: BusinessesMobileView(businesses: businesses),
          tabletChild: BusinessesTabletView(businesses: businesses),
          desktopChild: BusinessesDesktopView(businesses: businesses),
        );
      },
      loading: () {
        return AppDashboardLayout(
          title: title,
          subtitle: 'Administra tus empresas y razones sociales',
          mobileChild: const BusinessesMobileViewWhenLoading(),
          tabletChild: const BusienssesTabletViewWhenLoading(),
          desktopChild: const BusinessesDesktopViewWhenLoading(),
        );
      },
      error: (error, stackTrace) {
        return AppDashboardLayout(
          title: title,
          subtitle: 'Administra tus empresas y razones sociales',
          mobileChild: Center(child: AppText('${AppTexts.error} $error')),
          tabletChild: Center(child: AppText('${AppTexts.error} $error')),
          desktopChild: Center(child: AppText('${AppTexts.error} $error')),
        );
      },
    );
  }
}

class BusinessesDesktopView extends ConsumerWidget {
  final List<BusinessModel> businesses;

  const BusinessesDesktopView({super.key, required this.businesses});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (businesses.isEmpty) {
      return const EmptyBusinessesView();
    }

    return Column(
      children: [
        _buildHeaderBar(context, ref, businesses.length),
        const SizedBox(height: 18),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.6,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
            ),
            itemCount: businesses.length,
            itemBuilder: (context, index) => BusinessItem(business: businesses[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderBar(BuildContext context, WidgetRef ref, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.kNeutral200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Tus Empresas',
                style: TextStyle(
                  color: AppColors.kDark1,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.kPrimary100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: AppColors.kPrimary800,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 220,
            height: 42,
            child: AppButton(
              text: AppTexts.addBusinessButton,
              onPressed: () => navigateToAddBusinessScreen(context, ref),
              leadingWidget: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
              backgroundColor: AppColors.kPrimary600,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class BusinessesDesktopViewWhenLoading extends ConsumerWidget {
  const BusinessesDesktopViewWhenLoading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.kNeutral200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tus Empresas',
                style: TextStyle(color: AppColors.kDark1, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 220,
                height: 42,
                child: AppButton(
                  text: AppTexts.addBusinessButton,
                  onPressed: () {},
                  leadingWidget: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                  backgroundColor: AppColors.kPrimary600,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: Skeletonizer(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.6,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
              ),
              itemCount: 6,
              itemBuilder: (context, index) => const BusinessItem(business: null),
            ),
          ),
        ),
      ],
    );
  }
}

class BusinessesTabletView extends ConsumerWidget {
  final List<BusinessModel> businesses;

  const BusinessesTabletView({super.key, required this.businesses});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (businesses.isEmpty) {
      return const EmptyBusinessesView();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.kNeutral200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Tus Empresas',
                    style: TextStyle(color: AppColors.kDark1, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${businesses.length}',
                      style: const TextStyle(color: AppColors.kPrimary800, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 190,
                height: 40,
                child: AppButton(
                  text: AppTexts.addBusinessButton,
                  onPressed: () => navigateToAddBusinessScreen(context, ref),
                  leadingWidget: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                  backgroundColor: AppColors.kPrimary600,
                  textColor: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.6,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: businesses.length,
            itemBuilder: (context, index) => BusinessItem(business: businesses[index]),
          ),
        ),
      ],
    );
  }
}

class BusienssesTabletViewWhenLoading extends ConsumerWidget {
  const BusienssesTabletViewWhenLoading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.kNeutral200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tus Empresas',
                style: TextStyle(color: AppColors.kDark1, fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 190,
                height: 40,
                child: AppButton(
                  text: AppTexts.addBusinessButton,
                  onPressed: () {},
                  leadingWidget: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                  backgroundColor: AppColors.kPrimary600,
                  textColor: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Skeletonizer(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.6,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: 4,
              itemBuilder: (context, index) => const BusinessItem(business: null),
            ),
          ),
        ),
      ],
    );
  }
}

class BusinessesMobileView extends ConsumerWidget {
  final List<BusinessModel> businesses;

  const BusinessesMobileView({super.key, required this.businesses});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (businesses.isEmpty) {
      return const EmptyBusinessesView();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.kNeutral200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Empresas',
                    style: TextStyle(color: AppColors.kDark1, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.kPrimary100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${businesses.length}',
                      style: const TextStyle(color: AppColors.kPrimary800, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 160,
                height: 38,
                child: AppButton(
                  text: AppTexts.addBusinessButton,
                  onPressed: () => navigateToAddBusinessScreen(context, ref),
                  leadingWidget: const Icon(Icons.add_rounded, color: Colors.white, size: 16),
                  backgroundColor: AppColors.kPrimary600,
                  textColor: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) => BusinessItem(business: businesses[index]),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: businesses.length,
          ),
        ),
      ],
    );
  }
}

class BusinessesMobileViewWhenLoading extends ConsumerWidget {
  const BusinessesMobileViewWhenLoading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Skeletonizer(
      child: ListView.separated(
        itemBuilder: (context, index) => const BusinessItem(business: null),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: 5,
      ),
    );
  }
}

class BusinessItem extends ConsumerWidget {
  final BusinessModel? business;

  const BusinessItem({super.key, required this.business});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = business?.active ?? true;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kNeutral200),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: business == null
              ? null
              : () {
                  ref.read(selectedBusinessProvider.notifier).select(business);
                  NavigationService.navigateTo(
                    context,
                    Routes.businessDetail,
                    arguments: business,
                  );
                },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Logo with rounded container
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.kPrimary50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.kPrimary100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: business?.logoUrl != null && business!.logoUrl!.isNotEmpty
                        ? Image.network(
                            business!.logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.business_rounded, color: AppColors.kPrimary700, size: 26),
                          )
                        : const Icon(Icons.business_rounded, color: AppColors.kPrimary700, size: 26),
                  ),
                ),
                const SizedBox(width: 14),

                // Name, RFC, and Industry
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              business?.name ?? 'Cargando...',
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.kDark1,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          // Status indicator pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.kSuccess20Op : AppColors.kNeutral200,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: isActive ? AppColors.kSuccess : AppColors.kNeutral500,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isActive ? 'Activo' : 'Inactivo',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isActive ? AppColors.kSuccess : AppColors.kNeutral600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          if (business?.rfc.isNotEmpty == true) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.kNeutral100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                business!.rfc,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.kNeutral700,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (business?.industry != null)
                            Expanded(
                              child: Text(
                                business!.industry!.industry,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.kNeutral500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Arrow icon container
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.kNeutral50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.kNeutral400,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyBusinessesView extends ConsumerWidget {
  const EmptyBusinessesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.kNeutral200),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.kPrimary100, AppColors.kPrimary50],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.kPrimary200),
              ),
              child: const Icon(
                Icons.storefront_rounded,
                size: 36,
                color: AppColors.kPrimary700,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aún no tienes empresas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.kDark1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Comienza agregando tu primera empresa para gestionar sucursales, facturación y catálogo en Gestify Solution.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.kNeutral500,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: AppButton(
                text: 'Registrar Mi Primera Empresa',
                onPressed: () => navigateToAddBusinessScreen(context, ref),
                leadingWidget: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                backgroundColor: AppColors.kPrimary600,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void navigateToAddBusinessScreen(BuildContext context, WidgetRef ref) {
  NavigationService.replaceWith(context, Routes.businessAdd);
  ref.read(selectedSideMenuItemProvider.notifier).selectByRoute(Routes.businessAdd);
}
