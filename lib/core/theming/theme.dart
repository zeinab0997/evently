import 'dart:ui';

import 'package:flutter/material.dart';

abstract class BaseTheme{

  Color get bg_color;
  Color get primary_color;
  Color get text_color;
  Color get text_field_border_color;
  ThemeData get theme_data;

}