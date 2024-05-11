import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:html/parser.dart' as htmlparse;
import 'package:html/dom.dart' as htmlDom;

class HtmlToDeltaConverter {
  static const _COLOR_PATTERN = r'color: rgb\((\d+), (\d+), (\d+)\);';
  static Delta _parseInlineStyles(htmlDom.Element element) {
    var delta = Delta();

    for (final node in element.nodes) {
      final attributes = _parseElementStyles(element);

      if (element.localName == 'h1') {
        // Special handling for <h1>
        delta
          ..insert(element.text, {'header': 1})
          ..insert('\n', {}); // Correctly apply block-level attribute
      } else {
        // Handle other elements (inline styles, images, etc.)
        for (final node in element.nodes) {
          if (node is htmlDom.Text) {
            delta.insert(node.text, attributes);
          } else if (node is htmlDom.Element && node.localName == 'br') {
            delta.insert('\n');
          } else if (node is htmlDom.Element && node.localName == 'img') {
            final src = node.attributes['src'];
            if (src != null) {
              delta.insert({'image': src});
            }
          } else if (node is htmlDom.Element) {
            // Recursive call for nested elements
            delta = delta.concat(_parseInlineStyles(node));
          }
        }
      }

      return delta;
    }
    return delta;
  }

  static Delta _parseInline2Styles(
    htmlDom.Element element,
  ) {
    var delta = Delta();

    for (final node in element.nodes) {
      final attributes = _parseElementStyles(element);

      if (element.localName == 'h1') {
        // Insert the text content of the <h1> element
        delta.insert(element.text);
        // Properly end the block with a newline and apply the header attribute
        delta.insert('\n', {'header': 1});
      } else if (element.localName == 'h2') {
        // Insert the text content of the <h1> element
        delta.insert(element.text);
        // Properly end the block with a newline and apply the header attribute
        delta.insert('\n', {'header': 2});
      } else if (element.localName == 'h3') {
        // Insert the text content of the <h1> element
        delta.insert(element.text);
        // Properly end the block with a newline and apply the header attribute
        delta.insert('\n', {'header': 3});
      } else if (node is htmlDom.Element) {
        delta = delta.concat(_parseInlineStyles(node));
      }
    }

    return delta;
  }

  static Delta _parseInline3Styles(
    htmlDom.Element element,
  ) {
    var delta = Delta();

    for (final node in element.nodes) {
      // final attributes = _parseElementStyles(element);

      if (node is htmlDom.Element && node.localName == 'li') {
        final attributes = _parseListElementStyles(node);
        delta.insert(node.text);
        delta.insert('\n', attributes);
      } else if (node is htmlDom.Element) {
        delta = delta.concat(_parseInlineStyles(node));
      }
    }

    return delta;
  }

  static Delta _parseInline4Styles(
    htmlDom.Element element,
  ) {
    var delta = Delta();

    for (final node in element.nodes) {
      // final attributes = _parseElementStyles(element);

      if (node is htmlDom.Element && node.localName == 'li') {
        delta = delta.concat(_parseListItem(node));
      }
    }

    return delta;
  }

  static Map<String, dynamic> _parseListElementStyles(htmlDom.Element element) {
    final Map<String, dynamic> attributes = {};

// Existing style parsing logic...

// Check for list tags and apply list attributes
    if (element.localName == 'li') {
      final parent = element.parent;
      if (parent != null && parent.localName == 'ul') {
        attributes['list'] = 'bullet';
      } else if (parent != null && parent.localName == 'ol') {
        attributes['list'] = 'ordered';
      }
      var checkbox = element.querySelector('input[type="checkbox"]');
      if (checkbox != null) {
        // If a checkbox is found, determine if it's checked
        bool isChecked = checkbox.attributes.containsKey('checked');
        attributes['checked'] =
            isChecked; // Add 'checked' attribute to the list item
      }
    }

    return attributes;
  }

  static Delta _parseListItem(htmlDom.Element element) {
    var delta = Delta();
    bool isChecked = false;

// Check if the list item contains an input element of type checkbox
    var inputElement = element.querySelector('input[type="checkbox"]');
    if (inputElement != null) {
      isChecked = inputElement.attributes.containsKey('checked');
    }

// Now handle the text of the list item, assuming it follows the input checkbox
    var textContent =
        element.text.trim(); // .trim() to remove leading/trailing whitespaces
// The attributes map could include other styling attributes as well, if needed
    var attributes = <String, dynamic>{};
    if (isChecked) {
      attributes['checked'] =
          true; // Custom attribute to represent checked state
    }
// Assuming list items are always part of an unordered list in this example
    attributes['list'] = 'bullet';

    delta
      ..insert(textContent)
      ..insert('\n', attributes);

    return delta;
  }

  static Map<String, dynamic> _parseElementStyles(htmlDom.Element element) {
    final Map<String, dynamic> attributes = {};

    if (element.localName == 'strong') attributes['bold'] = true;
    if (element.localName == 'em') attributes['italic'] = true;
    if (element.localName == 'u') attributes['underline'] = true;
    if (element.localName == 'del') attributes['strike'] = true;
    if (element.localName == 'header') attributes['header'] = true;

    final style = element.attributes['style'];
    if (style != null) {
      final colorValue = _parseColorFromStyle(style);
      if (colorValue != null) attributes['color'] = colorValue;

      final bgColorValue = _parseBackgroundColorFromStyle(style);
      if (bgColorValue != null) attributes['background'] = bgColorValue;
    }

    return attributes;
  }

  static String? _parseColorFromStyle(String style) {
    if (RegExp(r'(^|\s)color:(\s|$)').hasMatch(style)) {
      return _parseRgbColorFromMatch(RegExp(_COLOR_PATTERN).firstMatch(style));
    }
    return null;
  }

  static String? _parseBackgroundColorFromStyle(String style) {
    if (RegExp(r'(^|\s)background-color:(\s|$)').hasMatch(style)) {
      return _parseRgbColorFromMatch(RegExp(_COLOR_PATTERN).firstMatch(style));
    }
    return null;
  }

  static String? _parseRgbColorFromMatch(RegExpMatch? colorMatch) {
    if (colorMatch != null) {
      try {
        final red = int.parse(colorMatch.group(1)!);
        final green = int.parse(colorMatch.group(2)!);
        final blue = int.parse(colorMatch.group(3)!);
        return '#${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}';
      } catch (e) {
        debugPrintStack(label: e.toString());
      }
    }
    return null;
  }

  static Delta htmlToDelta(String html) {
    final document = htmlparse.parse(html);
    var delta = Delta();

    for (final node in document.body?.nodes ?? []) {
      if (node is htmlDom.Element) {
        switch (node.localName) {
          case 'p':
            delta = delta.concat(_parseInlineStyles(node))..insert('\n');
            break;
          case 'br':
            delta.insert('\n');
            break;
          case 'h1':
            delta = delta.concat(_parseInline2Styles(node));
            // delta.insert('\n');
            break;
          case 'h2':
            delta = delta.concat(_parseInline2Styles(node));
            // delta.insert('\n');
            break;
          case 'h3':
            delta = delta.concat(_parseInline2Styles(node));
            break;
          case 'ol':
            delta = delta.concat(_parseInline3Styles(node));
            break;
          case 'ul':
            delta = delta.concat(_parseInline3Styles(node));
            break;
        }
      }
    }

    return html.isNotEmpty ? delta : Delta()
      ..insert('\n');
  }
}
