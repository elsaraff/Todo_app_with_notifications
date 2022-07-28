import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../cubit/cubit.dart';

class TaskItem extends StatelessWidget {
  final int id;
  final String title;
  final String status;
  final bool isFavourite;
  final bool isSearch;

  const TaskItem({
    Key? key,
    required this.id,
    required this.title,
    required this.status,
    required this.isFavourite,
    this.isSearch = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isSearch == false)
          InkWell(
            onTap: () {
              AppCubit.get(context)
                  .changeFavouriteStatus(id: id, isFavourite: isFavourite);
            },
            child: Tooltip(
              message:
                  isFavourite ? 'Remove from favourite' : 'Add to favourite',
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isFavourite
                          ? status == 'completed'
                              ? blueColor
                              : redColor
                          : null,
                      border: Border.all(
                        width: 3,
                        color: status == 'completed' ? blueColor : redColor,
                      )),
                ),
              ),
            ),
          ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(title,
              maxLines: 1, overflow: TextOverflow.ellipsis, style: black18),
        ),
        if (isSearch == false)
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, size: 20, color: Colors.black),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text(status == 'completed'
                      ? 'Make as uncompleted'
                      : 'Make as completed'),
                  onTap: () {
                    AppCubit.get(context).updateTaskStatus(
                      id: id,
                      status:
                          status == 'completed' ? 'uncompleted' : 'completed',
                    );
                  },
                ),
                PopupMenuItem(
                  child: const Text('Delete task'),
                  onTap: () {
                    AppCubit.get(context).deleteTask(id: id);
                  },
                )
              ];
            },
          )
      ],
    );
  }
}
