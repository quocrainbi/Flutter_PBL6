import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbl6/abc.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickImageC() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor:Colors.greenAccent,
          title: const Center(
            child: Text(
              'SELECT IMAGE   ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.greenAccent,
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage("images/bg.png"), fit: BoxFit.cover)),
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          // child:
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 520,
                height: 180,
                decoration: BoxDecoration(
                  color: Color(0xff64abbf),
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.only(top: 30, bottom: 40, left: 0, right: 0),
                child: Stack(
                  children: [
                    // Positioned(
                    // top: 10,
                    // left: 60,
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 25,
                            // left: 100,
                          ),
                          const Text(
                            'Select an Image from?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                            // left: 100,
                          ),
                          MaterialButton(
                              color: Colors.white,
                              child: const Text("    Gallery    ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff64abbf),
                                      fontWeight: FontWeight.bold)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              // padding: EdgeInsets.symmetric(horizontal: 120.0),
                              onPressed: () {
                                pickImage();
                              }),
                          SizedBox(
                            height: 15,
                            // left: 100,
                          ),
                          MaterialButton(
                              color: Colors.white,
                              child: const Text("    Camera    ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff64abbf),
                                      fontWeight: FontWeight.bold)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              // padding: EdgeInsets.symmetric(horizontal: 120.0),
                              onPressed: () {
                                pickImageC();
                              }),
                        ],
                      ),
                      // child: Text(
                      //   'Select an Image from?',
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 17.0,
                      //   ),
                      // ),
                    ),
                    // ),
                    // SizedBox(
                    //   height: 15,
                    //   // left: 100,
                    // ),
                    // Positioned(
                    //   // top: 35,
                    //   // left: 100,
                    //   child: Center(
                    //     child: MaterialButton(
                    //     color: Colors.white,
                    //     child: const Text("Gallery",
                    //         style: TextStyle(
                    //             fontSize: 15,
                    //             color: Color(0xff64abbf), fontWeight: FontWeight.bold)),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(20.0),
                    //     ),
                    //     // padding: EdgeInsets.symmetric(horizontal: 120.0),
                    //     onPressed: () {
                    //       pickImage();
                    //     }),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    //   // left: 100,
                    // ),
                    // Positioned(
                    //   top: 70,
                    //   left: 100,
                    //   child: Center(
                    //     child: MaterialButton(
                    //     color: Colors.white,
                    //     child: const Text("Camera",
                    //         style: TextStyle(
                    //             fontSize: 15,
                    //             color: Color(0xff64abbf), fontWeight: FontWeight.bold)),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(20.0),
                    //     ),
                    //     // padding: EdgeInsets.symmetric(horizontal: 120.0),
                    //     onPressed: () {
                    //       pickImageC();
                    //     }),
                    //   ),
                    // ),
                  ],
                ),
              ),

              image != null
                  ? ClipRect(
                      child: Align(
                          alignment: Alignment.center,
                          heightFactor: 0.7,
                          child: Image.file(image!)),
                    )
                  : const Center(
                      child: Text(
                        'No image selected',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              // Text("No image selected"),
              if (image != null)
                Center(
                    child: ElevatedButton(
                  // width: 10,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xff64abbf)),
                  ),

                  onPressed: (() async {
                    final request = await http.MultipartRequest(
                      'POST',
                      Uri.parse(
                          'http://34.41.149.160:7979/model/predict/image'),
                    );

                    request.files.add(
                      await http.MultipartFile.fromPath(
                        'file', // NOTE - this value must match the 'file=' at the start of -F
                        image!.path,
                        contentType: MediaType('image', 'png'),
                      ),
                    );

                    final response =
                        await http.Response.fromStream(await request.send());
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => App(
                                  response: response,
                                )));
                  }),

                  child: const Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white, // set màu sắc của chữ bên trong nút
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                )),
            ],
          ),
        ));
  }
}
