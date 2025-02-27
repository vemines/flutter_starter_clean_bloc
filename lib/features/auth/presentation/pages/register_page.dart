import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/widget_extensions.dart';
import '../../domain/usecases/register_usecase.dart';
import '../bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes.dart';

import '../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _signUpGlobalKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordRetryController = TextEditingController();
  bool passwordSee = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_signUpGlobalKey.currentState!.validate()) {
      if (passwordController.text != passwordRetryController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Passwords don't match")));
        return;
      }

      context.read<AuthBloc>().add(
        RegisterEvent(
          params: RegisterParams(
            userName: nameController.text,
            email: emailController.text,
            password: passwordController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        // Use BlocConsumer
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.failure.message ?? 'Registration Failed')));
          } else if (state is AuthLoaded) {
            context.go(Paths.home); // Navigate to home
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            // Show registration form
            return AuthSafeWrap(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _signUpGlobalKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Icon Button
                      GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: const Icon(Icons.chevron_left, size: 40),
                      ),
                      24.sb(),
                      Text(
                        "Register account",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      30.sb(),
                      Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(hintText: "Username"),
                            validator: (value) => value!.isEmpty ? 'Please enter username' : null,
                          ),

                          16.sb(),
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(hintText: "Email"),
                            validator:
                                (value) =>
                                    value!.isEmpty || !value.contains('@')
                                        ? 'Please enter a valid email'
                                        : null,
                          ),

                          16.sb(),
                          TextFormField(
                            controller: passwordController,
                            obscureText: passwordSee,
                            decoration: InputDecoration(
                              hintText: "Password",
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  passwordSee = !passwordSee;
                                  setState(() {});
                                },
                                child: Icon(
                                  passwordSee
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                            ),
                            validator: (value) => value!.isEmpty ? 'Please enter password' : null,
                          ),

                          16.sb(),
                          TextFormField(
                            controller: passwordRetryController,
                            obscureText: passwordSee,
                            decoration: const InputDecoration(hintText: "Confirm Password"),
                            validator: (value) => value!.isEmpty ? 'Please enter password' : null,
                          ),
                          30.sb(),
                          // Sign Up for Button ----------------------------------
                          AuthActionButton(text: "Continue", onPressed: _register),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
