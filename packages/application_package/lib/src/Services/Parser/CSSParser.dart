import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';



class CSSParser {
  double parseUnitValue(String value, {double? parentValue}) {
    value = value.trim().toLowerCase();
    if (value.endsWith('px')) {
      return double.parse(value.replaceAll('px', ''));
    } else if (value.endsWith('em')) {
      double emValue = double.parse(value.replaceAll('em', ''));
      return emValue * (parentValue ?? 16); // Assuming 1em = 16px if no parent value
    } else if (value.endsWith('pt')) {
      return double.parse(value.replaceAll('pt', '')) * 1.33; // 1pt ≈ 1.33px
    } else if (value.endsWith('%')) {
      double percentValue = double.parse(value.replaceAll('%', ''));
      return (parentValue ?? 100) * percentValue / 100;
    } else {
      return double.tryParse(value) ?? 0;
    }
  }

  List<double> parseMultipleValues(String propertyValue, {double? parentValue}) {
    List<String> values = propertyValue.split(' ');
    return values.map((v) => parseUnitValue(v, parentValue: parentValue)).toList();
  }

  Map<String, Style> parseDeclarations(String declarations) {
    Map<String, Style> styles = {};
    List<String> rules = declarations.split('}');

    for (String rule in rules) {
      if (rule.isEmpty) continue;

      List<String> parts = rule.split('{');
      if (parts.length != 2) continue;

      String selector = parts[0].trim();
      String properties = parts[1].trim();

      Style style = Style();
      List<String> propertyList = properties.split(';');

      for (String property in propertyList) {
        property = property.trim();
        if (property.isEmpty) continue;

        List<String> keyValue = property.split(':');
        if (keyValue.length != 2) continue;

        String propertyName = keyValue[0].trim();
        String propertyValue = keyValue[1].trim();

        switch (propertyName) {
          case 'color':
            try {
              style = style.copyWith(color: parseColor(propertyValue));
            } catch (e) {
              print('Error parsing color: $propertyValue - $e');
            }
            break;
          case 'font-size':
            try {
              double fontSize = parseUnitValue(propertyValue);
              style = style.copyWith(fontSize: FontSize(fontSize));
            } catch (e) {
              print('Error parsing font-size: $propertyValue - $e');
            }
            break;
          case 'font-weight':
            if (propertyValue == 'bold') {
              style = style.copyWith(fontWeight: FontWeight.bold);
            } else if (propertyValue == 'normal') {
              style = style.copyWith(fontWeight: FontWeight.normal);
            }
            break;
          case 'text-align':
            if (propertyValue == 'center') {
              style = style.copyWith(textAlign: TextAlign.center);
            } else if (propertyValue == 'left') {
              style = style.copyWith(textAlign: TextAlign.left);
            } else if (propertyValue == 'right') {
              style = style.copyWith(textAlign: TextAlign.right);
            }
            break;
          case 'margin':
            try {
              List<double> marginValues = parseMultipleValues(propertyValue);
              switch (marginValues.length) {
                case 1:
                  style = style.copyWith(margin: Margins.all(marginValues[0]));
                  break;
                case 2:
                  style = style.copyWith(margin: Margins.symmetric(vertical: marginValues[0], horizontal: marginValues[1]));
                  break;
                case 4:
                  style = style.copyWith(margin: Margins.only(top: marginValues[0], right: marginValues[1], bottom: marginValues[2], left: marginValues[3]));
                  break;
              }
            } catch (e) {
              print('Error parsing margin: $propertyValue - $e');
            }
            break;
          case 'padding':
            try {
              List<double> paddingValues = parseMultipleValues(propertyValue);
              switch (paddingValues.length) {
                case 1:
                  style = style.copyWith(padding: HtmlPaddings.all(paddingValues[0]));
                  break;
                case 2:
                  style = style.copyWith(padding: HtmlPaddings.symmetric(vertical: paddingValues[0], horizontal: paddingValues[1]));
                  break;
                case 4:
                  style = style.copyWith(padding: HtmlPaddings.only(top: paddingValues[0], right: paddingValues[1], bottom: paddingValues[2], left: paddingValues[3]));
                  break;
              }
            } catch (e) {
              print('Error parsing padding: $propertyValue - $e');
            }
            break;
          case 'background-color':
            try {
              style = style.copyWith(backgroundColor: parseColor(propertyValue));
            } catch (e) {
              print('Error parsing background-color: $propertyValue - $e');
            }
            break;
        }
      }

      styles[selector] = style;
    }

    return styles;
  }

  Color parseColor(String colorString) {
    // Implement your color parsing logic here
    // This is a placeholder implementation
    if (colorString.startsWith('#')) {
      return Color(int.parse(colorString.substring(1), radix: 16) | 0xFF000000);
    } else if (colorString.toLowerCase() == 'red') {
      return Colors.red;
    } else if (colorString.toLowerCase() == 'blue') {
      return Colors.blue;
    } else if (colorString.toLowerCase() == 'green') {
      return Colors.green;
    }
    // Add more color parsing logic as needed
    return Colors.black;
  }

  @override
  int getId() {
    var random = Random();
    int randomNumber = random.nextInt(1 << 15); // Corrected bitwise shift operator
    return randomNumber;
  }
}
