import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:watalygold_admin/Widgets/Color.dart';

class Container_resultdetail extends StatefulWidget {
  final String date;
  final int count;
  final Map<String, int> qualities;
  const Container_resultdetail(
      {super.key,
      required this.date,
      required this.count,
      required this.qualities});

  @override
  State<Container_resultdetail> createState() => _Container_resultdetailState();
}

class _Container_resultdetailState extends State<Container_resultdetail> {
  bool _showdropdown = false;

  final List<String> list_image = [
    "assets/images/grade 1.svg",
    "assets/images/grade 2.svg",
    "assets/images/grade 3.svg",
    "assets/images/grade 4.svg",
  ];

  final List<Color> list_color = [
    G2PrimaryColor,
    const Color(0xFF86BD41),
    const Color(0xFFB6AC55),
    const Color(0xFFB68955),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showdropdown = !_showdropdown;
        });
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: GPrimaryColor,
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 5,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: WhiteColor,
                  ),
                  child: Icon(
                    Icons.date_range_rounded,
                    color: GPrimaryColor,
                    size: 20,
                  ),
                ),
                Text(
                  "วันที่ ${widget.date}",
                  style: TextStyle(color: WhiteColor),
                ),
                Text(
                  "${widget.count} รายการ",
                  style: TextStyle(color: WhiteColor),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showdropdown = !_showdropdown;
                    });
                  },
                  icon: Icon(
                    _showdropdown
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: WhiteColor,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ),
          _showdropdown
              ? Container(
                  margin: EdgeInsets.all(10),
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: WhiteColor,
                    elevation: 3,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Material(
                                  color: G2PrimaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: null,
                                        icon: SvgPicture.asset(
                                          "assets/images/grade 1.svg",
                                          colorFilter: const ColorFilter.mode(
                                              WhiteColor, BlendMode.srcIn),
                                          semanticsLabel: "ขั้นพิเศษ",
                                          height: 25,
                                          width: 25,
                                        ),
                                        style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(1),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10))),
                                            backgroundColor:
                                                MaterialStateProperty.all(Colors
                                                    .black
                                                    .withOpacity(0.075))),
                                        // padding: const EdgeInsets.all(2.5),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "ขั้นพิเศษ : ",
                                            style: TextStyle(color: WhiteColor),
                                          ),
                                          Text(
                                            "${widget.qualities['ขั้นพิเศษ']}",
                                            style: TextStyle(
                                                color: WhiteColor,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Material(
                                  color: Color(0xFFB6AC55),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: null,
                                        icon: SvgPicture.asset(
                                          "assets/images/grade 3.svg",
                                          colorFilter: const ColorFilter.mode(
                                              WhiteColor, BlendMode.srcIn),
                                          semanticsLabel: "ขั้นที่ 2",
                                          height: 25,
                                          width: 25,
                                        ),
                                        style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(1),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10))),
                                            backgroundColor:
                                                MaterialStateProperty.all(Colors
                                                    .black
                                                    .withOpacity(0.075))),
                                        // padding: const EdgeInsets.all(5),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "ขั้นที่ 2 : ",
                                            style: TextStyle(color: WhiteColor),
                                          ),
                                          Text(
                                            "${widget.qualities['ขั้นที่ 2']}",
                                            style: TextStyle(
                                                color: WhiteColor,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Material(
                                  color: Color(0xFF86BD41),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: null,
                                        icon: SvgPicture.asset(
                                          "assets/images/grade 2.svg",
                                          colorFilter: const ColorFilter.mode(
                                              WhiteColor, BlendMode.srcIn),
                                          semanticsLabel: "ขั้นที่ 1",
                                          height: 25,
                                          width: 25,
                                        ),
                                        style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(1),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10))),
                                            backgroundColor:
                                                MaterialStateProperty.all(Colors
                                                    .black
                                                    .withOpacity(0.075))),
                                        // padding: const EdgeInsets.all(5),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "ขั้นที่ 1 : ",
                                            style: TextStyle(color: WhiteColor),
                                          ),
                                          Text(
                                            "${widget.qualities['ขั้นที่ 1']}",
                                            style: TextStyle(
                                                color: WhiteColor,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Material(
                                  color: Color(0xFFB68955),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: null,
                                        icon: SvgPicture.asset(
                                          "assets/images/grade 4.svg",
                                          colorFilter: const ColorFilter.mode(
                                              WhiteColor, BlendMode.srcIn),
                                          semanticsLabel: "ไม่เข้าข่าย",
                                          height: 25,
                                          width: 25,
                                        ),
                                        style: ButtonStyle(
                                            elevation:
                                                MaterialStateProperty.all(1),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10))),
                                            backgroundColor:
                                                MaterialStateProperty.all(Colors
                                                    .black
                                                    .withOpacity(0.075))),
                                        // padding: const EdgeInsets.all(5),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "ไม่เข้าข่าย : ",
                                            style: TextStyle(color: WhiteColor),
                                          ),
                                          Text(
                                            "${widget.qualities['ไม่เข้าข่าย']}",
                                            style: const TextStyle(
                                                color: WhiteColor,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
