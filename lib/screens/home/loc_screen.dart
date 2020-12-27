import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_books/model/book.dart';
import 'package:share_books/screens/home/market_screen.dart';
import 'package:share_books/services/authservice.dart';

class LocScreen extends StatefulWidget {
  @override
  _LocScreenState createState() => _LocScreenState();
}

class _LocScreenState extends State<LocScreen> {

  var _category = ["Tất cả", "Tiểu thuyết", "Truyện tranh", "Sách giáo khoa - Giáo trình", "Sách khoa học"];
  String dropdownValue = "Tất cả";
  static double _lowerValue = 0.0;
  static double _upperValue = 100.0;

  RangeValues values = RangeValues(_lowerValue, _upperValue);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lọc kết quả"),
      ),
      body: Container(
        color: Colors.blue[50],
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Icon(Icons.folder_open, color: Colors.blue,),
                        SizedBox(width: 5,),
                        Text("Danh mục")
                      ],
                    ),
                  ),

                  Card(
                    child: DropdownButton(
                      items: _category
                          .map((value) => DropdownMenuItem(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        value: value,
                      ))
                          .toList(),
                      underline: SizedBox(),
                      onChanged: (selectedAccountType) {
                        setState(() {
                          dropdownValue = selectedAccountType;
                        });
                      },
                      value: dropdownValue,
                      isExpanded: true,

                      // hint: Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Text(
                      //     'Danh mục',
                      //     style: TextStyle(fontSize: 17.5, fontStyle: FontStyle.italic),
                      //   ),
                      // ),
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Icon(Icons.attach_money, color: Colors.blue,),
                  SizedBox(width: 5,),
                  Text("Giá"),
                  //SizedBox(width: 20,),
                  Text(" từ " + values.start.toInt().toString() + "0.000 đ" + " đến " + values.end.toInt().toString() + "0.000 đ")
                ],
              ),
            ),

            Card(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 15,
                  overlayColor: Colors.transparent,
                  minThumbSeparation: 10,
                  rangeThumbShape: RoundRangeSliderThumbShape(
                    enabledThumbRadius: 10,
                    disabledThumbRadius: 10,
                  ),
                ),
                child: RangeSlider(
                  activeColor: CupertinoColors.activeGreen,
                  labels: RangeLabels(values.start.abs().toString(), values.end.abs().toString()),
                  min: 0.0,
                  max: 100.0,
                  values: values,
                  onChanged: (val) {
                    setState(() {
                      values = val;
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: FlatButton(
          child: Text(
            "ÁP DỤNG",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Future<List<Book>> futureBooks = AuthService().getBooksFilter(dropdownValue, values.start.toInt().toString(), values.end.toInt().toString());
            streamController.add(futureBooks);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

