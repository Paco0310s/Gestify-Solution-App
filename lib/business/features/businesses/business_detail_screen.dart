import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gestify_solution/business/features/businesses/business_add_screen.dart';
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

class BusinessDetailScreen extends ConsumerWidget {
  final BusinessModel? business;

  const BusinessDetailScreen({super.key, this.business});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Resolve business from props, riverpod state, or route arguments
    final selectedFromProvider = ref.watch(selectedBusinessProvider);
    final routeArgs = ModalRoute.of(context)?.settings.arguments as BusinessModel?;
    final currentBusiness = business ?? selectedFromProvider ?? routeArgs;

    return AppDashboardLayout(
      title: AppTexts.businessDetailTitle,
      mobileChild: BusinessDetailContent(business: currentBusiness, isMobile: true),
      tabletChild: BusinessDetailContent(business: currentBusiness, isTablet: true),
      desktopChild: BusinessDetailContent(business: currentBusiness, isDesktop: true),
    );
  }
}

class BusinessDetailContent extends ConsumerWidget {
  final BusinessModel? business;
  final bool isDesktop;
  final bool isTablet;
  final bool isMobile;

  const BusinessDetailContent({
    super.key,
    required this.business,
    this.isDesktop = false,
    this.isTablet = false,
    this.isMobile = false,
  });

  void _handleBackToList(BuildContext context, WidgetRef ref) {
    ref.read(selectedSideMenuItemProvider.notifier).selectByRoute(Routes.businesses);
    NavigationService.replaceWith(context, Routes.businesses);
  }

