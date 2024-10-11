import 'package:budget_buddy/data/model/add_date.dart';
import 'package:budget_buddy/widgets/chart.dart';
import 'package:budget_buddy/widgets/navbar.dart';
import 'package:flutter/material.dart';
import '../data/utility.dart';

class Statistic extends StatefulWidget {
  const Statistic({Key? key}) : super(key: key);

  @override
  State<Statistic> createState() => _StatistikState();
}

ValueNotifier<int> kj = ValueNotifier(0);

class _StatistikState extends State<Statistic> {
  List day = ['Hari', 'Minggu', 'Bulan'];
  List f = [today(), week(), month()];
  List<Add_data> a = [];
  int index_color = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavbar(),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: kj,
          builder: (BuildContext context, dynamic value, Widget? child) {
            a = f[value];
            return scroolview();
          },
        ),
      ),
    );
  }

  CustomScrollView scroolview() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
            child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Statistik',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...List.generate(3, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          index_color = index;
                          kj.value = index;
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.grey[600]!, width: 1.5),
                          color: index_color == index
                              ? const Color(0xff7FC7D9)
                              : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          day[index],
                          style: TextStyle(
                              color: index_color == index
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Chart(
              indexx: index_color,
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Riwayat',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        )),
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (context, index) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset('images/${a[index].title}.png', height: 40),
              ),
              title: Text(a[index].explain,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              subtitle: Text(
                '${a[index].datetime.day}/${a[index].datetime.month}/${a[index].datetime.year}',
              ),
              trailing: Text(
                'Rp ${a[index].amount}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: a[index].IN == 'Pendapatan'
                        ? Colors.green
                        : Colors.red),
              ),
            );
          },
          childCount: a.length,
        ))
      ],
    );
  }
}
