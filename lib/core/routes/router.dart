import 'dart:async';

import 'package:bloc_auth_go_router/features/auth/domain/entity/cart_entity.dart';
import 'package:bloc_auth_go_router/features/auth/presentation/pages/cart_page.dart';
import 'package:bloc_auth_go_router/features/auth/presentation/pages/product.dart';
import 'package:bloc_auth_go_router/features/auth/presentation/pages/productDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash.dart';

class Routes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String product = '/product';
  static const String productDetails = '/product/details';
  static const String cart = '/cart';
}

class AppRouter {
  final AuthBloc authBloc;

  AppRouter({required this.authBloc});

  GoRouter get router => GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;

      final isGoingToLogin = state.matchedLocation == Routes.login;
      final isGoingToSplash = state.matchedLocation == Routes.splash;

      if (authState is AuthUnauthenticated || authState is AuthError) {
        return isGoingToLogin ? null : Routes.login;
      }
      if (authState is AuthAuthenticated) {
        if (isGoingToLogin || isGoingToSplash) {
          return Routes.home;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) {
          return SplashPage();
        },
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) {
          return LoginPage();
        },
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) {
          return HomePage();
        },
      ),
      //Single Value
      GoRoute(
        path: '${Routes.product}/:productId',
        builder: (context, state) {
          return Product(productId: state.pathParameters['productId']!);
        },
      ),
      //Multiple values
      GoRoute(
        path: "${Routes.productDetails}/:productId/:productName/:productPrice",
        builder: (context, state) {
          String? productId = state.pathParameters['productId'];
          String? productName = state.pathParameters['productName'];
          String? productPrice = state.pathParameters['productPrice'];
          return ProductDetails(
            productId: int.parse(productId!),
            productName: productName!,
            productPrice: double.parse(productPrice!),
          );
        },
      ),
      // Passing complex object
      GoRoute(
        path: Routes.cart,
        builder: (context, state) {
          final cartProduct = state.extra as CartEntity;
          return CartPage(cart: cartProduct);
        },
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription _subscription;
}
