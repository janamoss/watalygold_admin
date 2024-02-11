import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                child: Image.asset(
                  "assets/images/watalygold_profile.png",
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                ),
              )),
        ],
      ),
    );
  }
}

class ProfileDropdown extends StatefulWidget {
  const ProfileDropdown({super.key});

  @override
  State<ProfileDropdown> createState() => _ProfileDropdownState();
}

class _ProfileDropdownState extends State<ProfileDropdown> {
  bool _showDropdown = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          // รูปโปรไฟล์
          GestureDetector(
            onTap: () {
              setState(() {
                _showDropdown = !_showDropdown;
              });
            },
            child: CircleAvatar(
              radius: 25,
              backgroundImage:
                  AssetImage('assets/images/watalygold_profile.png'),
            ),
          ),

          // Dropdown menu
          _showDropdown
              ? DropdownMenu(
                  dropdownMenuEntries: [
                    DropdownMenuEntry(value: "", label: "ออกจากระบบ")
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
