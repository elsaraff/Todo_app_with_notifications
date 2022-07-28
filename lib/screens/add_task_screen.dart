import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constants.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../reusable_components/home_screen_widgets/my_color_widget.dart';
import '../reusable_components/my_button.dart';
import '../reusable_components/my_drop_down.dart';
import '../reusable_components/my_text_form.dart';
import '../reusable_components/back_leading_appbar.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController titleController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController startTimeController = TextEditingController();
    TextEditingController endTimeController = TextEditingController();
    String timestamp = '';

    return Scaffold(
      appBar: AppBar(
        leading: const BackLeadingAppBar(),
        title: const Text(
          'Add task',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Title', style: black20Bold),
                      MyTextForm(
                          text: 'Title',
                          controller: titleController,
                          textInputType: TextInputType.text,
                          hint: 'Design Team Meeting'),
                      const SizedBox(height: 10),
                      const Text('Date', style: black20Bold),
                      MyTextForm(
                        text: 'Date',
                        controller: dateController,
                        textInputType: TextInputType.text,
                        suffix: Icons.date_range_outlined,
                        iconSize: 25,
                        hint:
                            '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.parse('2030-01-01'),
                          ).then((value) {
                            dateController.text =
                                '${value!.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Start time', style: black20Bold),
                                MyTextForm(
                                  text: 'Start time',
                                  controller: startTimeController,
                                  textInputType: TextInputType.text,
                                  suffix: Icons.watch_later_outlined,
                                  iconSize: 20,
                                  hint: '12:00 AM',
                                  onTap: () {
                                    showTimePicker(
                                            initialEntryMode:
                                                TimePickerEntryMode.input,
                                            context: context,
                                            initialTime: const TimeOfDay(
                                                hour: 00, minute: 00))
                                        .then((value) {
                                      timestamp = value!.hour
                                              .toString()
                                              .padLeft(2, '0') +
                                          value.minute
                                              .toString()
                                              .padLeft(2, '0');
                                      int hours = value.hour;
                                      if (hours >= 12) {
                                        if (hours != 12) {
                                          hours = hours - 12;
                                        }
                                        startTimeController.text =
                                            '${hours.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')} PM';
                                      } else {
                                        if (hours == 0) {
                                          hours = 12;
                                        }
                                        startTimeController.text =
                                            '${hours.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')} AM';
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('End time', style: black20Bold),
                                MyTextForm(
                                  text: 'End time',
                                  controller: endTimeController,
                                  textInputType: TextInputType.text,
                                  suffix: Icons.watch_later_outlined,
                                  iconSize: 20,
                                  hint: '12:00 AM',
                                  onTap: () {
                                    showTimePicker(
                                            initialEntryMode:
                                                TimePickerEntryMode.input,
                                            context: context,
                                            initialTime: const TimeOfDay(
                                                hour: 00, minute: 00))
                                        .then((value) {
                                      int hours = value!.hour;
                                      if (hours >= 12) {
                                        if (hours != 12) {
                                          hours = hours - 12;
                                        }
                                        endTimeController.text =
                                            '${hours.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')} PM';
                                      } else {
                                        if (hours == 0) {
                                          hours = 12;
                                        }
                                        endTimeController.text =
                                            '${hours.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')} AM';
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      BlocConsumer<AppCubit, AppStates>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              const Text('Remind', style: black20Bold),
                              MyDropdown(
                                initialValue:
                                    AppCubit.get(context).reminderValue,
                                isReminder: true,
                                items: const [
                                  '10 min before',
                                  '30 min before',
                                  '1 hour before',
                                  '1 day before'
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text('Repeat', style: black20Bold),
                              MyDropdown(
                                initialValue:
                                    AppCubit.get(context).repeaterValue,
                                isReminder: false,
                                items: const [
                                  'Once',
                                  'Daily',
                                  'Weekly',
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Choose color', style: black20Bold),
                                  MyColors(
                                      realColor: blueColor,
                                      stringColor: 'blue'),
                                  MyColors(
                                      realColor: redColor, stringColor: 'red'),
                                  MyColors(
                                      realColor: orangeColor,
                                      stringColor: 'orange'),
                                  MyColors(
                                      realColor: yellowColor,
                                      stringColor: 'yellow'),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MyButton(
                  text: 'Create a Task',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      AppCubit.get(context).insertToDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        timestamp: timestamp,
                        startTime: startTimeController.text,
                        endTime: endTimeController.text,
                        remind: AppCubit.get(context).reminderValue,
                        repeat: AppCubit.get(context).repeaterValue,
                        color: AppCubit.get(context).colorValue,
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
