import 'package:flutter/material.dart';

import '../core/constants.dart';

class MyTextForm extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool isSearch;
  final GestureTapCallback? onTap;
  final String? hint;
  final IconData? suffix;
  final IconData? prefix;
  final double? iconSize;
  final Function? onChangedFunction;

  const MyTextForm({
    Key? key,
    required this.text,
    required this.controller,
    required this.textInputType,
    this.isSearch = false,
    this.onTap,
    this.hint,
    this.suffix,
    this.prefix,
    this.iconSize,
    this.onChangedFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.grey[200]),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: TextFormField(
            autofocus: isSearch,
            onChanged: isSearch
                ? (value) {
                    onChangedFunction!();
                  }
                : null,
            onTap: onTap,
            style: black18,
            controller: controller,
            keyboardType: textInputType,
            cursorColor: Colors.black,
            validator: (value) {
              if (value!.isEmpty) {
                return '$text is Empty';
              }
              return null;
            },
            decoration: InputDecoration(
              hintStyle: const TextStyle(color: Colors.grey),
              hintText: hint,
              suffixIcon: suffix != null
                  ? Icon(
                      suffix,
                      size: iconSize,
                      color: Colors.grey,
                    )
                  : null,
              prefixIcon: prefix != null
                  ? Icon(
                      prefix,
                      size: iconSize,
                      color: Colors.grey,
                    )
                  : null,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
