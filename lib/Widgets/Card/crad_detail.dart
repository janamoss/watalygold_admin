import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

class CardDetail extends StatelessWidget {
  final String svgurl;
  final Color color;
  final String name;
  final int number;
  const CardDetail(
      {super.key,
      required this.color,
      required this.name,
      required this.number,
      required this.svgurl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        color: color,
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: null,
                icon: SvgPicture.asset(
                  svgurl,
                  colorFilter:
                      const ColorFilter.mode(WhiteColor, BlendMode.srcIn),
                  semanticsLabel: name,
                  height: 45,
                  width: 45,
                ),
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(1),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                    backgroundColor: MaterialStateProperty.all(
                        Colors.black.withOpacity(0.15))),
                padding: const EdgeInsets.all(5),
              ),
              const Spacer(),
              Text(
                name,
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: WhiteColor),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.baseline, // จัดวางบนบรรทัดเดียวกัน
            textBaseline: TextBaseline.alphabetic, // กำหนดให้จัดตามขนาดตัวอักษร
            children: [
              Text(
                number != null ? number.toString() : '0',
                style: const TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: WhiteColor,
                ),
              ),
              const Spacer(),
              const Baseline(
                baseline: 25.0, // ปรับระดับบรรทัดให้เท่ากับขนาดตัวอักษร
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  "ครั้ง",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: WhiteColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
