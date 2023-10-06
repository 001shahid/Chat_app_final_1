import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/modals/ChatRoomModal.dart';
import 'package:flutter_application_1/modals/firebasehelper.dart';
import 'package:flutter_application_1/modals/userModals.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/Login_page.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? currentuser = FirebaseAuth.instance.currentUser;
  if (currentuser != null) {
    UserModal? thisUserModal =
        await FirebaseHelper.getUserModalById(currentuser.uid);
    if (thisUserModal != null) {
      runApp(MyAppLoggedIn(
        userModal: thisUserModal,
        firebaseUser: currentuser,
      ));
    } else {
      runApp(const MyApp());
    }
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
// Already LoggedIn

class MyAppLoggedIn extends StatelessWidget {
  final UserModal userModal;
  final User firebaseUser;

  const MyAppLoggedIn(
      {super.key, required this.userModal, required this.firebaseUser});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(
        userModal: userModal,
        firebaseUser: firebaseUser,
      ),
    );
  }
}
