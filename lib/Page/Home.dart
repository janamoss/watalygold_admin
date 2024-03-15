import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:watalygold_admin/Components/SidebarController.dart';
import 'package:watalygold_admin/Page/Knowlege/AddKnowlege.dart';
import 'package:watalygold_admin/Page/Knowlege/MainKnowlege.dart';
import 'package:watalygold_admin/Page/MainDashborad.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_Sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool _showDropdown = false;

  late List<Widget> _widgetOption;

  @override
  void initState() {
    super.initState();
    _widgetOption = [];
  }

  SidebarController sidebarController = Get.put(SidebarController());
  final _beamerKey = GlobalKey<BeamerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: G2PrimaryColor,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
                child: Container(
              child: SideNav(),
            )),
            Expanded(
              flex: 4,
              child: Beamer(
                key: _beamerKey,
                routerDelegate: BeamerDelegate(
                  // NOTE First Method
                  locationBuilder: RoutesLocationBuilder(
                    routes: {
                      '*': (context, state, data) => const SizedBox(),
                      '/Dashboard': (context, state, data) => const BeamPage(
                            key: ValueKey('Dashboard'),
                            type: BeamPageType.scaleTransition,
                            child: MainDash(),
                          ),
                      '/Knowledge': (context, state, data) =>
                          const BeamPage(
                            key: ValueKey('Profile'),
                            type: BeamPageType.scaleTransition,
                            child: MainKnowlege(),
                          ),
                      '/AddKnowledge': (context, state, data) => const BeamPage(
                            key: ValueKey('Notification'),
                            type: BeamPageType.scaleTransition,
                            child: AddKnowlege(),
                          ),
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// IconButton(
//                       onPressed: () {
                        
//                       },
//                       icon: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [Icon(Icons.logout_rounded), Text("Log out")],
//                       ))
