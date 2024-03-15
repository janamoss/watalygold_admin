import 'package:flutter/material.dart';
import 'package:watalygold_admin/Widgets/Color.dart';
import 'package:watalygold_admin/service/content.dart';


import 'package:watalygold_admin/service/knowledge.dart';

class KnowledgePage extends StatefulWidget {
  final Knowledge? knowledge;
  final IconData? icons;
  final Contents? contents;
  const KnowledgePage({super.key, this.knowledge, this.contents, this.icons});

  @override
  State<KnowledgePage> createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> {
  late String detail =
      widget.knowledge!.knowledgeDetail.replaceAll('\n', '\n\n');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      
      body: Stack(
        children: [
          Image.network(
            widget.knowledge != null
                ? widget.knowledge!.knowledgeImg
                : widget.contents!.ImageURL,
            fit: BoxFit.cover,
            height: 400,
          ),
          Positioned(
            bottom: -15.0, // ปรับค่านี้เพื่อขยับ Container ขึ้น
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              decoration: BoxDecoration(
                  color: WhiteColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(40))),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(widget.icons ?? Icons.question_mark_rounded,
                          color: GPrimaryColor, size: 40),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        widget.knowledge != null
                            ? widget.knowledge!.knowledgeName
                            : widget.contents!.ContentName,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.knowledge != null
                              ? '''${widget.knowledge!.knowledgeDetail}'''
                                  .replaceAll('n', '\n')
                              : '''${widget.contents!.ContentDetail}'''
                                  .replaceAll('n', '\n'),
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          textAlign: TextAlign.left,
                          maxLines: 3,
                        ),
                      ),
                      // HtmlWidget(
                      //   widget.knowledge != null
                      //       ? '${widget.knowledge!.knowledgeDetail}'
                      //       : '${widget.contents!.ContentDetail}',
                      //   textStyle: TextStyle(color: Colors.black, fontSize: 15),
                      //   renderMode: RenderMode.column,
                      //   customStylesBuilder: (element) {
                      //     if (element.classes.contains('p')) {
                      //       return {'color': 'red'};
                      //     }

                      //     return null;
                      //   },
                      // ),
                    ],
                  )
                ],
              ),
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }
}
