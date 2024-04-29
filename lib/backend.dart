import "dart:async";
import "dart:convert";
import "dart:typed_data";
import 'dart:io';

class ApiService {
  // static String host = "http://10.0.2.2:8000";
  static String host = "https://holy-tightly-snail.ngrok-free.app";

  HttpClient httpClient = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true)
    ..connectionTimeout = const Duration(seconds: 60);

  Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    Uri apiUrl = Uri.parse('$host/$url');

    final request = await httpClient.postUrl(apiUrl);

    request.headers.set('Content-Type', 'application/json; charset=UTF-8');
    request.add(utf8.encode(jsonEncode(body)));

    final response =
        await request.close().timeout(httpClient.connectionTimeout as Duration);

    final responseBody = await response.transform(utf8.decoder).join();

    final map = jsonDecode(responseBody);

    map['status'] = response.statusCode;

    return map;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    bool isNew = false,
  }) {
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
