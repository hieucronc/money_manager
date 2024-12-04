import 'package:flutter/widgets.dart';

class AddEditScreen extends StatelessWidget {

  static const String route = "AddEditScreen";
  final bool isAdding;

  AddEditScreen(this.isAdding);
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("route"));
  }


}