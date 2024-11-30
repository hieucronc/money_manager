import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/common/enum/load_status.dart';
import 'package:money_manager/common/enum/screen_size.dart';
import 'package:money_manager/common/utils.dart';
import 'package:money_manager/widgets/screens/detail/detail_screen.dart';
import 'package:money_manager/widgets/screens/menu/menu_screen.dart';

import '../../../repositories/api.dart';
import '../../common_widgets/noti_bar.dart';
import 'list_item_cubit.dart';

class ListItemScreen extends StatelessWidget {
  static const String route = "ListItemScreen";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListItemCubit(context.read<Api>())..loadData(0),
      child: Page(),
    );
  }
}

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Money Manager")),
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListItemCubit, ListItemState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.Error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(notiBar("Login error", true));
        }
      },
      builder: (context, state) {
        var screenSize = calculateScreenSize(MediaQuery.sizeOf(context).width);
        context.read<ListItemCubit>().setScreenSize(screenSize);
        return state.loadStatus == LoadStatus.Loading
            ? Center(child: CircularProgressIndicator())
            : switch (state.screenSize) {
                ScreenSize.Small => ListItemPage(),
                ScreenSize.Medium => ListItemEditPage(),
                _ => ListItemEditMenuPage()
              };
      },
    );
  }
}

class ListItemPage extends StatelessWidget {
  const ListItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListItemCubit, ListItemState>(
      builder: (context, state) {
        var cubit = context.read<ListItemCubit>();
        return Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(children: [
                Expanded(child: Text("${state.total}")),
                state.months.isNotEmpty &&
                        state.selectedMonth == 0 &&
                        state.selectedMonth < state.months.length
                    ? Container()
                    : IconButton(
                        onPressed: () {
                          cubit.loadData(state.selectedMonth - 1);
                        },
                        icon: Icon(Icons.navigate_before)),
                state.months.isNotEmpty &&
                        state.selectedMonth >= 0 &&
                        state.selectedMonth < state.months.length
                    ? Text(state.months[state.selectedMonth])
                    : Container(),
                state.months.isNotEmpty &&
                        state.selectedMonth >= 0 &&
                        state.selectedMonth == state.months.length - 1
                    ? Container()
                    : IconButton(
                        onPressed: () {
                          cubit.loadData(state.selectedMonth + 1);
                        },
                        icon: Icon(Icons.navigate_next)),
              ]),
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) {
                var item = state.trans[index];
                return Card(
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: ListTile(
                    leading: item.amount > 0
                        ? Icon(Icons.add, color: Colors.green)
                        : Icon(Icons.remove, color: Colors.red),
                    title: Row(children: [
                      Expanded(child: Text(item.title)),
                      Text("${item.amount}")
                    ]),
                    subtitle: Text(item.content),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        cubit.deleteItem(item.dateTime);
                      },
                    ),
                  ),
                );
              },
              itemCount: state.trans.length,
            ))
          ],
        );
      },
    );
  }
}

class ListItemEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: ListItemPage()),
        Expanded(child: DetailScreen()),
      ],
    );
  }
}

class ListItemEditMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: MenuScreen()),
        Expanded(child: ListItemPage()),
        Expanded(child: DetailScreen()),
      ],
    );
  }
}
