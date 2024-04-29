import "dart:convert";
import "dart:typed_data";
import 'dart:io';

class ApiService {
  static String host = "https://holy-tightly-snail.ngrok-free.app";
  // static String host = "http://10.0.0.2";

  Map<String, String> header() => <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      };
  HttpClient httpClient = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

  Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    Uri apiUrl = Uri.parse('$host/$url');

    final request = await httpClient.postUrl(apiUrl);

    request.headers.set('Content-Type', 'application/json; charset=UTF-8');
    request.add(utf8.encode(jsonEncode(body)));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    final map = jsonDecode(responseBody);

    map['status'] = response.statusCode;

    return map;
  }

  Future<Map<String, dynamic>> login(
      {required String email, required String password, bool isNew = false}) {
    return post(url: 'login', body: {
      'email': email,
      'password': password,
      'new': isNew,
    });
  }

  Future<Map<String, dynamic>> classify({required Uint8List image}) {
    return post(url: 'classify', body: {
      'image': base64Encode(image.toList()),
    });
  }
}
