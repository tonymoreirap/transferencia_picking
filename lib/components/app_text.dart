import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppText extends StatelessWidget {
  String label;
  String hint;
  bool password;
  TextEditingController controller;
  FormFieldValidator<String> validator;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  FocusNode focusNode;
  FocusNode nextFocus;
  Function onFieldSubmitted;
  double fontSize;
  double fontSizeHint;
  bool autofocus;
  bool scan;
  int maxLines;

  FocusNode _focusKeyBoard = FocusNode();

  AppText(this.label, this.hint,
      {this.password = false,
      this.controller,
      this.validator,
      this.keyboardType,
      this.textInputAction,
      this.focusNode,
      this.nextFocus,
      this.onFieldSubmitted,
      this.fontSize = 12.0,
      this.fontSizeHint = 12.0,
      this.autofocus = false,
      this.scan = false,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusKeyBoard,
      onKey: (event) {
        /*No Coletor Android Compex, configurar no Scan tool [Barcode Send Model]  = EmuKey
        Isso é necessário para a tecla [Enter] ser capturada no evento [RawKeyUpEvent] do teclado*/
        print("scan: $scan");
        if (scan) {
          if (event is RawKeyUpEvent) {
            print("event.logicalKey--: ${event.logicalKey}");
            if (event.logicalKey == LogicalKeyboardKey.enter) {
              print("LogicalKeyboardKey.enter--: ${event.logicalKey}");
              onFieldSubmitted(this.controller.text);
            }
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(2.0),
        child: TextFormField(
          autofocus: autofocus,
          controller: controller,
          obscureText: password,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          focusNode: focusNode,
          maxLines: maxLines,
          onFieldSubmitted: (String text) {
            if (nextFocus != null) {
              FocusScope.of(context).requestFocus(nextFocus);
            }
            onFieldSubmitted(text);
          },
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.blue,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            labelText: label,
            labelStyle: TextStyle(
              fontSize: fontSize,
              color: Colors.grey,
            ),
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: fontSizeHint,
            ),
          ),
          onChanged: (text) {
            print('onChanged: $text');
          },
          onEditingComplete: () {
            print('onEditingComplete: ---');
          },
          onSaved: (text) {
            print('onSaved: $text');
          },
        ),
      ),
    );
  }
}
