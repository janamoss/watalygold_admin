import 'package:another_flushbar/flushbar.dart';
import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_top.dart';
import 'package:watalygold_admin/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:watalygold_admin/service/flushbar_uit.dart';
import 'package:watalygold_admin/service/screen_unit.dart';

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  final logger = Logger();

  bool _obscureText = true;
  bool _obscureText2 = true;

  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordenterController =
      TextEditingController();
  final TextEditingController _FnameController = TextEditingController();
  final TextEditingController _LnameController = TextEditingController();
  final TextEditingController _phonenumberController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _passwordenterError;
  String? _fnameError;
  String? _lnameError;
  String? _phonenumberError;
  String? _passwordpassError;

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

  Future<void> createCollectionAdmin(String email, String encryptedPassword,
      String firstName, String lastName, String phoneNumber) async {
    final adminData = {
      "email": email,
      "password": encryptedPassword,
      "admin_name": "$firstName $lastName",
      "phone_number": phoneNumber,
      "create_at": DateTime.timestamp(),
      "update_at": null,
      "delete_at": null,
    };

    await FirebaseFirestore.instance.collection('Admin').doc().set(adminData);
  }

  static EncryptAES(text) async {
    final key = encrypt.Key.fromUtf8('my 32 length key................');
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted;
  }

  Widget build(BuildContext context) {
    ScreenSize screenSize = getScreenSize(context);
    return Scaffold(
      drawer: screenSize == ScreenSize.minidesktop
          ? SizedBox(
              width: 300,
              child: Menutop_darwer(
                numpage: 0,
              ),
            )
          : null,
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
                width: screenSize == ScreenSize.minidesktop
                    ? MediaQuery.of(context).size.width
                    : MediaQuery.of(context).size.width * 0.4,
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
                        style: TextStyle(fontSize: 30, color: GPrimaryColor),
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
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      hintText: "ชื่อ",
                                      fillColor: const Color(0xFFD9D9D9)
                                          .withOpacity(0.29),
                                      filled: true,
                                      labelStyle: const TextStyle(fontSize: 20),
                                      errorText: _fnameError,
                                    ),
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
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      hintText: "นามสกุล",
                                      fillColor: const Color(0xFFD9D9D9)
                                          .withOpacity(0.29),
                                      filled: true,
                                      labelStyle: const TextStyle(fontSize: 20),
                                      errorText: _lnameError,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(
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
                                  labelStyle: const TextStyle(fontSize: 20),
                                  errorText: _emailError,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
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
                                  labelStyle: const TextStyle(fontSize: 20),
                                  errorText: _phonenumberError,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
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
                                  errorText: _passwordError,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
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
                                  errorText:
                                      _passwordenterError ?? _passwordpassError,
                                ),
                              ),
                            ],
                          ),
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
                          onPressed: () async {
                            _register();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: GPrimaryColor,
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

  bool _isValidEmail(String email) {
    // รูปแบบของอีเมลที่ใช้ regex สำหรับตรวจสอบ
    final RegExp regex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  void _register() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String passwordenter = _passwordenterController.text;
    String fname = _FnameController.text;
    String lanme = _LnameController.text;
    String phonenumber = _phonenumberController.text;

    setState(() {
      _emailError = email.isEmpty
          ? 'กรุณากรอกอีเมล'
          : !_isValidEmail(email)
              ? 'รูปแบบอีเมลไม่ถูกต้อง'
              : null; // ตรวจสอบอีเมล
      _passwordError =
          password.isEmpty ? 'กรุณากรอกรหัสผ่าน' : null; // ตรวจสอบรหัสผ่าน
      _passwordenterError =
          passwordenter.isEmpty ? 'กรุณากรอกยืนยันรหัสผ่าน' : null;
      _fnameError = fname.isEmpty ? 'กรุณากรอกชื่อผู้ใช้งาน' : null;
      _lnameError = lanme.isEmpty ? 'กรุณากรอกนามสกุลผู้ใช้งาน' : null;
      _phonenumberError = phonenumber.isEmpty ? 'กรุณากรอกเบอร์โทรศัพท์' : null;
      _passwordpassError =
          password != passwordenter ? 'รหัสผ่านไม่ตรงกัน' : null;
    });

    if (_emailError == null &&
        _passwordError == null &&
        _passwordenterError == null &&
        _fnameError == null &&
        _lnameError == null &&
        _phonenumberError == null &&
        _passwordpassError == null) {
      final future = EncryptAES(password);
      final encrypted = await future;
      await createCollectionAdmin(
          _emailController.text,
          encrypted.base64.toString(),
          _FnameController.text,
          _LnameController.text,
          _phonenumberController.text);
      try {
      User? user = await _auth.RegisterWithEmailandPassword(
        email, password, "${_FnameController.text} ${_LnameController.text}");
      logger.d(user?.uid);
      
      if (user != null) {
        context.goNamed(
          '/login',
          extra: {
            'showSuccessFlushbar': true,
            'message': "สมัครสมาชิกเสร็จสิ้น",
            'description': "คุณได้ทำการสมัครสมาชิกเสร็จสิ้นเรียบร้อย"
          },
        );
        debugPrint("สมัครเสร็จสิ้นแล้ว");
      }
    } catch (e) {
      // เมื่อเกิดข้อผิดพลาด ให้แสดง Flushbar ด้วยข้อความที่ได้รับ
      showErrorFlushbar(context,"สมัครสมาชิกล้มเหลว", e.toString());
    }
    }
  }

}
