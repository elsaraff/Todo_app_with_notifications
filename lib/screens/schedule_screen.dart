import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../core/constants.dart';
import '../core/functions.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../reusable_components/back_leading_appbar.dart';
import '../reusable_components/schedule_screen_widgets/schedule_task_items_builder.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime mySelectedDay = DateTime.now();
  DateTime myFocusedDay = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackLeadingAppBar(),
          title: Row(
            children: [
              const Text('Schedule', style: TextStyle(color: Colors.black)),
              const Spacer(),
              IconButton(
                  tooltip: 'Tips',
                  onPressed: () {},
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.black,
                  )),
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0),
              child: TableCalendar(
                firstDay: DateTime.utc(2021, 5, 31),
                lastDay: DateTime.utc(2030, 1, 1),
                focusedDay: myFocusedDay,
                headerVisible: false,
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
                  weekendStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                calendarStyle: CalendarStyle(
                    selectedDecoration: const BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.6),
                        shape: BoxShape.circle)),
                calendarFormat: CalendarFormat.week,
                selectedDayPredicate: (day) {
                  return isSameDay(mySelectedDay, day);
                },
                onCalendarCreated: (_) {
                  AppCubit.get(context).getTaskPerDay(
                      date: mySelectedDay.toString().substring(0, 10));
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(mySelectedDay, selectedDay)) {
                    setState(() {
                      mySelectedDay = selectedDay;
                      myFocusedDay = focusedDay;
                    });
                    AppCubit.get(context).getTaskPerDay(
                        date: mySelectedDay.toString().substring(0, 10));
                  }
                },
              ),
            ),
            Container(height: 2, color: Colors.black26),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(getDay(mySelectedDay.weekday), style: black18Bold),
                      const Spacer(),
                      Text(
                          '${mySelectedDay.day} ${getMonth(mySelectedDay.month)}${mySelectedDay.year}',
                          style: black14),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<AppCubit, AppStates>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return ScheduleTaskItemsBuilder(
                        list: AppCubit.get(context).taskPerDay,
                        date: mySelectedDay.toString().substring(0, 10),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
