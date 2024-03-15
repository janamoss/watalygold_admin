import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

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
    return Container(
      color: Color(0xFFFAFAFA),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
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
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/images/watalygold_profile.png',
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _menutopItem({
  required String title,
  required int index,
  bool isActive = false,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: EdgeInsets.only(right: 75),
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
              color: isActive ? Color(0xFF7ED957) : Colors.black,
              decoration: isActive ? TextDecoration.underline : null,
              decorationColor: isActive ? Color(0xFF7ED957) : null,
            ),
          )
        ],
      ),
    ),
  );
}
