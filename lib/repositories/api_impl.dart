import 'package:money_manager/models/login.dart';

import 'package:money_manager/models/transaction.dart';

import 'api.dart';
import 'log.dart';

class ApiImpl implements Api {
  Log log;

  List<Transaction> _data = [
    Transaction(dateTime: "2024-10-20 12:00:00", title: "a",
        content: "aa", amount: 1000),
    Transaction(dateTime: "2024-11-21 12:00:00", title: "b",
        content: "bb", amount: -10),
    Transaction(dateTime: "2024-11-21 13:00:00", title: "c",
        content: "cc", amount: -20),
    Transaction(dateTime: "2024-11-21 14:00:00", title: "d",
        content: "dd", amount: -30),
  ];

  ApiImpl(this.log) {
    _data.sort((a,b) => b.dateTime.compareTo(a.dateTime));
  }
  Future<void> delay() async{
    await Future.delayed(Duration(seconds: 1));
  }


  @override
  Future<void> addTransaction(Transaction transaction) async {
    await delay();
    for (int i = 0; i < _data.length; i++) {
      if (_data[i].dateTime == transaction.dateTime) throw Exception("Duplicate transaction");
    }
    _data.add(transaction);
    _data.sort((a,b) => b.dateTime.compareTo(a.dateTime));
  }

  @override
  Future<bool> checkLogin(Login login) async {
   await delay();
   if (login.username == '1' && login.password == '1') {
     return Future(() => true);
   }
   return Future(() => false);
  }

  @override
  Future<void> deleteTransaction(String dateTime) async {
    await delay();
    for (int i = 0; i < _data.length; i++) {
      if (_data[i].dateTime == dateTime) {
        _data.removeAt(i);
        return;
      }
    }
    throw Exception("Transaction not found");
  }

  @override
  Future<void> editTransaction(Transaction transaction) async {
    await delay();
    for (int i = 0; i < _data.length; i++) {
      if (_data[i].dateTime == transaction.dateTime) {
        _data[i] = transaction;
        return;
      }
    }
    throw Exception("Transaction not found");
  }

  @override
  Future<List<String>> getMonths() async {
    await delay();
    Set<String> r = {};
    for (int i = 0; i < _data.length; i++) {
      var tmp = _data[i].dateTime.substring(0,7) + "-01 00:00:00";
      r.add(tmp);
    }
    return r.toList();
  }

  @override
  Future<double> getTotal() async {
    await delay();
    double total = 0;
    for (int i = 0; i < _data.length; i++) {
      total += _data[i].amount;
      }
    return total;
  }

  @override
  Future<List<Transaction>> getTransactions(String month) async {
    await delay();
    List<Transaction> r = [];
    for (int i = 0; i < _data.length; i++) {
      var tmp = _data[i].dateTime.substring(0,7);
      if (month.startsWith(_data[i].dateTime))
        r.add(_data[i]);
    }
    return r;
  }

}