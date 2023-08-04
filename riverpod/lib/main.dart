import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod/entryscreen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EntryListScreen(),
    );
  }
}

class entry extends ChangeNotifier {
  List<EntryData> mdata = [];
  int i = 0;

  void addtoarray(String? name, String? rate, String? qty, {String? id}) {
    if (id == null) {
      mdata.add(EntryData((i++).toString(), name, rate, qty));
      notifyListeners();
    } else {
      mdata.add(EntryData(id, name, rate, qty));
      notifyListeners();
    }
  }

  void removedata(String? id) {
    mdata.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void updateData(String? name, String? rate, String? id) {
    mdata.forEach((element) {
      if (element.id == id) {
        element.name = name;
        element.rate = rate;
      }
    });
    notifyListeners();
  }

  getTotalAmount() {
    double tot_amt = 0.0;
    mdata.forEach((element) {
      tot_amt = tot_amt + double.parse(element.rate ?? '0');
    });
    notifyListeners();
    return tot_amt.toStringAsFixed(2);
  }
}

final entryProvider = ChangeNotifierProvider<entry>((ref) {
  return entry();
});
