import 'package:flutter/material.dart';
import 'package:vibe_flutter/auth/login_page.dart';

import 'package:vibe_flutter/auth/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // mostra la login page all inizio

  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

// gestion toggle lo uso per tocco utente legato ai bottoni login e register
  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
          showRegisterPage:
              toggleScreens); // la prima volta "show register page" é false e pertanto va a login  fino a quando non clicco su register
    } else {
      return Register(
          showLoginPage:
              toggleScreens); // cliccando sul tasto registra va nella pagina per effettuare la registrazione
    }
  }
}
