import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibe_flutter/auth/register_page.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? Key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>(); //key la uso nella form
  // uso dei text controllers per i campi di input che utente dovrà inserire

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isPasswordVisible = true;

// autenticazione login la facciamo con mail e pass
  Future signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (error) {
      var errorMessage = '';
      if (error.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (error.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      }
      print(errorMessage);
      errorEmail(errorMessage);
    }
  }

  String? errorMessage = "";

  void errorEmail(String? error) {
    setState(() {
      errorMessage = error;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent[300],
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 130),
              Text(
                ' Search Events',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 49,
                  color: Color(0xFF1D7120),
                ),
              ),

              SizedBox(height: 180),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF3FCF44),
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                      validator: validateEmail,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // campo per la password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF3FCF44),
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextFormField(
                      controller: _passwordController,
                      validator: validatePassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: isPasswordVisible
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                          onPressed: () => setState(
                              () => isPasswordVisible = !isPasswordVisible),
                        ),
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                      obscureText: isPasswordVisible,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Center(
                child: Text(
                  errorMessage.toString(),
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SizedBox(height: 60),

              //  bottone legato al signin

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: GestureDetector(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      signIn();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color(0xFF3FCF44),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        'Login',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // se utente non è registrato
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not have an account?'),
                  GestureDetector(
                    onTap: widget.showRegisterPage,
                    child: Text(
                      'Register here',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
              //struttura della schermata è come segue nei commenti sottostanti
            // email

            // pass

            // login

            // non hhai aaccount-->registrati qui
          ),
        ),
      ),
    );
  }
}
//qui usiamo regole di validazione simili a quelle per app nativa android
String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return "Email address is required.";
  }
  String pattern = r'\w+@\w+\.\w+'; // serve per indicare  la chiocciola--->mi serve per avere una "vera" mail perchè deve mettere per forza na chiocciola
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) {
    return "Email missing @!";
  }
  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) {
    return " Password is required.";
  }
  if (formPassword.length < 6) {
    return "Password must have at least 6 charachters.";
  }
  return null;
}
