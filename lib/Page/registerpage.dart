import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watalygold_admin/Page/loginpage.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_top.dart';
import 'package:watalygold_admin/firebase_auth_implementation/firebase_auth_services.dart';

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  bool _obscureText = true;
  bool _obscureText2 = true;

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordenterController = TextEditingController();
  TextEditingController _FnameController = TextEditingController();
  TextEditingController _LnameController = TextEditingController();
  TextEditingController _phonenumberController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordenterController.dispose();
    _FnameController.dispose();
    _LnameController.dispose();
    _phonenumberController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/WatalyGold.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const MenuTop(
                numpage: 0,
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
                        "สร้างบัญชี",
                        style:
                            TextStyle(fontSize: 30, color: Color(0xFF7ED957)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Container(
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
                                      "ชื่อ",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  TextField(
                                    controller: _FnameController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        hintText: "ชื่อ",
                                        fillColor: const Color(0xFFD9D9D9)
                                            .withOpacity(0.29),
                                        filled: true,
                                        labelStyle:
                                            const TextStyle(fontSize: 20)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
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
                                      "นามสกุล",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  TextField(
                                    controller: _LnameController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        hintText: "นามสกุล",
                                        fillColor: const Color(0xFFD9D9D9)
                                            .withOpacity(0.29),
                                        filled: true,
                                        labelStyle:
                                            const TextStyle(fontSize: 20)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
                                "เบอร์โทรศัพท์",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            TextField(
                              controller: _phonenumberController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  hintText: "เบอร์โทรศัพท์",
                                  fillColor:
                                      const Color(0xFFD9D9D9).withOpacity(0.29),
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
                                "ยืนยันรหัสผ่าน",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            TextField(
                              controller: _passwordenterController,
                              obscureText: _obscureText2,
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
                                      _obscureText2 = !_obscureText2;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureText2
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
                            if (_passwordController.text ==
                                _passwordenterController.text) {
                              _register();
                            } else {
                              _showwrongpass();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7ED957),
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Center(
                                child: Text(
                              "สมัครสมาชิก",
                              style: const TextStyle(color: WhiteColor),
                            )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showwrongpass() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("รหัสผ่านไม่ตรงกัน"),
          content: const Text("กรุณากรอกรหัสผ่านใหม่อีกครั้ง"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("ตกลง"),
            ),
          ],
        );
      },
    );
  }

  void _register() async {
    String name = "${_FnameController.text} ${_LnameController.text}";
    String phonenumber = _phonenumberController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.RegisterWithEmailandPassword(email, password);

    if (user != null) {
      Navigator.pushNamed(context, "/login");
    } else {
      print("error someting");
    }
  }
}
