import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/utils/theme.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/screens/login_screen.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  final AuthRepositoryImpl authRepository = AuthRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => authRepository,
      child: BlocProvider(
        create: (context) => AuthBloc(authRepository: RepositoryProvider.of<AuthRepositoryImpl>(context)),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Attendance Management',
          theme: lightTheme,
          darkTheme: darkTheme,
          home: const LoginScreen(),
        ),
      ),
    );
  }
}
