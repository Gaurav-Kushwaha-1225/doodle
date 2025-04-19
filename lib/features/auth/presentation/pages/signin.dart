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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Authentication'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          print(state.toString());
          if (state is AuthCodeSent) {
            GoRouter.of(context).pushNamed('otp_verify',
                pathParameters: {'id': jsonEncode(state.verificationId)});
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthVerified) {
            GoRouter.of(context).pushReplacement('/home');
          }
        },
        builder: (context, state) {
          print(state.toString());
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: '234 567 8900',
                      prefixText: '+91',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                BlocProvider.of<AuthBloc>(context).add(
                                      VerifyPhoneNumberEvent(
                                        phoneNumber:
                                            _phoneController.text.trim(),
                                      ),
                                    );
                              }
                            },
                      child: state is AuthLoading
                          ? const CircularProgressIndicator()
                          : const Text('Send OTP'),
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
