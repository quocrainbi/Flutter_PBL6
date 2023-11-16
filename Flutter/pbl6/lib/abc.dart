import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class App extends StatefulWidget {
  final http.Response response;

  const App({Key? key, required this.response}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('Image from Response'),
      ),
      backgroundColor: Colors.greenAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImage(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _saveImageToGallery(),
              child: Text('Lưu ảnh vào thư viện'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.response.statusCode == 200) {
      return Image.memory(
        widget.response.bodyBytes,
        // Có thể tùy chỉnh các thuộc tính khác ở đây, ví dụ: width, height, fit, v.v.
      );
    } else {
      return Text('Không thể tải hình ảnh. Mã trạng thái: ${widget.response.statusCode}');
    }
  }

  Future<void> _saveImageToGallery() async {
    try {
      // Convert dữ liệu hình ảnh từ Response thành Image
      ui.Image image = await decodeImageFromList(Uint8List.fromList(widget.response.bodyBytes));

      // Lưu ảnh vào thư viện
      final result = await ImageGallerySaver.saveImage(Uint8List.fromList(widget.response.bodyBytes));

      // Hiển thị thông báo kết quả
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['isSuccess'] ? 'Lưu ảnh thành công' : 'Lưu ảnh thất bại'),
        ),
      );
    } catch (e) {
      print('Lỗi khi lưu ảnh: $e');
    }
  }
}

