import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:mobile/entities/point_response.dart';
import 'package:http/http.dart' as http;
import 'package:talker_flutter/talker_flutter.dart';

class PointsApi {
  Future<List<PointResponse>> getPoints(
      String apiUrl, int z, int x, int y) async {
    final requestUrl = "$apiUrl/points/$z/$x/$y";
    final response = await http.get(Uri.parse(requestUrl));

    GetIt.I<Talker>().debug('API: $requestUrl');

    if (response.statusCode == 200) {
      // Assuming jsonString is the JSON string received from the internet
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => PointResponse.fromJson(json)).toList();
    }
    return Future.error(response.body);
  }
}
