import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

int getTextSize(String text) {
  var len = 10;
  switch (text.length) {
    case 1:
      len = 30;
      break;
    case 2:
      len = 20;
      break;
    case 3:
      len = 20;
      break;
    case 4:
      len = 16;
      break;
    case 5:
      len = 15;
  }

  return text.length * len;
}
