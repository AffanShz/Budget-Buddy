// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:budget_buddy/data/model/add_date.dart';
import 'package:budget_buddy/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Addscreen extends StatefulWidget {
  const Addscreen({super.key});

  @override
  State<Addscreen> createState() => _AddscreenState();
}

class _AddscreenState extends State<Addscreen> {
  final box = Hive.box<Add_data>('data');
  DateTime date = DateTime.now();
  String? selectedItem;
  String? selectedItempp;
  final TextEditingController explain_C = TextEditingController();
  FocusNode ex = FocusNode();
  final TextEditingController rp_C = TextEditingController();
  FocusNode rp = FocusNode();
  final List<String> _item = ['Pendapatan', 'Transfer', 'Belanja', 'Tagihan'];
  final List<String> _itempp = ['Pendapatan', 'Pengeluaran'];

  @override
  void initState() {
    super.initState();
    ex.addListener(() {
      setState(() {});
    });
    rp.addListener(() {
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Stack(alignment: AlignmentDirectional.center, children: [
          background_container(context),
          Positioned(
            top: 120,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              height: 550,
              width: 340,
              child: Column(
                children: save(context),
              ),
            ),
          )
        ]),
      ),
    );
  }

  List<Widget> save(BuildContext context) {
    return [
      SizedBox(height: 50),
      drop(),
      SizedBox(height: 30),
      title(),
      SizedBox(height: 30),
      amount(),
      SizedBox(height: 30),
      penpeng(),
      SizedBox(height: 30),
      date_time(context),
      const Spacer(),
      button_save(),
      SizedBox(height: 20),
    ];
  }

  Padding penpeng() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: Color(0xffC5C5C5),
          ),
        ),
        child: DropdownButton<String>(
          value: selectedItempp,
          onChanged: ((value) {
            setState(() {
              selectedItempp = value!;
            });
          }),
          items: _itempp
              .map((e) => DropdownMenuItem(
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Text(
                            e,
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    value: e,
                  ))
              .toList(),
          selectedItemBuilder: (BuildContext context) => _itempp
              .map((e) => Row(
                    children: [Text(e)],
                  ))
              .toList(),
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              'Jenis',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          dropdownColor: Colors.white,
          isExpanded: true,
          underline: Container(),
        ),
      ),
    );
  }

  GestureDetector button_save() {
    return GestureDetector(
      onTap: () {
        if (selectedItem != null && rp_C.text.isNotEmpty) {
          var add = Add_data(
            selectedItem!,
            rp_C.text,
            date,
            explain_C.text,
            selectedItem!,
          );
          box.add(add);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Home()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tolong Lengkapi Data'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Color(0xff365486)),
        width: 120,
        height: 40,
        child: Text('Simpan',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget date_time(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2, color: Color(0xffc5c5c5)),
      ),
      width: 300,
      child: TextButton(
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2023),
              lastDate: DateTime(2100));
          if (newDate == Null) return;
          setState(() {
            date = newDate!;
          });
        },
        child: Text(
          'Tanggal : ${date.day}/${date.month}/${date.year}',
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Padding amount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        keyboardType: TextInputType.number,
        focusNode: rp,
        controller: rp_C,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          labelText: 'Jumlah',
          labelStyle: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Color(0xffc5c5c5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 2, color: Color(0xff365486)),
          ),
        ),
        onChanged: (String value) {
          // Remove unwanted characters
          final String newValue = value.replaceAll(RegExp(r'[^\d]'), '');
          // Check if any characters remain
          if (newValue.isNotEmpty) {
            // Try parsing to int (returns null if not a valid number)
            final int? parsedValue = int.tryParse(newValue);
            if (parsedValue != null) {
              // Update controller with the parsed integer
              rp_C.text = parsedValue.toString();
            } else {
              // Reset the controller to an empty string (optional)
              rp_C.text = '';
            }
          } else {
            // Empty input, reset the controller (optional)
            rp_C.text = '';
          }
        },
      ),
    );
  }

  Padding title() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        focusNode: ex,
        controller: explain_C,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          labelText: 'Keterangan',
          labelStyle: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 2, color: Color(0xffc5c5c5))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 2, color: Color(0xff365486))),
        ),
      ),
    );
  }

  Padding drop() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Color(0xffc5c5c5)),
        ),
        child: DropdownButton<String>(
          value: selectedItem,
          onChanged: ((value) {
            setState(() {
              selectedItem = value!;
            });
          }),
          items: _item
              .map((e) => DropdownMenuItem(
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            child: Image.asset('images/${e}.png'),
                          ),
                          SizedBox(width: 10),
                          Text(e, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    value: e,
                  ))
              .toList(),
          selectedItemBuilder: (BuildContext context) => _item
              .map((e) => Row(
                    children: [
                      Container(
                        width: 40,
                        child: Image.asset('images/${e}.png'),
                      ),
                      SizedBox(width: 10),
                      Text(e)
                    ],
                  ))
              .toList(),
          hint: Text('Pilih Kategori', style: TextStyle(color: Colors.grey)),
          dropdownColor: Colors.white,
          isExpanded: true,
          underline: Container(),
        ),
      ),
    );
  }

  Column background_container(BuildContext context) {
    return Column(children: [
      Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xff365486),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(Home());
                        },
                        child: Icon(Icons.arrow_back, color: Colors.white)),
                    const Text("Tambahkan Transaksi",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Icon(Icons.bar_chart, color: Colors.white)
                  ]),
            )
          ],
        ),
      )
    ]);
  }
}
