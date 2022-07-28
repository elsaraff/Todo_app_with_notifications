import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../reusable_components/back_leading_appbar.dart';
import '../reusable_components/home_screen_widgets/task_items_builder.dart';
import '../reusable_components/my_text_form.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var searchController = TextEditingController();

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: const BackLeadingAppBar(),
            title: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: MyTextForm(
                text: 'Search',
                isSearch: true,
                controller: searchController,
                textInputType: TextInputType.text,
                suffix: Icons.search,
                onChangedFunction: () {
                  AppCubit.get(context).getSearch(text: searchController.text);
                },
              ),
            ),
          ),
          body: AppCubit.get(context).search.isEmpty
              ? const Center(
                  child: Text(
                    'Enter Text To Search',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        TaskItemsBuilder(
                          list: AppCubit.get(context).search,
                          isSearch: true,
                        )
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
