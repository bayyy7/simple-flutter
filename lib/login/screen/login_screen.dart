import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/login/cubit/login_cubit.dart';
import 'package:flutter_application_3/login/screen/login_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 
                MediaQuery.of(context).padding.top,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: BlocProvider<LoginCubit>(
              create: (context) {
                return LoginCubit(
                  authRepository: RepositoryProvider.of<AuthRepository>(context),
                );
              },
              child: const LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}