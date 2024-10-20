import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:logger/logger.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'dart:ui_web';

class testss extends StatefulWidget {
  const testss({super.key});

  @override
  State<testss> createState() => _testssState();
}

class _testssState extends State<testss> {
  final logger = Logger();
  QuillController _controller = QuillController.basic();
  String _html = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          QuillToolbar.simple(
            configurations: QuillSimpleToolbarConfigurations(
              controller: _controller,
              sharedConfigurations: const QuillSharedConfigurations(
                locale: Locale('de'),
              ),
            ),
          ),
          Expanded(
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: _controller,
                // readOnly: false,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('de'),
                ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                final deltaJson = _controller.document.toDelta().toJson();
                logger.d(deltaJson);
                final converter = QuillDeltaToHtmlConverter(
                  List.castFrom(deltaJson),
                );
                _html = converter.convert();
                logger.d(_html);
              },
              child: Text("dsdsd"))
        ],
      ),
    );
  }
}
