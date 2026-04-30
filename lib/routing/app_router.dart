import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kinbii/presentation/pages/main/main_screen.dart';
import 'package:kinbii/presentation/pages/home/home_screen.dart';
import 'package:kinbii/presentation/pages/product_in/product_in_screen.dart';
import 'package:kinbii/presentation/pages/product_out/product_out_screen.dart';
import 'package:kinbii/presentation/pages/setting/setting_screen.dart';
import 'package:kinbii/presentation/pages/setting/manage_category_screen.dart';
import 'package:kinbii/presentation/pages/setting/manage_storage_screen.dart';
import 'package:kinbii/presentation/pages/product_list/product_list_screen.dart';
import 'package:kinbii/presentation/pages/report/report_product_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorHomeKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellHome');
  static final GlobalKey<NavigatorState> _shellNavigatorProductInKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellProductIn');
  static final GlobalKey<NavigatorState> _shellNavigatorProductOutKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellProductOut');
  static final GlobalKey<NavigatorState> _shellNavigatorSettingKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellSetting');

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProductInKey,
            routes: [
              GoRoute(
                path: '/product-in',
                name: 'product_in',
                builder: (context, state) => const ProductInScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProductOutKey,
            routes: [
              GoRoute(
                path: '/product-out',
                name: 'product_out',
                builder: (context, state) => const ProductOutScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorSettingKey,
            routes: [
              GoRoute(
                path: '/setting',
                name: 'setting',
                builder: (context, state) => const SettingScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/product-list',
        name: 'product_list',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final categoryName = state.extra as String? ?? 'Kategori';
          return ProductListScreen(categoryName: categoryName);
        },
      ),
      GoRoute(
        path: '/manage-category',
        name: 'manage_category',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ManageCategoryScreen(),
      ),
      GoRoute(
        path: '/manage-storage',
        name: 'manage_storage',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ManageStorageScreen(),
      ),
      GoRoute(
        path: '/report-product',
        name: 'report_product',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => ReportProductScreen(),
      ),
    ],
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Page Not Found'))),
  );
}
