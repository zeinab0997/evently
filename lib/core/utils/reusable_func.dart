import 'package:evently/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ReusableFunc{

  static void showSnackBar({required BuildContext context, required String message}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, ),
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.primary_color,
      ),
    );
}

}