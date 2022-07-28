import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../cubit/cubit.dart';

class MyDropdown extends StatelessWidget {
  final String initialValue;
  final bool isReminder;
  final List<String> items;

  const MyDropdown({
    super.key,
    required this.initialValue,
    required this.isReminder,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.grey[200]),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 5),
          child: DropdownButton<String>(
            value: initialValue,
            style: black18,
            icon: const Icon(Icons.keyboard_arrow_down_sharp),
            iconSize: 30,
            iconEnabledColor: Colors.grey,
            isExpanded: true,
            underline: Container(),
            onChanged: (String? newValue) {
              AppCubit.get(context)
                  .changeDropValue(value: newValue!, isReminder: isReminder);
            },
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
