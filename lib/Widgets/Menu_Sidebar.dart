import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:animated_tree_view/tree_view/tree_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:watalygold_admin/Components/SidebarController.dart';
import 'package:watalygold_admin/Page/Knowlege/Home.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

class SidebarMenu extends StatefulWidget {
  const SidebarMenu({super.key});

  @override
  State<SidebarMenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  @override
  Widget build(BuildContext context) {
    SidebarController sidebarController = Get.put(SidebarController());
    bool _isDropdownPressed = false;
    bool _showDropdown = false;
    return Container(
      color: Color(0xff7ED957),
      child: Column(
        children: [
          Center(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Image.asset(
                  "assets/images/watalygold-logo-2.png",
                  fit: BoxFit.cover,
                )),
          ),
          Obx(
            () => Column(
              children: [
                SideMenutitle(
                  selectedColors: Colors.black,
                  title: 'ผลการวิเคราะห์รายวัน',
                  icons: Icons.dashboard_outlined,
                  press: () {
                    sidebarController.index.value = 0;
                  },
                  seleteds: sidebarController.index.value == 0,
                ),
                SideMenutitle_dropdown(
                  title: "คลังความรู้",
                  icons: Icons.menu_book_rounded,
                  onPress: () {
                    setState(() {
                      _isDropdownPressed = true;
                      _showDropdown = !_showDropdown;
                      // sidebarController.index.value = 1;
                    });
                  },
                  seleteds: sidebarController.index.value == 0,
                ),
              ],
            ),
          ),
          _buildAddKnowledgeTile(_isDropdownPressed),
        ],
      ),
    );
  }

  Widget _buildAddKnowledgeTile(bool _isDropdownPressed) {
    if (_isDropdownPressed == true) {
      return Column(
        children: [
          ListTile(
            onTap: () {},
            contentPadding: EdgeInsets.only(left: 50),
            title: Text(
              "หน้าหลักคลังความรู้",
              style: TextStyle(color: WhiteColor, fontSize: 17),
            ),
          ),
          ListTile(
            onTap: () {},
            contentPadding: EdgeInsets.only(left: 50),
            title: Text(
              "เพิ่มคลังความรู้",
              style: TextStyle(color: WhiteColor, fontSize: 17),
            ),
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }
}

class SideMenutitle extends StatelessWidget {
  const SideMenutitle({
    super.key,
    required this.title,
    required this.icons,
    required this.press,
    required this.seleteds,
    required this.selectedColors,
  });

  final String title;
  final IconData icons;
  final VoidCallback press;
  final bool seleteds;
  final Color selectedColors;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      leading: Icon(
        icons,
        color: seleteds ? G2PrimaryColor : WhiteColor,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: seleteds ? G2PrimaryColor : WhiteColor, fontSize: 17),
      ),
      selected: seleteds,
      selectedTileColor: selectedColors.withOpacity(0.8),
    );
  }
}

class SideMenutitle_dropdown extends StatefulWidget {
  const SideMenutitle_dropdown({
    super.key,
    required this.title,
    required this.icons,
    required this.onPress,
    required this.seleteds,
  });

  final String title;
  final IconData icons;
  final VoidCallback onPress;
  final bool seleteds;

  @override
  State<SideMenutitle_dropdown> createState() => _SideMenutitle_dropdownState();
}

class _SideMenutitle_dropdownState extends State<SideMenutitle_dropdown> {
  @override
  bool _showDropdown = false;
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        widget.onPress;
        _showDropdown = !_showDropdown;
      },
      leading: Icon(
        widget.icons,
        color: WhiteColor,
      ),
      title: Text(
        widget.title,
        style: TextStyle(color: WhiteColor, fontSize: 17),
      ),
      trailing: RotatedBox(
        quarterTurns: 1,
        child: Icon(
          _showDropdown
              ? Icons.keyboard_arrow_left_rounded
              : Icons.keyboard_arrow_right_rounded,
          color: WhiteColor,
        ),
      ),
      selected: widget.seleteds,
    );
  }
}
