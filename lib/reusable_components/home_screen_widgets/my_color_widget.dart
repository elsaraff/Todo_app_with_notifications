import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class MyColors extends StatelessWidget {
  final Color realColor;
  final String stringColor;

  const MyColors({Key? key, required this.realColor, required this.stringColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return InkWell(
          onTap: () {
            AppCubit.get(context).changeColorValue(newColor: stringColor);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: AppCubit.get(context).colorValue == stringColor
                    ? Border.all(color: Colors.grey.shade400, width: 5)
                    : null,
                color: realColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
