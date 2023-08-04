import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_pod/entryscreen.dart';
import 'package:river_pod/main.dart';

class ItemList extends StatefulWidget {
  const ItemList({Key? key}) : super(key: key);

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List<EntryData> mList = [];
  int counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserListdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item List'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Consumer(builder: (context, WidgetRef ref, child) {
          return ListView.builder(
              itemCount: mList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  color:
                      mList[index].status == '0' ? Colors.white : Colors.green,
                  child: ListTile(
                    title: Text(mList[index].name ?? ''),
                    subtitle: Text(mList[index].rate ?? ''),
                    leading: Text(mList[index].id ?? ''),
                    trailing: Container(
                      height: 50,
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: 20,
                              width: 20,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      counter--;
                                    });
                                  },
                                  icon: Icon(Icons.remove))),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              height: 20,
                              width: 20,
                              child:
                                  Center(child: Text(mList[index].qty ?? ''))),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              height: 20,
                              width: 20,
                              child: IconButton(
                                  onPressed: () {
                                    addDatatoArray(
                                        ref,
                                        mList[index].name,
                                        mList[index].rate,
                                        mList[index].qty,
                                        mList[index].id);
                                  },
                                  icon: Icon(Icons.add)))
                        ],
                      ),
                    ),
                    onTap: () {
                      // setState(() {
                      //   if (mList[index].status == '0') {
                      //     mList[index].status = "1";
                      //   } else {
                      //     mList[index].status = '0';
                      //     ref
                      //         .read(entryProvider.notifier)
                      //         .removedata(mList[index].id);
                      //   }
                      // });
                      // ref.read(entryProvider.notifier).addtoarray(
                      //       mList[index].name,
                      //       mList[index].rate,
                      //       mList[index].qty,
                      //       id: mList[index].id,
                      //     );
                    },
                  ),
                );
              });
        }),
        
      ),
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

  void getUserListdata() {
    mList = [];

    mList.add(EntryData('10001', 'Fan', '1200', '0', status: '0'));
    mList.add(EntryData('10002', 'TV', '5000', '0', status: '0'));
    mList.add(EntryData('10003', 'Grinder', '3200', '0', status: '0'));
  }

  void addDatatoArray(
      WidgetRef ref, String? name, String? rate, String? qty, String? id) {
    ref.read(entryProvider.notifier).addtoarray(name, rate, qty, id: id);
  }
}
