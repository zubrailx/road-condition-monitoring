import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:mobile/entities/point_response.dart';
import 'package:http/http.dart' as http;
import 'package:talker_flutter/talker_flutter.dart';

class PointsApi {
  Future<List<PointResponse>> getPoints(
      String apiUrl, int z, int x, int y, DateTime? begin, DateTime? end) async {

    final queryParams = <String, String>{};

    if (begin != null) {
      queryParams['begin'] = begin.toIso8601String();
    }

    if (end != null) {
      queryParams['end'] = end.toIso8601String();
    }

    final uri = Uri.parse("$apiUrl/points/$z/$x/$y").replace(queryParameters: queryParams);
    final response = await http.get(uri);

    GetIt.I<Talker>().debug('API: $uri');

    if (response.statusCode == 200) {
      // Assuming jsonString is the JSON string received from the internet
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => PointResponse.fromJson(json)).toList();
    }
    return Future.error(response.body);
  }
}
