import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Register extends StatefulWidget {
  final VoidCallback showLoginPage;

  const Register({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>(); //key for form
  String name = "";
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _stateController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();

  final databaseRef = FirebaseDatabase.instance.ref();
  bool isPasswordVisible = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _stateController.dispose();
    _confirmPasswordController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  bool checkFields(String email, String password, String name, String surname,
      String confirmPassw, String date) {
    if (email.isEmpty) {
      return false;
    }

    if (password.isEmpty) {
      return false;
    }

    if (name.isEmpty) {
      return false;
    }

    if (surname.isEmpty) {
      return false;
    }

    if (confirmPassw.isEmpty) {
      return false;
    }

    if (date.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  late UserCredential usercred;

  Future signUp() async {
    var email = _emailController.text.trim();
    var password = _passwordController.text.trim();
    var name = _nameController.text.trim();
    var surname = _surnameController.text.trim();
    var confirmPassword = _confirmPasswordController.text.trim();
    var state = _stateController.text.trim();
    var birth = _dateController.text.trim();
    var description = _descriptionController.text.trim();

    var check =
        checkFields(name, surname, email, password, confirmPassword, birth);

    FirebaseAuth auth = FirebaseAuth.instance;
    //

    if (check && passwordConfirmed()) {
      try {
        usercred = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // aggiungi dettagli utente
        addUserDetails(name, surname, password, state, birth, description);
      } on FirebaseAuthException catch (error) {
        var errorMessage = error.message;
        errorEmail(errorMessage);
      }
    }
  }

  String? errorMessage = "";

  void errorEmail(String? error) {
    setState(() {
      errorMessage = error;
    });
  }

  Future addUserDetails(String name, String surname, String password,
      String state, String birth, String description) async {
    String? uid = usercred.user?.uid;
    await databaseRef.child('Users').child(uid.toString()).set({
      'name': name,
      'surname': surname,
      'password': password,
      'state': state,
      'birth': birth,
      'description': description,
    });
  }

  var validateConfirm = true;

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text(
                "Registration",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 49,
                    color: Color(0xFF3FCF44)),
              ),
              SizedBox(height: 85),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Enter your email"),
                  validator: validateEmail,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Enter your name"),
                  validator: validateName,
                ),
              ),

              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: _surnameController,
                  decoration: InputDecoration(labelText: "Enter your surname"),
                  validator: validateSurname,
                ),
              ),

              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: _passwordController,
                  validator: validatePassword,
                  decoration: InputDecoration(
                    labelText: "Enter your password",
                    suffixIcon: IconButton(
                      icon: isPasswordVisible
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                      onPressed: () => setState(
                          () => isPasswordVisible = !isPasswordVisible),
                    ),
                  ),
                  obscureText: isPasswordVisible,
                ),
              ),

              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  validator: (val) {
                    if (val == null || val != _passwordController.text) {
                      return "Password doesn't match";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Confirm your password",
                    suffixIcon: IconButton(
                      icon: isPasswordVisible
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                      onPressed: () => setState(
                          () => isPasswordVisible = !isPasswordVisible),
                    ),
                  ),
                  obscureText: isPasswordVisible,
                ),
              ),

              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: _stateController,
                  decoration: InputDecoration(labelText: "Enter your state"),
                ),
              ),

              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  keyboardType: TextInputType.datetime,
                  controller: _dateController,
                  decoration:
                      InputDecoration(labelText: "Enter your date of birth"),
                  validator: validateBirth,
                ),
              ),

              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration:
                      InputDecoration(labelText: "Enter your description"),
                ),
              ),

              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: GestureDetector(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      signUp();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color(0xFF3FCF44),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        'Registrati',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // not registered?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('I am registered! '),
                  GestureDetector(
                    onTap: widget.showLoginPage,
                    child: Text(
                      'Login here',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return "Email address is required.";
  }
  String pattern = r'\w+@\w+\.\w+'; // indica la chiocciola
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) {
    return "Email missing @!";
  }
  return null;
}

String? validateName(String? formName) {
  if (formName == null || formName.isEmpty) {
    return " Name is required.";
  }
  return null;
}

String? validateSurname(String? formSurname) {
  if (formSurname == null || formSurname.isEmpty) {
    return " Surname is required.";
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

String? validateBirth(String? formBirth) {
  DateTime dateTime = DateTime.parse(formBirth.toString());

  if (formBirth == null || formBirth.isEmpty) {
    return " Date of birth is required.";
  }
}
