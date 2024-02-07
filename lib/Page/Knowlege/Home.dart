import 'package:flutter/material.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/Widgets/Menu_top.dart';

class Home_Knowlege extends StatefulWidget {
  const Home_Knowlege({super.key});

  @override
  State<Home_Knowlege> createState() => _Home_KnowlegeState();
}

class _Home_KnowlegeState extends State<Home_Knowlege> {
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
                children: [],
              ),
            )
          ],
        ),
      ),
    );
  }
}
