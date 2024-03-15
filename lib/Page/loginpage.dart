import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_top.dart';
import 'package:watalygold_admin/firebase_auth_implementation/firebase_auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/WatalyGold.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const MenuTop(
              numpage: 1,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: WhiteColor,
              ),
              width: MediaQuery.of(context).size.width * 0.4,
              margin: const EdgeInsets.all(30),
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ยินดีต้อนรับ",
                      style: TextStyle(fontSize: 30, color: G2PrimaryColor),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "เข้าสู่ระบบ Wataly ",
                            style:
                                TextStyle(fontSize: 30, color: G2PrimaryColor),
                          ),
                          TextSpan(
                            text: "Gold",
                            style:
                                TextStyle(fontSize: 30, color: YPrimaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 600,
                    margin: const EdgeInsetsDirectional.only(top: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "อีเมล",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                hintText: "อีเมล",
                                fillColor:
                                    const Color(0xFFD9D9D9).withOpacity(0.29),
                                filled: true,
                                labelStyle: const TextStyle(fontSize: 20)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 600,
                    margin: const EdgeInsetsDirectional.only(top: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "รหัสผ่าน",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: "รหัสผ่าน",
                              fillColor:
                                  const Color(0xFFD9D9D9).withOpacity(0.29),
                              filled: true,
                              labelStyle: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 300,
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          _login();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: G2PrimaryColor,
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Center(
                              child: Text(
                            "เข้าสู่ระบบ",
                            style: const TextStyle(color: WhiteColor),
                          )),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("ถ้าหากคุณยังไม่มีบัญชี"),
                      TextButton(
                          onPressed: () {
                            context.goNamed('/register');
                          },
                          child: const Text(
                            "สมัครสมาชิก",
                            style: TextStyle(
                                color: G2PrimaryColor,
                                decoration: TextDecoration.underline,
                                decorationColor: G2PrimaryColor),
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.LoginWithEmailandPassword(email, password);

    if (user != null) {
      context.goNamed('/dashborad');
    } else {
      print("error someting");
    }
  }
}

class Input_string extends StatelessWidget {
  const Input_string({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  hintText: name,
                  fillColor: const Color(0xFFD9D9D9).withOpacity(0.29),
                  filled: true,
                  labelStyle: const TextStyle(fontSize: 20)),
            )
          ],
        ),
      ),
    );
  }
}

class Input_Int extends StatelessWidget {
  const Input_Int({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  hintText: name,
                  fillColor: const Color(0xFFD9D9D9).withOpacity(0.29),
                  filled: true,
                  labelStyle: const TextStyle(fontSize: 20)),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget buttonall({required String name, bool isActive = false}) {
  return Container(
    width: 300,
    margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
          backgroundColor: G2PrimaryColor,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(10))),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Center(
            child: Text(
          name,
          style: const TextStyle(color: WhiteColor),
        )),
      ),
    ),
  );
}
