import 'package:evently/core/provider/app_provider.dart';
import 'package:evently/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFormFieldItem extends StatefulWidget {
  AppProvider provider;
  String? prefixIcon;
  bool isPass;
  String label;
  int maxLines;
  TextEditingController controller;
  String? Function(String?)? validator;
  Function? onChanged;
  Function? onChooseLocation;
  bool isLocation;

  TextFormFieldItem({
    super.key,
    required this.provider,
    required this.prefixIcon,
    required this.isPass,
    required this.label,
    required this.maxLines,
    required this.validator,
    required this.controller,
    this.onChanged,
    this.onChooseLocation,
    this.isLocation = false,
  });

  @override
  State<TextFormFieldItem> createState() => _TextFormFieldItemState();
}

class _TextFormFieldItemState extends State<TextFormFieldItem> {
  bool isHidden = false;

  @override
  void initState() {
    isHidden = widget.isPass;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      maxLines: widget.maxLines,
      cursorColor: Theme.of(context).primaryColor,
      obscureText: widget.isPass ? isHidden : false,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        prefixIcon:
            widget.prefixIcon == null
                ? null
                : Image.asset(
                  widget.prefixIcon!,
                  color:
                      widget.provider.isThemeDark()
                          ? AppColors.dark_text_color
                          : AppColors.gray_color,
                  width: 16.w,
                  height: 16.h,
                ),
        label: Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color:
                widget.provider.isThemeDark()
                    ? AppColors.dark_text_color
                    : AppColors.gray_color,
          ),
        ),
        suffixIcon:
            widget.isPass
                ? IconButton(
                  icon: Icon(
                    isHidden ? Icons.visibility_off : Icons.visibility,
                    color:
                        widget.provider.isThemeDark()
                            ? AppColors.dark_text_color
                            : AppColors.gray_color,
                  ),
                  onPressed: () {
                    setState(() {
                      isHidden = !isHidden;
                    });
                  },
                )
                : widget.isLocation
                ? IconButton(
                  onPressed:(){
                    widget.onChooseLocation!();
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color:
                        widget.provider.isThemeDark()
                            ? AppColors.dark_text_color
                            : AppColors.gray_color,
                    size: 24.r,
                  ),
                )
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color:
                widget.provider.isThemeDark()
                    ? AppColors.dark_primary_color
                    : AppColors.gray_color,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color:
                widget.provider.isThemeDark()
                    ? AppColors.dark_primary_color
                    : AppColors.gray_color,
          ),
        ),
      ),
    );
  }
}
