import 'package:flutter/material.dart';
import 'task_item.dart';

class TaskItemsBuilder extends StatelessWidget {
  final List<Map> list;
  final bool isSearch;
  const TaskItemsBuilder({Key? key, required this.list, this.isSearch = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => TaskItem(
        id: list[index]['id'],
        title: list[index]['title'],
        status: list[index]['status'],
        isFavourite: list[index]['isFavourite'] == 1 ? true : false,
        isSearch: isSearch,
      ),
      separatorBuilder: (context, index) => isSearch
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                ),
                height: 1,
              ),
            )
          : const SizedBox(height: 5),
      itemCount: list.length,
    );
  }
}
