import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/common/enum/load_status.dart';

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
        return state.loadStatus == LoadStatus.Loading
            ? Center(child: CircularProgressIndicator())
            : ListItemPage();
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
        return Column(
          children: [
        Row(children: [
          Expanded(child: Text("${state.total}")),
          state.months.isNotEmpty &&
                  state.selectedMonth >= 0 &&
                  state.selectedMonth < state.months.length
              ? Text(state.months[state.selectedMonth])
              : Container()
        ]),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Row(
                      children: [
                    Expanded(child: Text(state.trans[index].title)),
                    Text("${state.trans[index].amount}")
                  ]
                  ),
                  subtitle: Text(state.trans[index].content),
                ),
              );
            },
            itemCount: state.trans.length,
          )
        )
          ],
        );
      },
    );
  }
}
