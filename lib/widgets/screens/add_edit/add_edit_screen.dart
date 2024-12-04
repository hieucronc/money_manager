import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manager/common/utils.dart';
import 'package:money_manager/models/transaction.dart';
import 'package:money_manager/widgets/screens/list_item/list_item_screen.dart';

import '../../../common/enum/screen_size.dart';
import '../list_item/list_item_cubit.dart';

class AddEditScreen extends StatelessWidget {
  static const String route = "AddEditScreen";
  final bool isAdding;
  final ScreenSize oldScreenSize;
  ScreenSize newScreenSize = ScreenSize.Small;
  AddEditScreen(this.isAdding, this.oldScreenSize);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(isAdding ? "Add" : "Edit")),
        body: BlocBuilder<ListItemCubit, ListItemState>(
          builder: (context, state) {
            var _title = TextEditingController(text: "");
            var _content = TextEditingController(text: "");
            var _amount = TextEditingController(text: "");
            var _cubit = context.read<ListItemCubit>();
            if (!isAdding) {
              _title.text = state.trans[state.selectedIdx].title;
              _content.text = state.trans[state.selectedIdx].content;
              _amount.text = state.trans[state.selectedIdx].amount.toString();
            }
            newScreenSize =
                calculateScreenSize(MediaQuery.sizeOf(context).width);
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _title,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter the title of the transaction',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _content,
                    decoration: InputDecoration(
                      labelText: 'Content',
                      hintText: 'Enter the content of the transaction',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _amount,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      hintText: 'Enter the amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.all(10),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () {
                        if (!isAdding) {
                          _cubit.editItem(Transaction(
                              dateTime: state.trans[state.selectedIdx].dateTime,
                              title: _title.text,
                              content: _content.text,
                              amount: double.parse(_amount.text)));
                          Navigator.of(context).popUntil(
                              ModalRoute.withName(ListItemScreen.route));
                        } else {
                          _cubit.addItem(Transaction(
                              dateTime:
                                  DateTime.now().toString().substring(0, 19),
                              title: _title.text,
                              content: _content.text,
                              amount: double.parse(_amount.text)));
                          pop(context);
                        }
                      },
                      child: Text("Save"))
                ],
              ),
            );
          },
        ));
  }

  void pop(BuildContext context) {
    if (oldScreenSize == newScreenSize)
      Navigator.of(context).pop();
    else
      Navigator.of(context).popUntil(ModalRoute.withName(ListItemScreen.route));
  }
}
