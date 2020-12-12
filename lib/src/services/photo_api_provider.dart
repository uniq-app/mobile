import 'dart:convert';

import 'package:http/http.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/models/photo.dart';

class PhotoApiProvider {
  Client client = Client();
  // Local jest na http://10.0.2.2:80/images
  // final String _apiUrl = 'http://192.168.43.223:80/images';
  final String _apiUrl = 'http://192.168.43.223:80/images';

  String get apiUrl => _apiUrl;
}
