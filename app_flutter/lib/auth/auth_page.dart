import 'package:flutter/material.dart';
import 'package:vibe_flutter/auth/login_page.dart';

import 'package:vibe_flutter/auth/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // mostra login page all inizio

  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

// gestion toggle, per il tocco sotto login button e registration button
  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
          showRegisterPage:
              toggleScreens); // qui la prima volta show register page é false, quindi va nel login, finché non clicco su 'register here'
    } else {
      return Register(
          showLoginPage:
              toggleScreens); // cliccando sul tasto registra va nella pagina registra
    }
  }
}
