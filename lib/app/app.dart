import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../configs/configs.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/post/presentation/bloc/post_bloc.dart';
import '../features/user/presentation/bloc/user_bloc.dart';
import '../injection_container.dart';
import 'cubits/cubits.dart';
import 'locale.dart';
import 'routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => LogCubit()..initialize()),
        BlocProvider(create: (context) => LocaleCubit()),
        // Provide feature-specific BLoCs using GetIt
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<PostBloc>()..add(GetAllPostsEvent())),
        BlocProvider(create: (context) => sl<UserBloc>()),
      ],
      child: const _App(),
    );
  }
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (_, theme) {
        return BlocBuilder<LocaleCubit, Locale>(
          builder: (_, locale) {
            return _materialApp(theme, locale);
          },
        );
      },
    );
  }

  MaterialApp _materialApp(ThemeData theme, Locale locale) {
    return MaterialApp.router(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: routes,
      locale: locale,
      supportedLocales: supportedLocale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        // Return the first supported locale
        return supportedLocales.first;
      },
    );
  }
}
