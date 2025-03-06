import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class dogapi extends StatefulWidget {
  const dogapi({super.key});

  @override
  State<dogapi> createState() => _dogapiState();
}

class _dogapiState extends State<dogapi> {
  //ประกาศตัวแปร users แบบ list เก็บข้อมูลแบบ ไดนามิกได้
  //dynamic เก็บตัวแปรได้หลายชนิด
  List<dynamic> users = [];

  //ประกาศตัวแปรสำหรับเปลี่ยนหน้า
  int pagenumber = 1;

  //ประกาศตัวแปรสำหรับเก็บสถานะ
  bool isLoding = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('uers api'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          //Expanded ทำให้ไม่ล้นหน้าจอ
          Expanded(
            //users.isEmpty เช็คว่าตัวแปรนี้ เป็นค่าว่างหรือไม่ ? = if : = else
            child: users.isEmpty
                ? const Center(
                    child: Text('NO Data'),
                  )

                //widject แบบ lisetview เพราะตัวแปร user เป็นแบบ listview
                : ListView.builder(
                    itemCount: users.length + 1,
                    itemBuilder: (context, index) {
                      if (index == users.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      // แกะข้อมูลจากuser มาใส่ตัวแปร
                      final user = users[index];
                      final email = user['email'] ?? '';
                      final firstName = user['first_name'] ?? '';
                      final lastName = user['last_name'] ?? '';
                      final avatar = user['avatar'] ?? '';

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(avatar),
                        ),
                        title: Text('$firstName $lastName'),
                        subtitle: Text(email),
                      );
                    }),
          ),
          ElevatedButton(
            onPressed: callAPI,
            child: Text('load Data'),
          )
        ],
      ),
    );
  }

// function สำหรับ call api
  Future<void> callAPI() async {
    try {
      print('hello word');

      //                         ชื่อ เว็ป           ชื่อ path
      var url =
          Uri.https('reqres.in', 'api/users', {'page': pagenumber.toString()});

      //ทำการยิง api ใช้ method get
      var respone = await http.get(url);
      print(respone.statusCode);
      print(respone.body);

      //ตรวจสอบเงื่อนไขcode ต้องเป็น 200 เท่านั้น
      if (respone.statusCode == 200) {
        //แปลงจาก json ให้อยู่ใน Map
        var jsonResponse =
            convert.jsonDecode(respone.body) as Map<String, dynamic>;
        //ถ้ามีข้อมูลแล้วนำไปเก็บที่ ตัวแปร item

        //เอาข้อมูล key ชื่อ data ไปเก็บ item
        // ?? ถ้าไม่มีข้อมูล ให้เอา [] ไปใส่แทน
        var items = jsonResponse['data'] ?? [];

        //ทำงานใหม่หมด รีเฟส
        setState(() {
          users.addAll(items);
          pagenumber++;
        });
      }
    } catch (err) {
      print(err);
    }
  }
}
