import 'package:http/http.dart' as http;

void sendPath(String path) async {
  var uri = Uri.parse('http://127.0.0.1:8000/receive_path/');
  // ignore: unused_local_variable
  String status = '';

  try{
    var response = await http.post(
      uri,
      body: {'path': path}
    );
    if (response.statusCode == 200) {
      status = 'Success';
      print('Success');
    } else {
      status = 'Failed';
    }
  }
  
  catch(e){
    status = 'Failed';
  }
}
