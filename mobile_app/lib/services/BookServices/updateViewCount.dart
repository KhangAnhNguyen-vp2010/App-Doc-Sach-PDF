import 'package:http/http.dart' as http;
import 'package:mobile_app/services/api/api_urls.dart';

Future<void> incrementViewCount(String id) async {
  try{
    await http.post(Uri.parse('$baseUrl/Sach/$id/increment-view'));
  }
  catch(e){
    print(e);
  }
}