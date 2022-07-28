import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../cubit/cubit.dart';

class ScheduleTaskItem extends StatelessWidget {
  final int id;
  final String title;
  final String date;
  final String status;
  final String startTime;
  final String color;

  const ScheduleTaskItem({
    Key? key,
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.startTime,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color == 'blue'
            ? blueColor
            : color == 'orange'
                ? orangeColor
                : color == 'yellow'
                    ? yellowColor
                    : redColor,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 5, 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(startTime,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: white16Bold),
                  const SizedBox(height: 5),
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: white18),
                ],
              ),
            ),
            IconButton(
                tooltip: status == 'completed'
                    ? 'Make as uncompleted'
                    : 'Make as completed',
                onPressed: () {
                  AppCubit.get(context).updateTaskStatus(
                    id: id,
                    status: status == 'completed' ? 'uncompleted' : 'completed',
                  );
                  AppCubit.get(context).getTaskPerDay(date: date);
                },
                icon: Icon(
                  status == 'completed'
                      ? Icons.check_circle_outlined
                      : Icons.circle_outlined,
                  color: Colors.white,
                  size: 20,
                )),
          ],
        ),
      ),
    );
  }
}
