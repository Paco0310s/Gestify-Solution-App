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
          mobileChild: BusinessesMobileView(businesses: businesses),
          tabletChild: BusinessesTabletView(businesses: businesses),
          desktopChild: BusinessesDesktopView(businesses: businesses),
        );
      },
      loading: () {
        return AppDashboardLayout(
          title: title,
          mobileChild: Center(child: BusinessesMobileViewWhenLoading()),
          tabletChild: Center(child: BusienssesTabletViewWhenLoading()),
          desktopChild: Center(child: BusinessesDesktopViewWhenLoading()),
        );
      },
      error: (error, stackTrace) {
        return AppDashboardLayout(
          title: title,
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(AppTexts.businessListTitle, color: AppColors.kPrimary800, fontSize: 15, fontWeight: FontWeight.bold),
            SizedBox(
              width: 300,
              child: AppButton(
                text: AppTexts.addBusinessButton,
                onPressed: () {
                  navigateToAddBusinessScreen(context, ref);
                },
                leadingWidget: Icon(Icons.add, color: AppColors.kPrimary800, size: 20),
                backgroundColor: AppColors.kNeutral100,
                textColor: AppColors.kPrimary800,
                borderColor: AppColors.kPrimary200,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Expanded(
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
            children: businesses.map((business) => BusinessItem(business: business)).toList(),
          ),
        ),
      ],
    );
  }
}

class BusinessesDesktopViewWhenLoading extends ConsumerWidget {
  const BusinessesDesktopViewWhenLoading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(AppTexts.businessListTitle, color: AppColors.kPrimary800, fontSize: 15, fontWeight: FontWeight.bold),
            SizedBox(
              width: 300,
              child: AppButton(
                text: AppTexts.addBusinessButton,
                onPressed: () {
                  navigateToAddBusinessScreen(context, ref);
                },
                leadingWidget: Icon(Icons.add, color: AppColors.kPrimary800, size: 20),
                backgroundColor: AppColors.kNeutral100,
                textColor: AppColors.kPrimary800,
                borderColor: AppColors.kPrimary200,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Expanded(
          child: Skeletonizer(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
              children: List.generate(8, (index) => BusinessItem(business: null)).toList(),
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(AppTexts.businessListTitle, color: AppColors.kPrimary800, fontSize: 15, fontWeight: FontWeight.bold),
            SizedBox(
              width: 240,
              height: 45,
              child: AppButton(
                text: AppTexts.addBusinessButton,
                onPressed: () {
                  navigateToAddBusinessScreen(context, ref);
                },
                leadingWidget: Icon(Icons.add, color: AppColors.kPrimary800, size: 20),
                backgroundColor: AppColors.kNeutral100,
                textColor: AppColors.kPrimary800,
                borderColor: AppColors.kPrimary200,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Expanded(
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
            children: businesses.map((business) => BusinessItem(business: business)).toList(),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(AppTexts.businessListTitle, color: AppColors.kPrimary800, fontSize: 15, fontWeight: FontWeight.bold),
            SizedBox(
              width: 240,
              height: 45,
              child: AppButton(
                text: AppTexts.addBusinessButton,
                onPressed: () {
                  navigateToAddBusinessScreen(context, ref);
                },
                leadingWidget: Icon(Icons.add, color: AppColors.kPrimary800, size: 20),
                backgroundColor: AppColors.kNeutral100,
                textColor: AppColors.kPrimary800,
                borderColor: AppColors.kPrimary200,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Expanded(
          child: Skeletonizer(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
              children: List.generate(8, (index) => BusinessItem(business: null)).toList(),
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(AppTexts.businessListTitle, color: AppColors.kPrimary800, fontSize: 15, fontWeight: FontWeight.bold),
            SizedBox(
              width: 180,
              height: 40,
              child: AppButton(
                text: AppTexts.addBusinessButton,
                onPressed: () {
                  navigateToAddBusinessScreen(context, ref);
                },
                leadingWidget: Icon(Icons.add, color: AppColors.kPrimary800, size: 20),
                backgroundColor: AppColors.kNeutral100,
                textColor: AppColors.kPrimary800,
                borderColor: AppColors.kPrimary200,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => BusinessItem(business: businesses[index]),
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(AppTexts.businessListTitle, color: AppColors.kPrimary800, fontSize: 15, fontWeight: FontWeight.bold),
            SizedBox(
              width: 180,
              height: 40,
              child: AppButton(
                text: AppTexts.addBusinessButton,
                onPressed: () {
                  navigateToAddBusinessScreen(context, ref);
                },
                leadingWidget: Icon(Icons.add, color: AppColors.kPrimary800, size: 20),
                backgroundColor: AppColors.kNeutral100,
                textColor: AppColors.kPrimary800,
                borderColor: AppColors.kPrimary200,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Expanded(
          child: Skeletonizer(child: ListView.builder(itemBuilder: (context, index) => BusinessItem(business: null), itemCount: 8)),
        ),
      ],
    );
  }
}

class BusinessItem extends StatelessWidget {
  final BusinessModel? business;

  const BusinessItem({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppColors.kNeutral200),
      ),
      child: Center(
        child: ListTile(
          leading: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: AppColors.kPrimary100, borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.business, color: AppColors.kPrimary800),
          ),
          title: AppText(business?.name ?? '', fontSize: 14, fontWeight: FontWeight.w600),
          subtitle: AppText('ID: ${business?.id ?? ''}', fontSize: 10, color: AppColors.kNeutral600),
        ),
      ),
    );
  }
}

void navigateToAddBusinessScreen(BuildContext context, WidgetRef ref) {
  NavigationService.replaceWith(context, Routes.businessAdd);

  ref.read(selectedSideMenuItemProvider.notifier).selectByRoute(Routes.businessAdd);
}
