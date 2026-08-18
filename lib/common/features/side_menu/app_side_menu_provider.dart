import 'package:flutter/material.dart';
import 'package:gestify_solution/common/constants/app_texts.dart';
import 'package:gestify_solution/common/logging/app_logger.dart';
import 'package:gestify_solution/common/routes/routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_side_menu_provider.g.dart';

@riverpod
class DurationOnExpandAndCollapse extends _$DurationOnExpandAndCollapse {
  @override
  Duration build() {
    return Duration(milliseconds: 250);
  }
}

@riverpod
class DelayOnMenuItemAnimation extends _$DelayOnMenuItemAnimation {
  @override
  Duration build() {
    return Duration(milliseconds: 125);
  }
}

@riverpod
class DurationOnMenuItemAnimation extends _$DurationOnMenuItemAnimation {
  @override
  Duration build() {
    return Duration(milliseconds: 125);
  }
}

@riverpod
class IsExpandedSideMenu extends _$IsExpandedSideMenu {
  @override
  bool build() {
    return true; // Default to expanded
  }

  void toggle() {
    state = !state;
  }

  void setExpanded(bool expanded) {
    state = expanded;
  }
}

@Riverpod(keepAlive: true)
class SelectedSideMenuItem extends _$SelectedSideMenuItem {
  @override
  int build() {
    return 0; // Default to first item
  }

  void select(int id) {
    state = id;
  }

  void selectByRoute(String route) {
    final menuItems = ref.read(sideMenuItemsProvider);

    for (var item in menuItems) {
      if (item.route == route) {
        state = item.id;
        AppLogger.info("Selected side menu item changed to ID: ${item.id} for route: $route");
        return;
      }
      for (var subItem in item.subItems) {
        if (subItem.route == route) {
          state = subItem.id;
          AppLogger.info("Selected side menu item changed to ID: ${subItem.id} for route: $route");
          return;
        }
      }
    }
  }
}

@riverpod
class SideMenuItems extends _$SideMenuItems {
  @override
  List<AppSideMenuModel> build() {
    return [
      AppSideMenuModel(id: 1, title: AppTexts.home, icon: Icons.home, route: Routes.dashboard),
      AppSideMenuModel(
        id: 2,
        title: AppTexts.businessesTitle,
        icon: Icons.business,
        route: Routes.businesses,
        subItems: [
          AppSideMenuModel(id: 3, title: AppTexts.businessListTitle, icon: Icons.apartment, route: Routes.businesses),
          AppSideMenuModel(id: 4, title: AppTexts.addBusinessButton, icon: Icons.add_business, route: Routes.businessAdd),
        ],
      ),
      AppSideMenuModel(
        id: 5,
        title: AppTexts.bossesTitle,
        icon: Icons.supervisor_account,
        route: Routes.businesses,
        subItems: [
          AppSideMenuModel(id: 6, title: AppTexts.bossListTitle, icon: Icons.supervisor_account, route: Routes.businesses),
          AppSideMenuModel(id: 7, title: AppTexts.addBossButton, icon: Icons.add_reaction_sharp, route: Routes.businessAdd),
        ],
      ),
    ];
  }
}

class AppSideMenuModel {
  final int id;
  final ExpansibleController controller = ExpansibleController();
  final String title;
  final IconData icon;
  final String route;
  final List<AppSideMenuModel> subItems;

  AppSideMenuModel({required this.id, required this.title, required this.icon, required this.route, this.subItems = const []});
}
