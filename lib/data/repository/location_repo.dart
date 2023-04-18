import 'package:delivrd_driver/data/datasource/remote/dio/dio_client.dart';
import 'package:delivrd_driver/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class LocationRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  LocationRepo({this.dioClient, this.sharedPreferences});

  Future<http.StreamedResponse> updateLocation(String latitude, String longitude, String address, String token) async {

    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.UPDATE_LOCATION_URI}'));
    // request.headers.addAll(<String,String>{'Authorization': 'Bearer ${token}'});

    Map<String, String> _fields = Map();
    {
      _fields.addAll(<String, String>{
        '_method': 'post',
        'token': token,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
      });
    }
    request.fields.addAll(_fields);

    http.StreamedResponse response = await request.send();
    print("Test responce");
    //
    print(response);
    return response;

  }

}
