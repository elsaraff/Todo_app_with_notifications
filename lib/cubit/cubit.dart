import 'dart:developer';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit_notification_functions.dart';
import 'states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  String reminderValue = '10 min before';
  String repeaterValue = 'Once';

  void changeDropValue({
    required String value,
    required bool isReminder,
  }) {
    if (isReminder) {
      reminderValue = value;
    } else {
      repeaterValue = value;
    }
    emit(ChangeDropValueState());
  }

  String colorValue = 'blue';

  void changeColorValue({
    required String newColor,
  }) {
    colorValue = newColor;
    emit(ChangeColorValueState());
  }

  late Database database;

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) async {
      log('Database Created');
      await database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, timestamp TEXT, startTime TEXT, endTime TEXT, remind TEXT, repeat TEXT, status TEXT, color TEXT, isFavourite INTEGER)')
          .then((value) {
        log('Table Created');
      }).catchError((error) {
        log('Error when creating table ${error.toString()}');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      log('Database Opened');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String date,
    required String timestamp,
    required String startTime,
    required String endTime,
    required String remind,
    required String repeat,
    required String color,
  }) async {
    await database.transaction((txn) async {
      await txn
          .rawInsert(
        'INSERT INTO tasks (title, date, timestamp, startTime, endTime, remind, repeat, status, color, isFavourite) VALUES ("$title", "$date", "$timestamp", "$startTime", "$endTime", "$remind", "$repeat", "uncompleted", "$color", 0)',
      )
          .then((value) {
        log('Id number $value inserted Done');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
        if (repeat == 'Once') {
          CubitNotifications.createOnceNotification(
            title: title,
            id: value,
            scheduleTime: DateTime.parse(
                '$date ${timestamp.substring(0, 2)}:${timestamp.substring(2, 4)}:00'),
            remind: remind,
          );
        }
        if (repeat == 'Daily') {
          CubitNotifications.createDailyNotification(
            title: title,
            id: value,
            scheduleTime: DateTime.parse(
                '$date ${timestamp.substring(0, 2)}:${timestamp.substring(2, 4)}:00'),
            remind: remind,
          );
        }
        if (repeat == 'Weekly') {
          CubitNotifications.createWeeklyNotification(
            title: title,
            id: value,
            scheduleTime: DateTime.parse(
                '$date ${timestamp.substring(0, 2)}:${timestamp.substring(2, 4)}:00'),
            remind: remind,
          );
        }
      }).catchError((error) {
        log('Error when inserted ${error.toString()}');
      });
    });
  }

  List<Map> allTasks = [];
  List<Map> uncompletedTasks = [];
  List<Map> completedTasks = [];
  List<Map> favouriteTasks = [];
  bool databaseIsOpened = false;

  void getDataFromDatabase(database) async {
    allTasks = [];
    uncompletedTasks = [];
    completedTasks = [];
    favouriteTasks = [];

    emit(AppDatabaseLoadingState());

    await database
        .rawQuery('SELECT * FROM tasks ORDER BY date ASC ,timestamp ASC')
        .then((value) {
      value.forEach((element) {
        if (element['status'] == 'uncompleted') {
          uncompletedTasks.add(element);
          allTasks.add(element);
        } else {
          completedTasks.add(element);
          allTasks.add(element);
        }
        if (element['isFavourite'] == 1) {
          favouriteTasks.add(element);
        }
      });

      databaseIsOpened = true;
      emit(AppGetDatabaseState());
    });
  }

  Map<String, Object?> notificationTask = {};

  void getNotificationTask(String id) async {
    notificationTask = {};
    emit(AppDatabaseLoadingState());

    if (id != '' && databaseIsOpened == true) {
      await database.rawQuery('SELECT * FROM tasks').then((value) {
        for (var element in value) {
          if (element['id'] == int.parse(id)) {
            notificationTask = element;
          }
        }
        log(notificationTask.toString());
      });
      emit(AppGetNotificationTaskState());
    }
  }

  void changeFavouriteStatus({
    required int id,
    required bool isFavourite,
  }) async {
    isFavourite = !isFavourite;
    await database.rawUpdate(
      'UPDATE tasks SET isFavourite =? WHERE id =?',
      [isFavourite ? 1 : 0, id],
    ).then((value) {
      emit(AppChangeFavouriteStatusState());
      getDataFromDatabase(database);
    });
  }

  void updateTaskStatus({
    required int id,
    required String status,
  }) async {
    await database.rawUpdate(
      'UPDATE tasks SET status =? WHERE id =?',
      [status, id],
    ).then((value) {
      emit(AppUpdateTaskStatusState());
      getDataFromDatabase(database);
    });
  }

  void deleteTask({
    required int id,
  }) async {
    await database.rawDelete(
      'DELETE FROM tasks WHERE id =?',
      [id],
    ).then((value) {
      CubitNotifications.deleteNotification(id: value);
      emit(AppDeleteTaskState());
      getDataFromDatabase(database);
    });
  }

  List<Map> taskPerDay = [];
  List<Map> dailyTasks = [];
  List<Map> weeklyTasks = [];

  void getTaskPerDay({
    required String date,
  }) async {
    taskPerDay = [];
    dailyTasks = [];
    weeklyTasks = [];

    emit(AppDatabaseLoadingState());
    await database
        .rawQuery('SELECT * FROM tasks ORDER BY date ASC ,timestamp ASC')
        .then((value) {
      for (var task in value) {
        if (task['date'] == date) {
          taskPerDay.add(task);
        }
        if (task['repeat'] == 'Daily') {
          dailyTasks.add(task);
          for (var d in dailyTasks) {
            dailyTasks = [];
            if (DateTime.parse(date).isAfter(DateTime.parse(d['date']))) {
              taskPerDay.add(d);
            }
          }
        }
        if (task['repeat'] == 'Weekly') {
          weeklyTasks.add(task);
          for (var w in weeklyTasks) {
            weeklyTasks = [];
            if (DateTime.parse(w['date']).weekday ==
                DateTime.parse(date).weekday) {
              weeklyTasks.add(w);
              for (var x in weeklyTasks) {
                weeklyTasks = [];
                if (DateTime.parse(date).isAfter(DateTime.parse(x['date']))) {
                  taskPerDay.add(x);
                }
              }
            }
          }
        }
      }

      emit(AppGetDatabaseState());
    });
  }

  List<Map> search = [];

  void getSearch({required String text}) async {
    search = [];
    if (search.isEmpty) {
      await database
          .rawQuery('SELECT * FROM tasks ORDER BY date ASC ,timestamp ASC')
          .then((value) {
        for (var element in value) {
          if (element['title'].toString().contains(text.toLowerCase()) ||
              element['title'].toString().contains(text.toUpperCase()) ||
              element['title'].toString().contains(text) && text != '') {
            search.add(element);
          }
        }
        if (text == '') {
          search = [];
        }
        log(search.toString());
        emit(AppGetSearchState());
      });
    }
  }
}
