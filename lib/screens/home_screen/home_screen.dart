import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/functions.dart';
import '../../core/notification_helper.dart';
import '../../reusable_components/my_button.dart';
import '../add_task_screen.dart';
import '../notification_screen.dart';
import '../schedule_screen.dart';
import '../search_screen.dart';
import 'home_taps/all_tap.dart';
import 'home_taps/completed_tap.dart';
import 'home_taps/uncompleted_tap.dart';
import 'home_taps/favourite_tap.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int currentIndex = 0;

  final List<Tab> myTabs = const [
    Tab(child: Text('All', style: black14)),
    Tab(child: Text('Completed', style: black14)),
    Tab(child: Text('Uncompleted', style: black14)),
    Tab(child: Text('Favourite', style: black14)),
  ];

  final List<Widget> myScreens = const [
    AllTap(),
    CompletedTaps(),
    UncompletedTaps(),
    FavouriteTaps(),
  ];

  @override
  void initState() {
    super.initState();
    listenNotifications();
    tabController = TabController(vsync: this, length: myTabs.length);
  }

  void listenNotifications() {
    NotificationHelper.onNotifications.stream.listen(onClickNotifications);
  }

  onClickNotifications(payload) {
    if (payload != null) {
      return navigateTo(context, NotificationScreen(payload));
    }
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        setState(() {
          currentIndex = tabController.index;
        });
      }
    });
    return Scaffold(
      appBar: AppBar(
          title: Column(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text('Home', style: TextStyle(color: Colors.black)),
                  ),
                  const Spacer(),
                  IconButton(
                      tooltip: 'Search',
                      onPressed: () {
                        navigateTo(context, const SearchScreen());
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      )),
                  IconButton(
                      tooltip: 'Notifications',
                      onPressed: () {
                        navigateTo(context, const NotificationScreen(''));
                      },
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Colors.black,
                      )),
                  IconButton(
                      tooltip: 'Schedule',
                      onPressed: () {
                        navigateTo(context, const ScheduleScreen());
                      },
                      icon: const Icon(
                        Icons.calendar_month_sharp,
                        color: Colors.black,
                      )),
                ],
              ),
              Container(height: 2, color: Colors.black26)
            ],
          ),
          bottom: TabBar(
            controller: tabController,
            isScrollable: true,
            indicatorColor: currentIndex == 1
                ? blueColor
                : currentIndex == 2
                    ? redColor
                    : currentIndex == 3
                        ? yellowColor
                        : Colors.black45,
            indicatorWeight: 5,
            tabs: myTabs,
          )),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: myScreens,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: MyButton(
              text: 'Add a Task',
              onPressed: () {
                navigateTo(context, const AddTaskScreen());
              },
            ),
          )
        ],
      ),
    );
  }
}
