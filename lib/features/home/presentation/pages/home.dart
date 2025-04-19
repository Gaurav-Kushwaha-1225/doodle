import 'package:doodletracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:doodletracker/features/home/presentation/bloc/habit_bloc.dart';
import 'package:doodletracker/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _habitController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode habitFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Load habits for current user
    _loadHabits();
  }

  void _loadHabits() {
    // Get current user from AuthBloc
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthVerified) {
      BlocProvider.of<HabitBloc>(
        context,
      ).add(GetHabitsEvent(userId: authState.user.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doodle Tracker'),
        actions: [
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: context.watch<ThemeBloc>().state.isDark,
              onChanged: (value) {
                context.read<ThemeBloc>().add(ToggleTheme());
              },
              activeColor: Theme.of(context).colorScheme.onPrimary,
              activeTrackColor: Theme.of(context).primaryColor,
              inactiveThumbColor: Theme.of(context).colorScheme.onPrimary,
              inactiveTrackColor: Theme.of(
                context,
              ).colorScheme.scrim.withValues(alpha: 0.5),
              trackOutlineColor: const WidgetStatePropertyAll(
                Colors.transparent,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, authState) {
          print(authState);
          if (authState is AuthLoggedOut) {
            GoRouter.of(context).pushReplacement('/login');
          }
        },
        builder: (context, authState) {
          print(authState);
          if (authState is AuthVerified) {
            return BlocConsumer<HabitBloc, HabitState>(
              listener: (context, habitState) {
                if (habitState is HabitError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(habitState.message)));
                } else if (habitState is HabitAdded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Habit added successfully!')),
                  );
                  _habitController.clear();
                }
              },
              builder: (context, habitState) {
                if (habitState is HabitsLoaded) {
                  final habits = habitState.habits;

                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Theme.of(context).primaryColor.withAlpha(50),
                        child: Column(
                          children: [
                            // CircleAvatar(
                            //   radius: 40,
                            //   backgroundColor: Theme.of(context).primaryColor,
                            //   child: Text(
                            //     authState.user.phoneNumber?.substring(
                            //           authState.user.phoneNumber!.length - 2,
                            //         ) ??
                            //         'U',
                            //     style: const TextStyle(
                            //       fontSize: 28,
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(height: 8),
                            Text(
                              'Current User : ${authState.user.phoneNumber}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 16),
                            // Daily progress
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularPercentIndicator(
                                  radius: 40.0,
                                  lineWidth: 8.0,
                                  percent:
                                      habits.isEmpty
                                          ? 0.0
                                          : habits
                                                  .where(
                                                    (h) => h.isCompletedToday(),
                                                  )
                                                  .length /
                                              habits.length,
                                  center: Text(
                                    '${habits.where((h) => h.isCompletedToday()).length}/${habits.length}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  progressColor: Colors.green,
                                  backgroundColor:
                                      Theme.of(context).brightness ==
                                              ThemeMode.light
                                          ? Colors.grey.shade900
                                          : Colors.grey.shade300,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  animation: true,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Today\'s\nProgress',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Add new habit section
                      if (habits.length < 5) // Limit to 5 habits
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Form(
                            key: _formKey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    autofocus: false,
                                    focusNode: habitFocusNode,
                                    onTapOutside: (event) {
                                      habitFocusNode.unfocus();
                                    },
                                    controller: _habitController,
                                    cursorColor: Theme.of(context).primaryColor,
                                    validator: (value) {
                                      if (value == null || value == "") {
                                        return 'Please enter the habbit';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.text,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                    decoration: InputDecoration(
                                      prefix: Padding(
                                        padding: const EdgeInsets.only(left: 15),
                                      ),
                                      errorStyle: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.copyWith(
                                        color:
                                            Theme.of(context).colorScheme.onError,
                                        fontSize: 13,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Theme.of(context).colorScheme.scrim,
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        gapPadding: 24,
                                      ),
                                      hintText: 'Ex: Read for 30 minutes',
                                      hintStyle: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.scrim.withAlpha(150),
                                      ),
                                      labelStyle: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.scrim.withAlpha(150),
                                      ),
                                      fillColor: Theme.of(context).cardColor,
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 2,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        gapPadding: 24,
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onError,
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        gapPadding: 24,
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onError,
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        gapPadding: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  height: 53,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<HabitBloc>().add(
                                          AddHabitEvent(
                                            name: _habitController.text,
                                            userId: authState.user.uid,
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      shadowColor:
                                          Theme.of(context).colorScheme.scrim,
                                    ),
                                    child: Text(
                                      "+",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (habits.length >= 5)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Maximum of 5 habits reached',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(color: Colors.red[700]),
                          ),
                        ),

                      // Habits list
                      Expanded(
                        child:
                            habits.isEmpty
                                ? Center(
                                  child: Text(
                                    'No habits added yet. Start adding some!',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                )
                                : ListView.builder(
                                  itemCount: habits.length,
                                  itemBuilder: (context, index) {
                                    final habit = habits[index];
                                    final isCompleted =
                                        habit.isCompletedToday();
                                    final streak = habit.getStreak();

                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 15.0,
                                        vertical: 8.0,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Checkbox(
                                              value: isCompleted,
                                              onChanged: (value) {
                                                if (!isCompleted) {
                                                  context.read<HabitBloc>().add(
                                                    MarkHabitCompletedEvent(
                                                      habitId: habit.id,
                                                      userId: authState.user.uid
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    ' ${habit.name}',
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.bodyLarge!.copyWith(
                                                      color:
                                                          isCompleted
                                                              ? Colors.orange
                                                              : Theme.of(context).colorScheme.onSurface,
                                                        decorationStyle: TextDecorationStyle.solid,
                                                        decorationThickness: 2.0
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      // Display streak flames
                                                      Row(
                                                        children: List.generate(
                                                          7, // 7-day streak
                                                          (i) => Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 2),
                                                            child: Icon(
                                                              i < streak
                                                                  ? Icons
                                                                      .local_fire_department
                                                                  : Icons
                                                                      .local_fire_department_outlined,
                                                              color:
                                                                  i < streak
                                                                      ? Colors
                                                                          .orange
                                                                      : Colors
                                                                          .grey[400],
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    ' $streak day streak',
                                                    style: TextStyle(
                                                      color:
                                                          streak > 0
                                                              ? Colors
                                                                  .orange[700]
                                                              : Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete_rounded,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                // Show confirmation dialog
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (context) => AlertDialog(
                                                        title: Text(
                                                          'Delete Habit',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge,
                                                        ),
                                                        content: Text(
                                                          'Are you sure you want to delete "${habit.name}"?',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed:
                                                                () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                    ),
                                                            child: Text(
                                                              'Cancel',
                                                              style:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .textTheme
                                                                      .bodyMedium,
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                context,
                                                              );
                                                              context.read<HabitBloc>().add(
                                                                DeleteHabitEvent(
                                                                  habitId:
                                                                      habit.id,
                                                                  userId:
                                                                      authState
                                                                          .user
                                                                          .uid,
                                                                ),
                                                              );
                                                            },
                                                            child: Text(
                                                              'Delete',
                                                              style: Theme.of(
                                                                    context,
                                                                  )
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                    color:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                      SizedBox(
                        height: 15,
                      )
                    ],
                  );
                }

                // Loading state or other states
                return const Center(child: CircularProgressIndicator());
              },
            );
          }

          // Handle other auth states
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
