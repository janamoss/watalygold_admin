
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/service/screen_unit.dart';

class MenuTop extends StatefulWidget {
  const MenuTop({super.key, required this.numpage});

  final int numpage;
  @override
  State<MenuTop> createState() => _MenuTopState();
}

class _MenuTopState extends State<MenuTop> {
  int _activeIndex = 1;

  void _handleTapItem(int index) {
    setState(() {
      _activeIndex = index;
    });

    if (index == 0) {
      context.goNamed('/register');
    }
    if (index == 1) {
      context.goNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize screenSize = getScreenSize(context);

    if (screenSize == ScreenSize.minidesktop) {
      return Container(
        color: Color(0xFFF7F7F7),
        width: MediaQuery.of(context).size.width,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.menu_rounded,
                    color: GPrimaryColor,
                    size: 45,
                  ),
                ),
              )),
        ),
      );
    } else {
      return Container(
        color: Color(0xFFF7F7F7),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: screenSize == ScreenSize.minidesktop
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Image.asset(
                        'assets/images/watalygold-logo.png',
                        fit: BoxFit.cover,
                        width: 260,
                        height: 85,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _menutopItem(
                            title: 'สมัครสมาชิก',
                            index: 0,
                            isActive: widget.numpage == 0,
                            onTap: () => _handleTapItem(0),
                            status: 0),
                        SizedBox(
                          height: 20,
                        ),
                        _menutopItem(
                            title: 'เข้าสู่ระบบ',
                            index: 1,
                            isActive: widget.numpage == 1,
                            onTap: () => _handleTapItem(1),
                            status: 0),
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Image.asset(
                        'assets/images/watalygold-logo.png',
                        fit: BoxFit.cover,
                        width: 260,
                        height: 85,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _menutopItem(
                            title: 'สมัครสมาชิก',
                            index: 0,
                            isActive: widget.numpage == 0,
                            onTap: () => _handleTapItem(0),
                            status: 1),
                        _menutopItem(
                            title: 'เข้าสู่ระบบ',
                            index: 1,
                            isActive: widget.numpage == 1,
                            onTap: () => _handleTapItem(1),
                            status: 1),
                      ],
                    ),
                  ],
                ),
        ),
      );
    }
  }
}

Widget _menutopItem(
    {required String title,
    required int index,
    bool isActive = false,
    required VoidCallback onTap,
    int? status}) {
  return Padding(
    padding: EdgeInsets.only(
        right: status == 1 ? 75 : 0, left: status == 1 ? 0 : 25),
    child: GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isActive ? GPrimaryColor : Colors.black,
              decoration: isActive ? TextDecoration.underline : null,
              decorationColor: isActive ? GPrimaryColor : null,
            ),
          )
        ],
      ),
    ),
  );
}

class Menutop_darwer extends StatefulWidget {
  const Menutop_darwer({super.key, required this.numpage});
  final int numpage;
  @override
  State<Menutop_darwer> createState() => _Menutop_darwerState();
}

class _Menutop_darwerState extends State<Menutop_darwer> {
  int _activeIndex = 1;

  void _handleTapItem(int index) {
    setState(() {
      _activeIndex = index;
    });

    if (index == 0) {
      context.goNamed('/register');
    }
    if (index == 1) {
      context.goNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize screenSize = getScreenSize(context);
    return Container(
      color: Color(0xFFF7F7F7),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: screenSize == ScreenSize.minidesktop
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Image.asset(
                      'assets/images/watalygold-logo.png',
                      fit: BoxFit.cover,
                      width: 260,
                      height: 85,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _menutopItem(
                        title: 'สมัครสมาชิก',
                        index: 0,
                        isActive: widget.numpage == 0,
                        onTap: () => _handleTapItem(0),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _menutopItem(
                        title: 'เข้าสู่ระบบ',
                        index: 1,
                        isActive: widget.numpage == 1,
                        onTap: () => _handleTapItem(1),
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Image.asset(
                      'assets/images/watalygold-logo.png',
                      fit: BoxFit.cover,
                      width: 260,
                      height: 85,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _menutopItem(
                        title: 'สมัครสมาชิก',
                        index: 0,
                        isActive: widget.numpage == 0,
                        onTap: () => _handleTapItem(0),
                      ),
                      _menutopItem(
                        title: 'เข้าสู่ระบบ',
                        index: 1,
                        isActive: widget.numpage == 1,
                        onTap: () => _handleTapItem(1),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
