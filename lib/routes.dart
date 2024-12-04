import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/widgets/screens/add_edit/add_edit_screen.dart';
import 'package:money_manager/widgets/screens/detail/detail_screen.dart';
import 'package:money_manager/widgets/screens/list_item/list_item_cubit.dart';
import 'package:money_manager/widgets/screens/list_item/list_item_screen.dart';
import 'package:money_manager/widgets/screens/login/login_screen.dart';

Route<dynamic>? mainRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.route:
      return MaterialPageRoute(builder: (context) => LoginScreen());
    case ListItemScreen.route:
      return MaterialPageRoute(
          builder: (context) => ListItemScreen(),
          settings: RouteSettings(name: ListItemScreen.route));
    case DetailScreen.route:
      var cubit = (settings.arguments as Map<String, dynamic>)['cubit']
          as ListItemCubit;
      return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
                value: cubit,
                child: Scaffold(
                    appBar: AppBar(title: Text("Detail")),
                    body: DetailScreen()),
              ));
    case AddEditScreen.route:
      var cubit = (settings.arguments as Map<String, dynamic>)['cubit']
          as ListItemCubit;
      var isAdding =
          (settings.arguments as Map<String, dynamic>)['isAdding'] as bool;
      return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
            value: cubit,
            child: AddEditScreen(isAdding, cubit.state.screenSize)),
      );
    default:
      return MaterialPageRoute(builder: (context) => LoginScreen());
  }
}
