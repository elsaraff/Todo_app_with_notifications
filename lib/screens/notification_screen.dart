import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../reusable_components/back_leading_appbar.dart';

class NotificationScreen extends StatelessWidget {
  final String? payload;

  const NotificationScreen(this.payload, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit.get(context).getNotificationTask(payload!);
    log('build');
    return Scaffold(
      appBar: AppBar(
          leading: const BackLeadingAppBar(),
          title: const Text(
            'Notifications',
            style: TextStyle(color: Colors.black),
          )),
      body: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: payload == null ||
                    payload == '' ||
                    cubit.notificationTask == {} ||
                    cubit.databaseIsOpened == false
                ? const Center(
                    child: Text('No Notification', style: black18Bold))
                : Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: cubit.notificationTask['color'] == 'blue'
                          ? blueColor
                          : cubit.notificationTask['color'] == 'orange'
                              ? orangeColor
                              : cubit.notificationTask['color'] == 'yellow'
                                  ? yellowColor
                                  : cubit.notificationTask['color'] == 'red'
                                      ? redColor
                                      : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 5, 18),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('It\'s ${cubit.notificationTask['remind']}..',
                              style: white16Bold),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.sticky_note_2_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(cubit.notificationTask['title'].toString(),
                                  style: white19Bold),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.alarm,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                  cubit.notificationTask['startTime']
                                      .toString(),
                                  style: white16),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.repeat,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(cubit.notificationTask['repeat'].toString(),
                                  style: white16),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
