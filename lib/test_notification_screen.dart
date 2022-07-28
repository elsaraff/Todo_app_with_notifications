import 'package:flutter/material.dart';
import 'core/notification_helper.dart';
import 'reusable_components/back_leading_appbar.dart';
import 'reusable_components/my_button.dart';

class TestNotification extends StatelessWidget {
  const TestNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackLeadingAppBar(),
          title: const Text(
            'Test Notification',
            style: TextStyle(color: Colors.black),
          )),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyButton(
                text: 'Simple Notification',
                onPressed: () {
                  NotificationHelper.showNotifications(
                    id: 19970215,
                    title: 'ToDo App',
                    body: 'Test test test test test test.',
                    payload: 'Saraff',
                  );
                }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: MyButton(
                  text: '3 Sec. Scheduled Notification',
                  onPressed: () {
                    NotificationHelper.showScheduledNotifications(
                      id: 19970425,
                      title: 'ToDo App',
                      body: 'Scheduled test test test test test.',
                      payload: 'Scheduled Saraff',
                      scheduleTime:
                          DateTime.now().add(const Duration(seconds: 3)),
                      //scheduleTime: DateTime.parse('2022-07-27 05:53:00'),
                    );
                  }),
            ),
            MyButton(
                text: 'Delete All Notification',
                onPressed: () {
                  NotificationHelper.cancelAll();
                }),
          ],
        ),
      ),
    );
  }
}
