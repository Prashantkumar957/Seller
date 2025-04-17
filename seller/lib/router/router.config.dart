import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller/views/product_manager/add_product/steps.dart' as productSteps;
import 'package:seller/router/routes.dart';
import 'package:seller/views/dummy_screen.dart';
import 'package:seller/views/product_manager/product_manager_screen.dart';

part of 'router.config.dart'; // Ensure this points to the generated part file

abstract class AppRouter {
  static final _routerNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter _router = GoRouter(
    navigatorKey: _routerNavigatorKey,
    initialLocation: AppRoutes.tempScreen,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (context, state) => const DummyScreen("Splash Screen"), // Replace with your splash screen
      ),
      GoRoute(
        path: AppRoutes.tempScreen,
        name: AppRoutes.tempScreen,
        builder: (context, state) => const DummyScreen("Dummy Screen"),
      ),
      // GoRoute(
      //   path: AppRoutes.loginDE,
      //   name: AppRoutes.loginDE,
      //   builder: (context, state) => const LoginDEScreen(), // Replace with your DE login screen
      // ),
      // GoRoute(
      //   path: AppRoutes.loginClient,
      //   name: AppRoutes.loginClient,
      //   builder: (context, state) => const LoginClientScreen(), // Replace with your client login screen
      // ),
      // GoRoute(
      //   path: AppRoutes.settings,
      //   name: AppRoutes.settings,
      //   builder: (context, state) => const SettingsScreen(),
      //   routes: [
      //     GoRoute(
      //       path: AppRoutes.generalSettings.split('/').last, // Relative path
      //       name: AppRoutes.generalSettings,
      //       builder: (context, state) => const GeneralSettings(),
      //     ),
      //     GoRoute(
      //       path: AppRoutes.proliferationSettings.split('/').last, // Relative path
      //       name: AppRoutes.proliferationSettings,
      //       builder: (context, state) => const ProliferationSettings(),
      //     ),
      //     GoRoute(
      //       path: AppRoutes.seoSettings.split('/').last, // Relative path
      //       name: AppRoutes.seoSettings,
      //       builder: (context, state) => const SeoSettings(),
      //     ),
      //     GoRoute(
      //       path: AppRoutes.extraSettings.split('/').last, // Relative path
      //       name: AppRoutes.extraSettings,
      //       builder: (context, state) => const ExtraSettings(),
      //     ),
      //     GoRoute(
      //       path: AppRoutes.paymentSettings.split('/').last, // Relative path
      //       name: AppRoutes.paymentSettings,
      //       builder: (context, state) => const PaymentSettings(),
      //     ),
      //     GoRoute(
      //       path: AppRoutes.socialLinks.split('/').last, // Relative path
      //       name: AppRoutes.socialLinks,
      //       builder: (context, state) => const SocialLinks(),
      //     ),
      //     GoRoute(
      //       path: AppRoutes.socialApiLinks.split('/').last, // Relative path
      //       name: AppRoutes.socialApiLinks,
      //       builder: (context, state) => const SocialApiSettings(),
      //     ),
      //     GoRoute(
      //       path: AppRoutes.accountSettings.split('/').last, // Relative path
      //       name: AppRoutes.accountSettings,
      //       builder: (context, state) => const AccountSettings(),
      //     ),
      //   ],
      // ),
      GoRoute(
        path: AppRoutes.productManager,
        name: AppRoutes.productManager,
        builder: (context, state) => const ProductManagerScreen(),
      ),
      GoRoute(
        path: AppRoutes.productStepOne,
        name: AppRoutes.productStepOne,
        builder: (context, state) => productSteps.StepOneScreen(
          initialValue: state.extra is List && (state.extra as List).isNotEmpty
              ? (state.extra as List)[0] as String? ?? "Self"
              : "Self",
          vendors: state.extra is List && (state.extra as List).length > 1
              ? (state.extra as List)[1] as List<Map<String, dynamic>>
              : const [],
        ),
      ),
      GoRoute(
        path: AppRoutes.productStepTwo,
        name: AppRoutes.productStepTwo,
        builder: (context, state) => productSteps.StepTwoScreen(
          formData: state.extra as Map<String, dynamic>? ?? const {},
        ),
      ),
      // GoRoute(
      //   path: AppRoutes.productStepThree,
      //   name: AppRoutes.productStepThree,
      //   builder: (context, state) => const productSteps.StepThreeScreen(), // Replace with your StepThreeScreen
      // ),
      GoRoute(
        path: AppRoutes.productStepFour,
        name: AppRoutes.productStepFour,
        builder: (context, state) => productSteps.StepFourScreen(
          formData: state.extra as Map<String, dynamic>? ?? const {},
        ),
      ),
      GoRoute(
        path: AppRoutes.productStepFive,
        name: AppRoutes.productStepFive,
        builder: (context, state) => productSteps.StepFiveScreen(
          formData: state.extra as Map<String, dynamic>? ?? const {},
        ),
      ),
      GoRoute(
        path: AppRoutes.productStepSix,
        name: AppRoutes.productStepSix,
        builder: (context, state) => productSteps.StepSixScreen(
          formData: state.extra as Map<String, dynamic>? ?? const {},
        ),
      ),
      GoRoute(
        path: AppRoutes.productStepSeven,
        name: AppRoutes.productStepSeven,
        builder: (context, state) => productSteps.StepSevenScreen(
          formData: state.extra as Map<String, dynamic>? ?? const {},
        ),
      ),
      GoRoute(
        path: AppRoutes.productStepEight,
        name: AppRoutes.productStepEight,
        builder: (context, state) => productSteps.StepEightScreen(
          formData: state.extra as Map<String, dynamic>? ?? const {},
        ),
      ),
      // GoRoute(
      //   path: AppRoutes.clientPermissions,
      //   name: AppRoutes.clientPermissions,
      //   builder: (context, state) => PermissionScreen(
      //     siteId: state.extra as String,
      //   ),
      // ),
      // GoRoute(
      //   path: AppRoutes.packages,
      //   name: AppRoutes.packages,
      //   builder: (context, state) => const PackageScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.packageDetails,
      //   name: AppRoutes.packageDetails,
      //   builder: (context, state) => const PackageDetailsScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.items,
      //   name: AppRoutes.items,
      //   builder: (context, state) => const ItemsScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.categories,
      //   name: AppRoutes.categories,
      //   builder: (context, state) => const CategoryScreen(),
      // ),
    ],
  );

  static GoRouter get router => _router;
}