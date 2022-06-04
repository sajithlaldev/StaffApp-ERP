import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/colors.dart';
import '../../utils/styles.dart';

class DefaultTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;

  final String? caption;
  final String? errorText;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  final TextInputType? textInputType;
  final bool? obscure;
  final bool? isDense;
  final bool? readOnly;

  final bool? isColapsed;

  final double? verticalPadding;

  final int? maxLength;
  final int? maxLines;

  final Widget? suffixIcon;
  final Widget? prefix;
  final TextInputAction? action;

  final Function()? onSubmitted;
  final Function()? onTap;
  final Function()? onSuffixTap;

  final List<TextInputFormatter>? formatters;

  const DefaultTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.textInputType,
    this.formatters,
    this.maxLength,
    this.onSuffixTap,
    this.obscure,
    this.maxLines,
    this.labelText,
    this.action,
    this.isDense,
    this.onSubmitted,
    this.isColapsed,
    this.caption,
    this.errorText,
    this.onTap,
    this.focusNode,
    this.readOnly,
    this.prefix,
    this.nextFocusNode,
    this.suffixIcon,
    this.verticalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (caption != null)
            Text(
              caption!,
              style: const TextStyle(
                color: AppColors.primary,
              ),
            ),
          if (caption != null)
            const SizedBox(
              height: 4,
            ),
          TextField(
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            obscureText: obscure ?? false,
            keyboardType: textInputType,
            inputFormatters: formatters,
            controller: controller,
            onEditingComplete: onSubmitted,
            focusNode: focusNode,
            maxLength: maxLength,
            onSubmitted: nextFocusNode != null
                ? (val) {
                    nextFocusNode!.requestFocus();
                  }
                : null,
            readOnly: readOnly ?? false,
            onTap: onTap,
            maxLines: maxLines ?? 1,
            textInputAction: action ?? TextInputAction.next,
            decoration: Styles.DEFAULT_TEXT_DECORATION.copyWith(
              errorText: errorText,
              hintText: hintText,
              labelText: labelText,
              contentPadding: isColapsed != null
                  ? const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 10,
                    )
                  : null,
              hintStyle: const TextStyle(
                color: AppColors.unSelectedColor,
              ),
              labelStyle: const TextStyle(
                color: AppColors.unSelectedColor,
              ),
              isCollapsed: isColapsed,
              prefixIcon: prefix,
              counterText: "",
              isDense: isDense,
              suffixIcon: onSuffixTap != null
                  ? GestureDetector(
                      onTap: onSuffixTap,
                      child: suffixIcon,
                    )
                  : suffixIcon,
            ),
          ),
        ],
      ),
    );
  }
}
