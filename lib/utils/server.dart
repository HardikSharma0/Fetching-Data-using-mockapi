import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class Server {
  static Future<http.Response> fetchdata() {
    Future<http.Response> response = http.get(Uri.parse(Constants.url));
    return response;
  }
}
