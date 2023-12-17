import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/cubit/auth%20/cubit/auth_cubit.dart';
import 'package:noteapp/cubit/credential/cubit/credential_cubit.dart';
import 'package:noteapp/router/on_generate_route.dart';
import 'package:noteapp/ui/home_page.dart';
import 'package:noteapp/ui/sign_in_page.dart';

import 'cubit/note/cubit/note_cubit.dart';
import 'cubit/user/cubit/user_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()..appStarted()),
        BlocProvider<CredentialCubit>(
          create: (_) => CredentialCubit(),
        ),
        BlocProvider<UserCubit>(
          create: (_) => UserCubit(),
        ),
        BlocProvider<NoteCubit>(
          create: (_) => NoteCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter',
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 45, 111)),
          useMaterial3: true,
        ),
        onGenerateRoute: onGenreateRoute.route,
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
              if (authState is Authenticated) {
                if (authState == "") {
                  return const SignInPage();
                } else {
                  print("authState:-> ${authState}");
                  return HomePage(uid: authState.uid);
                }
              } else {
                return const SignInPage();
              }
            });
          }
        },
      ),
    );
  }
}
