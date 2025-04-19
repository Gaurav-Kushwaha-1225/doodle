import 'dart:convert';

import 'package:doodletracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:doodletracker/features/auth/presentation/pages/otp_verify.dart';
import 'package:doodletracker/features/auth/presentation/pages/signin.dart';
import 'package:doodletracker/features/home/presentation/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DoodleRouter {
  GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = context.read<AuthBloc>().state is AuthVerified;
      
      if (state.matchedLocation == '/login' && isLoggedIn) {
        return '/home';
      }
      
      if (state.matchedLocation == '/home' && !isLoggedIn) {
        return '/login';
      }
      
      if (state.matchedLocation == '/' && !isLoggedIn) {
        return '/login';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomePage(),
        ),
      ),
      GoRoute(
        name: 'otp_verify',
        path: '/otp_verify/:id',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: OTPVerificationPage(
            verificationId: jsonDecode(state.pathParameters['id']!),
          ),
        ),
      ),
    ],
  );
}
