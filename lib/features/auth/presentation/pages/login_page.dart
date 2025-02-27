import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/build_content_extensions.dart';
import '../../../../core/extensions/widget_extensions.dart';
import '../../domain/usecases/login_usecase.dart';
import '../bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(
          params: LoginParams(
            username: _usernameController.text,
            password: _passwordController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.failure.message ?? 'Login Failed')));
          } else if (state is AuthLoaded) {
            context.go(Paths.home);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            // Show login form
            return AuthSafeWrap(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Welcome back!\nSign in to continue!",
                          textAlign: TextAlign.center,
                          style: context.textTheme.headlineMedium,
                        ),
                      ),
                      36.sb(),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(labelText: 'Username'),
                        validator: (value) => value!.isEmpty ? 'Please enter username' : null,
                      ),
                      16.sb(),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) => value!.isEmpty ? 'Please enter password' : null,
                      ),
                      24.sb(),
                      AuthActionButton(text: "Log in", onPressed: _login),
                      12.sb(),
                      Text(
                        "-----Or-----",
                        style: context.textTheme.titleMedium!.copyWith(
                          color: context.colorScheme.onSecondaryContainer,
                        ),
                      ),
                      12.sb(),
                      SocialSignin(
                        icon: Image.asset("assets/images/ic-google.png", width: 30),
                        text: "Log in with Google",
                      ),
                      20.sb(),
                      SocialSignin(
                        icon: Image.asset("assets/images/ic-facebook.png", width: 30),
                        text: "Log in with Google",
                      ),

                      24.sb(),
                      TextButton(
                        onPressed: () => context.push(Paths.register),
                        child: const Text(
                          "Not have account, register here.",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Color(0xFF265AE8),
                          ),
                        ),
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
