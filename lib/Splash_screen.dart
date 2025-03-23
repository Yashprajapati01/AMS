import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/Button.dart';
import 'components/MyTextInputField.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }


  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox( height : MediaQuery.of(context).size.width * 0.1), // Example: 10% of screen width)
                  // logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/att.png',
                        height: 40,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("MANAGEMENT",
                        style: TextStyle(
                            fontFamily: 'Gotham',
                            color: Colors.grey.shade300,
                            fontSize: 20
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("SYSTEM",
                        style: TextStyle(
                            // fontFamily: 'Gotham',
                            color: Colors.grey.shade300,
                            fontSize: 20
                        ),
                      ),
                    ],
                  ),
                  // logo ends
                  SizedBox(height: MediaQuery.of(context).size.width * 0.07),
                  Text('Welcome! Log in to view your dashboard',
                    style: TextStyle(
                        // fontFamily: 'Gotham book',
                        color: Colors.grey.shade300,
                        fontSize: 15
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.06),
                  MyTextField(hintText: 'Roll Number / Email',controller: emailController, tf: false, focusNode: null),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.03),
                  MyTextField(hintText: 'Password', controller: passController, tf: true, focusNode: null),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.040),
                  MyButton(txt: "Login", onTap: (){}),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.03),

                  // forgot password

                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                      //   );
                      },
                      child: Text("Forgot Password?",
                        style: TextStyle(
                            // fontFamily: 'Gotham',
                            color: Colors.grey.shade300,
                            fontSize: 12
                        ),
                      ),
                    )
                  ),


                  // forgot password ends here
                  SizedBox(height: MediaQuery.of(context).size.width * 0.13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a member ?",
                        style: TextStyle(
                            // fontFamily: 'Gotham book',
                            color: Colors.grey.shade300,
                            fontSize: 12
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Text(" Register Now",
                          style: TextStyle(
                              // fontFamily: 'Gotham',
                              color: Colors.grey.shade300,
                              fontSize: 12
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
