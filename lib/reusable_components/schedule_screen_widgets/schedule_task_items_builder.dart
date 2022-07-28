import 'package:flutter/material.dart';
import 'schedule_task_item.dart';

class ScheduleTaskItemsBuilder extends StatelessWidget {
  final List<Map> list;
  final String date;
  const ScheduleTaskItemsBuilder({
    Key? key,
    required this.list,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => ScheduleTaskItem(
        id: list[index]['id'],
        title: list[index]['title'],
        date: date,
        status: list[index]['status'],
        startTime: list[index]['startTime'],
        color: list[index]['color'],
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: list.length,
    );
  }
}
