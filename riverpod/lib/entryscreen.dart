import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod/itemList.dart';
import 'package:river_pod/main.dart';

class EntryListScreen extends StatefulWidget {
  const EntryListScreen({Key? key}) : super(key: key);

  @override
  State<EntryListScreen> createState() => _EntryListScreenState();
}

class _EntryListScreenState extends State<EntryListScreen> {
  List<EntryData> mList = [];

  @override
  void initState() {
    // getUserListdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List of Added Items',
        ),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ItemList();
                    });
              },
              icon: Icon(Icons.list))
        ],
      ),
      body: Consumer(builder: (context, WidgetRef ref, child) {
        final items = ref.watch(entryProvider).mdata;
        return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(items[index].name ?? ''),
                  subtitle: Text(items[index].rate ?? ''),
                  trailing: Text('qty ${items[index].qty}'),
                  leading: Text(items[index].id ?? ''),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return MainClass(
                            id: items[index].id,
                            name: items[index].name,
                            rate: items[index].rate,
                          );
                        });
                  },
                ),
              );
            });
      }),
      bottomNavigationBar: Consumer(builder: (context, WidgetRef ref, child) {
        var totalamount = ref.watch(entryProvider).getTotalAmount();
        return Container(
            child: Row(
          children: [Text('Net Amount'), Text(totalamount ?? '')],
        ));
      }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return MainClass();
                });
          },
          child: Icon(Icons.add)),
    );
  }

  // void getUserListdata() {
  //   mList = [];
  //   mList.add(EntryData('Fan', '1200'));
  //   mList.add(EntryData('TV', '5000'));
  //   mList.add(EntryData('Grinder', '3200'));
  // }
}

class EntryData {
  String? id, name, rate, status, qty;
  EntryData(this.id, this.name, this.rate, this.qty, {this.status});
}

class MainClass extends StatefulWidget {
  String? id, name, rate, qty;
  MainClass({this.id, this.name, this.rate, this.qty});

  @override
  State<MainClass> createState() =>
      _MainClassState(this.id, this.name, this.rate, this.qty);
}

class _MainClassState extends State<MainClass> {
  String? Name, Rate, Id, Qty;

  final formkey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController qty = TextEditingController();
  _MainClassState(this.Id, this.Name, this.Rate, this.Qty);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = TextEditingController(text: Name);
    rate = TextEditingController(text: Rate);
    qty = TextEditingController(text: Qty);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Main Class'),
        ),
        body: Consumer(builder: (context, WidgetRef ref, child) {
          return Form(
              key: formkey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: name,
                    ),
                    TextFormField(
                      controller: rate,
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: qty,
                      keyboardType: TextInputType.number,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            print('id is $Id');
                            if (Id != null) {
                              ref
                                  .read(entryProvider.notifier)
                                  .updateData(name.text, rate.text, Id);
                            } else {
                              ref
                                  .read(entryProvider.notifier)
                                  .addtoarray(name.text, rate.text, qty.text);
                            }

                            setState(() {
                              Navigator.pop(context);

                              name.clear();
                              rate.clear();
                            });
                          }
                        },
                        child: Text('Submit'))
                  ],
                ),
              ));
        }),
      ),
    );
  }
}
