import 'package:flutter/material.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/di_container.dart';
import 'core/routes/router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection().init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DependencyInjection().serviceLocator<AuthBloc>(),
      child: Builder(builder: (context) {
        final authBloc = context.read<AuthBloc>();
        final appRouter = AppRouter(authBloc: authBloc);
        return MaterialApp.router(
          title: 'Auth Clean App',
          routerConfig: appRouter.router,
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}
