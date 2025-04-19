import 'dart:convert';

import 'package:doodletracker/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FocusNode phoneNumberFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Authentication'),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthCodeSent) {
            GoRouter.of(context).pushNamed(
              'otp_verify',
              pathParameters: {'id': jsonEncode(state.verificationId)},
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthVerified) {
            GoRouter.of(context).pushReplacement('/home');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    autofocus: false,
                    focusNode: phoneNumberFocus,
                    onTapOutside: (event) {
                      phoneNumberFocus.unfocus();
                    },
                    controller: _phoneController,
                    cursorColor: Theme.of(context).primaryColor,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    autovalidateMode: AutovalidateMode.disabled,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                      prefixText: '+91',
                      prefixStyle: Theme.of(context).textTheme.bodyLarge,
                      errorStyle: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onError,
                        fontSize: 13,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.scrim,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        gapPadding: 24,
                      ),
                      prefixIcon: Icon(
                        Icons.mobile_friendly_rounded,
                        color:
                            phoneNumberFocus.hasFocus
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).colorScheme.scrim,
                        size: 22,
                      ),
                      hintText: "+91 457 896 3215",
                      hintStyle: Theme.of(
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
                          color: Theme.of(context).colorScheme.onError,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        gapPadding: 24,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onError,
                          width: 1,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        gapPadding: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          state is AuthLoading
                              ? null
                              : () {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<AuthBloc>(context).add(
                                    VerifyPhoneNumberEvent(
                                      phoneNumber:
                                          '+91${_phoneController.text.trim()}',
                                    ),
                                  );
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: Theme.of(context).colorScheme.scrim,
                      ),
                      child:
                          state is AuthLoading
                              ? SizedBox(
                                height: 30,
                                width: 30,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                              : Text(
                                'Send OTP',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
