import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestify_solution/business/features/businesses/businesses_service.dart';
import 'package:gestify_solution/business/features/businesses/models/business_model.dart';
import 'package:gestify_solution/business/features/businesses/models/create_business_dto.dart';
import 'package:gestify_solution/common/constants/app_texts.dart';
import 'package:gestify_solution/common/routes/routes.dart';
import 'package:gestify_solution/common/services/navigation_service.dart';
import 'package:gestify_solution/common/utils/snackbar_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'businesses_provider.g.dart';

@riverpod
Future<List<BusinessModel>> businessesList(Ref ref) async {
  final response = await BusinessesService.getBusinesses();

  return response.when(
    (failure) {
      // If server error or offline, fallback to empty list or throw
      return <BusinessModel>[];
    },
    (businesses) {
      return businesses;
    },
  );
}

@riverpod
class BusinessAddLoading extends _$BusinessAddLoading {
  @override
  bool build() {
    return false;
  }

  void setLoading(bool value) {
    state = value;
  }
}

@riverpod
class BusinessActionLoading extends _$BusinessActionLoading {
  @override
  bool build() {
    return false;
  }

  void setLoading(bool value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class SelectedBusiness extends _$SelectedBusiness {
  @override
  BusinessModel? build() {
    return null;
  }

  void select(BusinessModel? business) {
    state = business;
  }
}

class BusinessActions {
  static Future<bool> create(WidgetRef ref, BuildContext context, CreateBusinessDto dto) async {
    ref.read(businessAddLoadingProvider.notifier).setLoading(true);
    try {
      final result = await BusinessesService.createBusiness(dto);
      return result.when(
        (failure) {
          if (context.mounted) SnackbarUtil.showError(context, failure.message);
          return false;
        },
        (createdBusiness) {
          if (context.mounted) SnackbarUtil.showSuccess(context, AppTexts.businessCreatedSuccessfully);
          ref.invalidate(businessesListProvider);
          if (context.mounted) NavigationService.replaceWith(context, Routes.businesses);
          return true;
        },
      );
    } catch (e) {
      if (context.mounted) SnackbarUtil.showError(context, '${AppTexts.error}: $e');
      return false;
    } finally {
      ref.read(businessAddLoadingProvider.notifier).setLoading(false);
    }
  }

  static Future<bool> update(WidgetRef ref, BuildContext context, String id, CreateBusinessDto dto) async {
    ref.read(businessAddLoadingProvider.notifier).setLoading(true);
    try {
      final result = await BusinessesService.updateBusiness(id, dto);
      return result.when(
        (failure) {
          if (context.mounted) SnackbarUtil.showError(context, failure.message);
          return false;
        },
        (updatedBusiness) {
          if (context.mounted) SnackbarUtil.showSuccess(context, AppTexts.businessUpdatedSuccessfully);
          ref.read(selectedBusinessProvider.notifier).select(updatedBusiness);
          ref.invalidate(businessesListProvider);
          if (context.mounted) NavigationService.replaceWith(context, Routes.businesses);
          return true;
        },
      );
    } catch (e) {
      if (context.mounted) SnackbarUtil.showError(context, '${AppTexts.error}: $e');
      return false;
    } finally {
      ref.read(businessAddLoadingProvider.notifier).setLoading(false);
    }
  }

  static Future<bool> delete(WidgetRef ref, BuildContext context, String id) async {
    ref.read(businessActionLoadingProvider.notifier).setLoading(true);
    try {
      final result = await BusinessesService.deleteBusiness(id);
      return result.when(
        (failure) {
          if (context.mounted) SnackbarUtil.showError(context, failure.message);
          return false;
        },
        (success) {
          if (context.mounted) SnackbarUtil.showSuccess(context, AppTexts.businessDeletedSuccessfully);
          ref.invalidate(businessesListProvider);
          ref.read(selectedBusinessProvider.notifier).select(null);
          if (context.mounted) NavigationService.replaceWith(context, Routes.businesses);
          return true;
        },
      );
    } catch (e) {
      if (context.mounted) SnackbarUtil.showError(context, '${AppTexts.error}: $e');
      return false;
    } finally {
      ref.read(businessActionLoadingProvider.notifier).setLoading(false);
    }
  }
}