  void _handleEditBusiness(BuildContext context) {
    if (business == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BusinessAddScreen(
          title: AppTexts.editBusinessTitle,
          initialBusiness: business,
        ),
      ),
    );
  }

  Future<void> _handleDeleteBusiness(BuildContext context, WidgetRef ref) async {
    if (business == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.kError20Op,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.warning_amber_rounded, color: AppColors.kError, size: 24),
              ),
              const Gap(12),
              Expanded(
                child: AppText(
                  AppTexts.deleteBusinessTitle,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kDark1,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                '¿Estás seguro de que deseas eliminar permanentemente la empresa "${business!.name}"?',
                fontSize: 14,
                color: AppColors.kDark2,
              ),
              const Gap(8),
              AppText(
                'Esta acción no se puede deshacer y se perderán todos los datos asociados.',
                fontSize: 12,
                color: AppColors.kNeutral500,
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          actions: [
            AppButton(
              text: AppTexts.cancel,
              onPressed: () => Navigator.of(dialogContext).pop(false),
              backgroundColor: AppColors.kNeutral100,
              textColor: AppColors.kNeutral700,
              borderColor: AppColors.kNeutral300,
              width: 110,
              height: 40,
              fontSize: 14,
            ),
            AppButton(
              text: AppTexts.delete,
              onPressed: () => Navigator.of(dialogContext).pop(true),
              backgroundColor: AppColors.kError,
              textColor: AppColors.kWhiteColor,
              leadingWidget: const Icon(Icons.delete_forever, color: AppColors.kWhiteColor, size: 18),
              width: 120,
              height: 40,
              fontSize: 14,
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      await BusinessActions.delete(ref, context, business!.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (business == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.business_center_outlined, size: 64, color: AppColors.kNeutral400),
            const Gap(16),
            AppText(AppTexts.noData, fontSize: 16, color: AppColors.kNeutral600),
            const Gap(16),
            SizedBox(
              width: 200,
              child: AppButton(
                text: AppTexts.backToList,
                onPressed: () => _handleBackToList(context, ref),
                leadingWidget: const Icon(Icons.arrow_back, size: 18),
              ),
            ),
          ],
        ),
      );
    }

    final isActionLoading = ref.watch(businessActionLoadingProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar with navigation & action buttons
          _buildActionHeader(context, ref, isActionLoading),
          const Gap(16),

          // Hero Banner & Profile Card
          _buildHeroCard(),
          const Gap(20),

          // Detail cards (Fiscal and Commercial)
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildFiscalCard()),
                const Gap(20),
                Expanded(child: _buildCommercialCard()),
              ],
            )
          else ...[
            _buildFiscalCard(),
            const Gap(16),
            _buildCommercialCard(),
          ],
          const Gap(24),
        ],
      ),
    );
  }

  Widget _buildActionHeader(BuildContext context, WidgetRef ref, bool isActionLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.kNeutral200),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: [
          TextButton.icon(
            onPressed: () => _handleBackToList(context, ref),
            icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: AppColors.kPrimary800),
            label: AppText(
              AppTexts.backToList,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.kPrimary800,
            ),
          ),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              AppButton(
                text: AppTexts.modifyBusinessButton,
                onPressed: () => _handleEditBusiness(context),
                leadingWidget: const Icon(Icons.edit_outlined, size: 18, color: AppColors.kPrimary800),
                backgroundColor: AppColors.kPrimary100,
                textColor: AppColors.kPrimary800,
                borderColor: AppColors.kPrimary300,
                height: 40,
                fontSize: 13,
              ),
              AppButton(
                text: AppTexts.deleteBusinessButton,
                onPressed: () => _handleDeleteBusiness(context, ref),
                isLoading: isActionLoading,
                leadingWidget: const Icon(Icons.delete_outline, size: 18, color: AppColors.kError),
                backgroundColor: AppColors.kError20Op,
                textColor: AppColors.kError,
                borderColor: AppColors.kError.withValues(alpha: 0.3),
                height: 40,
                fontSize: 13,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    final hasCover = business?.coverUrl != null && business!.coverUrl!.isNotEmpty;
    final hasLogo = business?.logoUrl != null && business!.logoUrl!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kNeutral200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cover Banner
          Container(
            height: isMobile ? 140 : 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.kPrimary800, AppColors.kPrimary500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: hasCover
                ? Image.network(
                    business!.coverUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildCoverFallback();
                    },
                  )
                : _buildCoverFallback(),
          ),

          // Business Identity Row (Logo + Name + Tags)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Container(
                  width: isMobile ? 70 : 90,
                  height: isMobile ? 70 : 90,
                  decoration: BoxDecoration(
                    color: AppColors.kWhiteColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.kNeutral200, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: hasLogo
                        ? Image.network(
                            business!.logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.business_rounded, color: AppColors.kPrimary800, size: 40);
                            },
                          )
                        : const Icon(Icons.business_rounded, color: AppColors.kPrimary800, size: 40),
                  ),
                ),
                const Gap(16),

                // Name & Metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AppText(
                              business!.name,
                              fontSize: isMobile ? 18 : 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.kDark1,
                            ),
                          ),
                          const Gap(8),
                          _buildStatusBadge(business!.active),
                        ],
                      ),
                      const Gap(6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          if (business!.rfc.isNotEmpty)
                            _buildInfoChip(Icons.badge_outlined, 'RFC: ${business!.rfc}'),
                          if (business!.industry != null)
                            _buildInfoChip(Icons.domain_outlined, business!.industry!.industry),
                          if (business!.establishmentDate != null && business!.establishmentDate!.isNotEmpty)
                            _buildInfoChip(Icons.event_outlined, 'Constitución: ${business!.establishmentDate}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverFallback() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.panorama_outlined, size: 48, color: AppColors.kWhiteColor.withValues(alpha: 0.4)),
          const Gap(4),
          Text(
            'Sin imagen de portada',
            style: TextStyle(color: AppColors.kWhiteColor.withValues(alpha: 0.6), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active ? AppColors.kSuccess20Op : AppColors.kNeutral200,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: active ? AppColors.kSuccess.withValues(alpha: 0.4) : AppColors.kNeutral300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? AppColors.kSuccess : AppColors.kNeutral600,
            ),
          ),
          const Gap(6),
          AppText(
            active ? AppTexts.statusActive : AppTexts.statusInactive,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? AppColors.kSuccess : AppColors.kNeutral700,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.kNeutral100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.kNeutral200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.kNeutral600),
          const Gap(6),
          AppText(text, fontSize: 12, color: AppColors.kNeutral700, fontWeight: FontWeight.w500),
        ],
      ),
    );
  }

  Widget _buildFiscalCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kNeutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.kPrimary100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.receipt_long_rounded, color: AppColors.kPrimary800, size: 20),
              ),
              const Gap(10),
              AppText(AppTexts.fiscalData, fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.kDark1),
            ],
          ),
          const Divider(height: 24, color: AppColors.kNeutral200),

          _buildDetailRow(
            icon: Icons.tag,
            label: AppTexts.businessRfcLabel,
            value: business!.rfc.isNotEmpty ? business!.rfc : 'N/A',
            isHighlighted: true,
          ),
          const Gap(14),

          _buildDetailRow(
            icon: Icons.calendar_today_outlined,
            label: AppTexts.businessEstablishmentDateLabel,
            value: business!.establishmentDate ?? 'No especificada',
          ),
          const Gap(14),

          _buildDetailRow(
            icon: Icons.account_balance_outlined,
            label: AppTexts.businessTaxRegimenLabel,
            value: business!.taxRegimen != null ? business!.taxRegimen!.regimen : 'No asignado',
          ),
          const Gap(14),

          _buildDetailRow(
            icon: Icons.person_outline,
            label: AppTexts.businessTypeLabel,
            value: business!.businessesType != null
                ? '${business!.businessesType!.type} (${business!.businessesType!.code})'
                : 'No asignado',
          ),
        ],
      ),
    );
  }

  Widget _buildCommercialCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kNeutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.kPrimary100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.storefront_rounded, color: AppColors.kPrimary800, size: 20),
              ),
              const Gap(10),
              AppText(AppTexts.generalData, fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.kDark1),
            ],
          ),
          const Divider(height: 24, color: AppColors.kNeutral200),

          _buildDetailRow(
            icon: Icons.vpn_key_outlined,
            label: 'Identificador (ID)',
            value: business!.id,
          ),
          const Gap(14),

          _buildDetailRow(
            icon: Icons.category_outlined,
            label: AppTexts.businessIndustryLabel,
            value: business!.industry?.industry ?? 'No especificado',
          ),
          const Gap(14),

          _buildDetailRow(
            icon: Icons.description_outlined,
            label: AppTexts.businessDescriptionLabel,
            value: business!.description.isNotEmpty ? business!.description : 'Sin descripción registrada.',
            isMultiLine: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isHighlighted = false,
    bool isMultiLine = false,
  }) {
    return Row(
      crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: AppColors.kNeutral500),
        const Gap(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(label, fontSize: 12, color: AppColors.kNeutral500, fontWeight: FontWeight.w500),
              const Gap(2),
              AppText(
                value,
                fontSize: 14,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
                color: isHighlighted ? AppColors.kPrimary800 : AppColors.kDark2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

