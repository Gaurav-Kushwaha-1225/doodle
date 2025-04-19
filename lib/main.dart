import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doodletracker/config/routes.dart';
import 'package:doodletracker/features/auth/data/data_sources/auth_data_sources_impl.dart';
import 'package:doodletracker/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:doodletracker/features/auth/domain/usecases/get_current_user.dart';
import 'package:doodletracker/features/auth/domain/usecases/signout.dart';
import 'package:doodletracker/features/auth/domain/usecases/verify_otp.dart';
import 'package:doodletracker/features/auth/domain/usecases/verify_phone.dart';
import 'package:doodletracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:doodletracker/features/home/data/data_sources/habit_data_sources_impl.dart';
import 'package:doodletracker/features/home/data/repo_impl/habit_repo_impl.dart';
import 'package:doodletracker/features/home/domain/usecases/add_habit.dart';
import 'package:doodletracker/features/home/domain/usecases/delete_habit.dart';
import 'package:doodletracker/features/home/domain/usecases/get_habit.dart';
import 'package:doodletracker/features/home/domain/usecases/mark_habit_done.dart';
import 'package:doodletracker/features/home/presentation/bloc/habit_bloc.dart';
import 'package:doodletracker/firebase_options.dart';
import 'package:doodletracker/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final storage = await SharedPreferences.getInstance();
  
  final GoRouter router = DoodleRouter().router;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final authDataSource = AuthRemoteDataSourceImpl(firebaseAuth);
  final habitDataSource = HabitRemoteDataSourceImpl(firestore);

  final authRepository = AuthRepositoryImpl(authDataSource);
  final habitRepository = HabitRepositoryImpl(habitDataSource);

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider<VerifyPhoneUseCase>(
        create: (context) => VerifyPhoneUseCase(authRepository),
      ),
      RepositoryProvider<VerifyOTPUseCase>(
        create: (context) => VerifyOTPUseCase(authRepository),
      ),
      RepositoryProvider<SignOutUseCase>(
        create: (context) => SignOutUseCase(authRepository),
      ),
      RepositoryProvider<GetCurrentUserUseCase>(
        create: (context) => GetCurrentUserUseCase(authRepository),
      ),

      // Habit Repository Providers
      RepositoryProvider<GetHabitsUseCase>(
        create: (context) => GetHabitsUseCase(habitRepository),
      ),
      RepositoryProvider<AddHabitUseCase>(
        create: (context) => AddHabitUseCase(habitRepository),
      ),
      RepositoryProvider<DeleteHabitUseCase>(
        create: (context) => DeleteHabitUseCase(habitRepository),
      ),
      RepositoryProvider<MarkHabitCompletedUseCase>(
        create: (context) => MarkHabitCompletedUseCase(habitRepository),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(storage: storage)..loadSavedTheme(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            verifyPhoneUseCase: context.read<VerifyPhoneUseCase>(),
            verifyOTPUseCase: context.read<VerifyOTPUseCase>(),
            getCurrentUserUseCase: context.read<GetCurrentUserUseCase>(),
            signOutUseCase: context.read<SignOutUseCase>(),
          )..add(CheckAuthStatusEvent()),
        ),
        BlocProvider<HabitBloc>(
          create: (context) => HabitBloc(
            getHabitsUseCase: context.read<GetHabitsUseCase>(),
            addHabitUseCase: context.read<AddHabitUseCase>(),
            deleteHabitUseCase: context.read<DeleteHabitUseCase>(),
            markHabitCompletedUseCase: context.read<MarkHabitCompletedUseCase>(),
          ),
        ),
      ],
      child: DoodleTracker(router: router),
    ),
  ));
}

class DoodleTracker extends StatelessWidget {
  final GoRouter router;

  const DoodleTracker({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Doodle Tracker',
          themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
          theme: DoodleTheme.lightTheme,
          darkTheme: DoodleTheme.darkTheme,
          routerConfig: router,
        );
      },
    );
  }
}
