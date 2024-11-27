import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:money_manager/common/enum/load_status.dart';

import '../../../models/transaction.dart';
import '../../../repositories/api.dart';

part 'list_item_state.dart';

class ListItemCubit extends Cubit<ListItemState> {
  Api api;

  ListItemCubit(this.api) : super(ListItemState.init());

  Future<void> loadData(int monthIdx) async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading, selectedMonth: monthIdx));
    try {
      var months = await api.getMonths();
      var total = await api.getTotal();
      List<Transaction> trans = months.isEmpty
          ? []
          : await api.getTransactions(months[monthIdx]);

      emit(state.copyWith(
        months: months,
        total: total,
        trans: trans,
        loadStatus: LoadStatus.Done,
      ));
    } catch (ex) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }
  void deleteItem(String dateTime) async {
    emit(state.copyWith(loadStatus: LoadStatus.Loading));
    try {
    await api.deleteTransaction(dateTime);
    await loadData(state.selectedMonth);
    } catch (ex) {
      emit(state.copyWith(loadStatus: LoadStatus.Error));
    }
  }
}
