// ignore_for_file: unused_import

import 'package:budget_buddy/data/model/add_date.dart';
import 'package:flutter/material.dart';
import '../data/utility.dart';
import 'package:budget_buddy/widgets/navbar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var history;
  final box = Hive.box<Add_data>('data');
  final List<String> day = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, value, child) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 270,
                      child: _head(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        children: [
                          Text(
                            'Riwayat Transaksi',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        history = box.values.toList()[index];
                        return getList(history, index);
                      },
                      childCount: box.length,
                    ),
                  )
                ],
              );
            }),
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }

  Widget getList(Add_data history, int index) {
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          history.delete();
        },
        child: get(index, history));
  }

  ListTile get(int index, Add_data history) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('images/${history.title}.png', height: 40),
      ),
      title: Text(history.explain,
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle: Text(
          '${day[history.datetime.weekday - 1]}, ${history.datetime.day}/${history.datetime.month}/${history.datetime.year}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          )),
      trailing: Text(
          NumberFormat.currency(locale: 'id', symbol: 'Rp. ')
              .format(double.parse(history.amount)),
          style: TextStyle(
              color: history.IN == 'Pendapatan' ? Colors.green : Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _head() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xff7FC7D9),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: const Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Selamat Datang di Budget Buddy ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 150,
          left: 20,
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width - 40,
            decoration: BoxDecoration(
              color: const Color(0xffDCF2F1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Saldo Anda',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 14),
                Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: Row(
                    children: [
                      Text(
                        NumberFormat.currency(locale: 'id', symbol: 'Rp. ')
                            .format(double.parse(total().toString())),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
