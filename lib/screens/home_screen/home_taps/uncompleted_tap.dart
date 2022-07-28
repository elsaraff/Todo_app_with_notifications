import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/cubit.dart';
import '../../../cubit/states.dart';
import '../../../reusable_components/home_screen_widgets/task_items_builder.dart';

class UncompletedTaps extends StatelessWidget {
  const UncompletedTaps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child:
                TaskItemsBuilder(list: AppCubit.get(context).uncompletedTasks),
          ),
        );
      },
    );
  }
}
