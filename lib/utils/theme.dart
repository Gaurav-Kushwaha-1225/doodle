import 'package:bloc/bloc.dart';
import 'package:doodletracker/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// enum CurrentTheme { dark, light }

class DoodleTheme {
  DoodleTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: Constants.primaryLight,
    scaffoldBackgroundColor: Constants.scaffoldBackgroundColorLight,
    textTheme: TextTheme(
      titleLarge: GoogleFonts.openSans(color: Constants.textColorActiveLight),
      titleMedium: GoogleFonts.openSans(
        color: Constants.textColorActiveLight,
      ),
      labelSmall: GoogleFonts.openSans(color: Constants.textColorActiveLight),
      bodyMedium: GoogleFonts.openSans(color: Constants.textColorActiveLight),
      bodySmall: GoogleFonts.openSans(color: Constants.textColorActiveLight),
    ),
    cardColor: Constants.cardLight,
    hoverColor: Constants.primaryLight,
    splashColor: Constants.scaffoldBackgroundColorLight,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Constants.primaryLight,
      onPrimary: Colors.white,
      secondary: Constants.scaffoldBackgroundColorLight,
      onSecondary: Constants.cardLight,
      error: Constants.errorLight.withAlpha(100),
      onError: Constants.errorLight,
      surface: Constants.cardLight,
      onSurface: Constants.textColorActiveLight,
      scrim: Constants.textColorInactiveLight,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    primaryColor: Constants.primaryDark,
    scaffoldBackgroundColor: Constants.scaffoldBackgroundColorDark,
    textTheme: TextTheme(
      titleLarge: GoogleFonts.openSans(color: Constants.textColorActiveDark),
      titleMedium: GoogleFonts.openSans(color: Constants.textColorActiveDark),
      labelSmall: GoogleFonts.openSans(color: Constants.textColorActiveDark),
      bodyMedium: GoogleFonts.openSans(color: Constants.textColorActiveDark),
      bodySmall: GoogleFonts.openSans(color: Constants.textColorActiveDark),
    ),
    cardColor: Constants.cardDark,
    hoverColor: Constants.primaryDark,
    splashColor: Constants.scaffoldBackgroundColorDark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Constants.primaryDark,
      onPrimary: Colors.white,
      secondary: Constants.scaffoldBackgroundColorDark,
      onSecondary: Constants.cardDark,
      error: Constants.errorDark.withAlpha(100),
      onError: Constants.errorDark,
      surface: Constants.cardDark,
      onSurface: Constants.textColorActiveDark,
      scrim: Constants.textColorInactiveDark,
    ),
  );
}

// Events
abstract class ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

class InitializeTheme extends ThemeEvent {}

// States
class ThemeState {
  final bool isDark;
  ThemeState({required this.isDark});
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences storage;

  ThemeBloc({required this.storage}) : super(ThemeState(isDark: false)) {
    on<ToggleTheme>((event, emit) async {
      final newIsDark = !state.isDark;
      await storage.setBool('isDark', newIsDark);
      emit(ThemeState(isDark: newIsDark));
    });

    on<InitializeTheme>((event, emit) async {
      final isDark = (await storage.getBool('isDark') ?? false);
      emit(ThemeState(isDark: isDark));
    });
  }

  void loadSavedTheme() {
    add(InitializeTheme());
  }
}
