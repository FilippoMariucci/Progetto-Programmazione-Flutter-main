import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/ui/firebase_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vibe_flutter/main.dart';
import 'package:vibe_flutter/widget/textfield_widget.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late final User? user;
  late Query _ref;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  late Map utente;

  String? name;
  String? surname;
  String? birth;
  String? description;
  String? password;
  String? state;
  String? full_name;

  late Map userdata;

  late var data;
  @override
  void initState() {
    print(uid.toString());
    StreamSubscription<DatabaseEvent> reference = FirebaseDatabase.instance
        .ref()
        .child("Users")
        .child(uid.toString())
        .onValue
        .listen((DatabaseEvent event) {
      data = event.snapshot.value as Map;
      //print(data['name']);

      setState(() {
        Update(data);
      });
    });

    print(name);

    super.initState();
  }

  late var namecontroller;
  void Update(Map utente) async {
    name = utente['name'];
    surname = utente['surname'];
    birth = utente['birth'];
    description = utente['description'];
    state = utente['state'];

    full_name = name! + " " + surname!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF3FCF44),
        elevation: 22,
        shadowColor: Color(0xFF3FCF44),
        brightness: Brightness.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(150),
              bottomRight: Radius.circular(150)),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(150),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Bentornato,",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60.0),
                child: Text(
                  name.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: Icon(Icons.logout))
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 50),
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(
            height: 85,
          ),
          TextFieldWidget(
            label: "Full name:",
          ),
          Text(
            full_name.toString(),
            style: TextStyle(
              fontSize: 19,
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          TextFieldWidget(label: "Date of birth:"),
          Text(
            birth.toString(),
          ),
          const SizedBox(
            height: 35,
          ),
          TextFieldWidget(label: "State:"),
          Text(
            state.toString(),
          ),
          const SizedBox(
            height: 35,
          ),
          TextFieldWidget(label: "Description:"),
          Text(
            description.toString(),
          )
        ],
      ),
    );
  }
}
