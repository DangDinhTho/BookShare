import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CutPrice extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // TODO: implement formatEditUpdate
    //throw UnimplementedError();
    if(newValue.selection.baseOffset == 0){
      return newValue;
    }
    double value = double.parse(newValue.text);
    final price = NumberFormat("###,###,###", "en_us");
    String newText = price.format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length)
    );
  }
 
}