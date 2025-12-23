import 'dart:async';


import 'package:bloc_auth_go_router/features/auth/presentation/pages/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash.dart';

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
      GoRoute(
        path: '${Routes.product}/:productId',
        builder: (context, state) {
          return Product(productId: state.pathParameters['productId']!);
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

class Routes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String product = '/product';
}