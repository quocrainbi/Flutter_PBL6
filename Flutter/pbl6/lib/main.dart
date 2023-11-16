import 'package:flutter/material.dart';
import 'package:pbl6/image.dart';

void main() {
  runApp(MaterialApp(
    home: MainApp(), // Your main app widget
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.greenAccent, // Thay đổi màu nền ở đây
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Căn chỉnh từ đầu cột
            crossAxisAlignment: CrossAxisAlignment.center, // Căn chỉnh theo trục ngang
            children: [
              SizedBox(height: 50), // Khoảng cách từ đỉnh trang
              Text(
                'PBL6 \n IMG',
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 300), // Khoảng cách giữa dòng văn bản và button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyWidget(),
                    ),
                  );
                },
                child: Text('Start',
                  style:TextStyle(fontSize: 26,fontWeight: FontWeight.bold) ,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// class MyWidget extends StatefulWidget {
//   const MyWidget({Key? key}) : super(key: key);

//   @override
//   State<MyWidget> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<MyWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
