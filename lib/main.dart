import 'package:doodletracker/config/routes.dart';
import 'package:doodletracker/features/auth/data/data_sources/auth_data_sources_impl.dart';
import 'package:doodletracker/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:doodletracker/features/auth/domain/usecases/get_current_user.dart';
import 'package:doodletracker/features/auth/domain/usecases/signout.dart';
import 'package:doodletracker/features/auth/domain/usecases/verify_otp.dart';
import 'package:doodletracker/features/auth/domain/usecases/verify_phone.dart';
import 'package:doodletracker/features/auth/presentation/bloc/auth_bloc.dart';
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
  
  // Set Firebase Auth settings for development
  // await FirebaseAuth.instance.setSettings(
  //   appVerificationDisabledForTesting: false, // Set to false to receive real OTPs
  //   forceRecaptchaFlow: false,
  // );

  final GoRouter router = DoodleRouter().router;
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(
        create: (context) => ThemeBloc(storage: storage)..loadSavedTheme(),
      ),
      BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          verifyPhoneUseCase: VerifyPhoneUseCase(AuthRepositoryImpl(AuthRemoteDataSourceImpl(FirebaseAuth.instance))),
          verifyOTPUseCase: VerifyOTPUseCase(AuthRepositoryImpl(AuthRemoteDataSourceImpl(FirebaseAuth.instance))),
          getCurrentUserUseCase: GetCurrentUserUseCase(AuthRepositoryImpl(AuthRemoteDataSourceImpl(FirebaseAuth.instance))),
          signOutUseCase: SignOutUseCase(AuthRepositoryImpl(AuthRemoteDataSourceImpl(FirebaseAuth.instance))),
        )..add(CheckAuthStatusEvent()),
      ),
    ],
    child: DoodleTracker(router: router),
  ));
}

class DoodleTracker extends StatelessWidget {
  final GoRouter router;

  DoodleTracker({super.key, required this.router});


  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<VerifyPhoneUseCase>(
          create: (context) => VerifyPhoneUseCase(AuthRepositoryImpl(AuthRemoteDataSourceImpl(firebaseAuth)))
        ),
        RepositoryProvider<VerifyOTPUseCase>(
          create: (context) => VerifyOTPUseCase(AuthRepositoryImpl(AuthRemoteDataSourceImpl(firebaseAuth)))
        ),
        RepositoryProvider<SignOutUseCase>(
          create: (context) => SignOutUseCase(AuthRepositoryImpl(AuthRemoteDataSourceImpl(firebaseAuth)))
        ),
        RepositoryProvider<GetCurrentUserUseCase>(
          create: (context) => GetCurrentUserUseCase(AuthRepositoryImpl(AuthRemoteDataSourceImpl(firebaseAuth)))
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              verifyPhoneUseCase: VerifyPhoneUseCase(AuthRepositoryImpl(AuthRemoteDataSourceImpl(firebaseAuth))),
              verifyOTPUseCase: VerifyOTPUseCase(AuthRepositoryImpl(AuthRemoteDataSourceImpl(firebaseAuth))),
              getCurrentUserUseCase: GetCurrentUserUseCase(AuthRepositoryImpl(AuthRemoteDataSourceImpl(firebaseAuth))),
              signOutUseCase: SignOutUseCase(AuthRepositoryImpl(AuthRemoteDataSourceImpl(firebaseAuth))),
            )..add(CheckAuthStatusEvent()),
          ),
        ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Doodle Tracker',
            themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
            theme: DoodleTheme.lightTheme,
            darkTheme: DoodleTheme.darkTheme,
            routerConfig: router,
          );
        },
      ),
    ));
  }
}
