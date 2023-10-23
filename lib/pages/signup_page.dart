import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:provider/provider.dart';
import 'package:task_master/pages/home_page.dart';
import 'package:task_master/pages/signin_page.dart';
import 'package:task_master/services/auth_class.dart';
import 'package:task_master/widgets/button_item.dart';
import 'package:task_master/widgets/text_item.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool circular = false;
  Authentication authClass = Authentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Provider.of<Authentication>(context, listen: false)
                      .googleSignin()
                      .whenComplete(
                        () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        ),
                      );
                },
                child: const ButtonItem(
                  imagePath: "assets/google.svg",
                  text: "Continue with Google",
                  size: 25,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const Text(
                "Or",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(
                height: 18,
              ),
              GestureDetector(
                child: TextItem(
                    labelText: "Email....",
                    controller: _emailController,
                    obscureText: false),
              ),
              const SizedBox(
                height: 15,
              ),
              TextItem(
                  labelText: "Password...",
                  controller: _pwdController,
                  obscureText: true),
              const SizedBox(
                height: 40,
              ),
              colorButton(),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "If you alredy have an Account? ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => const SignInPage()),
                          (route) => false);
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget colorButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
        try {
          Provider.of<Authentication>(context, listen: false)
              .createAccount(_emailController.text, _pwdController.text);
          // firebase_auth.UserCredential userCredential =
          //     await firebaseAuth.createUserWithEmailAndPassword(
          //         email: _emailController.text, password: _pwdController.text);
          // print(userCredential.user);
          // setState(() {
          //   circular = false;
          // });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (builder) => const HomePage(),
              ),
              (route) => false);
        } catch (e) {
          final snackbar = SnackBar(
            content: Text(
              e.toString(),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(colors: [
            Color(0xfffd746c),
            Color(0xffff9068),
            Color(0xfffd746c)
          ]),
        ),
        child: Center(
          child: circular
              ? const CircularProgressIndicator()
              : const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
        ),
      ),
    );
  }
}
