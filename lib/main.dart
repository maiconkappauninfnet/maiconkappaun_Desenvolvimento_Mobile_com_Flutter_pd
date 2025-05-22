import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/cadastro_usuario_page.dart';
import 'package:flutter_application_2/pages/dashboard_page.dart';
import 'package:flutter_application_2/pages/login_page.dart';
import 'package:flutter_application_2/pages/tarefa_page.dart';
import 'package:flutter_application_2/providers/auth_provider.dart';
import 'package:flutter_application_2/providers/tarefas_provider.dart';
import 'package:flutter_application_2/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => TarefasProvider()),
      ],
      child: MaterialApp(
        title: 'To Do do Maicon',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 45, 59, 56)),
        ),
        // home: LoginPage(),
        routes: {
          Routes.LOGIN: (context) => LoginPage(),
          Routes.DASHBOARD: (context) => DashboardPage(),
          Routes.TAREFA: (context) => TarefaPage(),
          Routes.CADASTRO_USUARIO: (context) => CadastroUsuarioPage (),
        },
      ),
    );
  }
}