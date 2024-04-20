import 'package:get_it/get_it.dart';
import 'package:mobile/entities/point_response.dart';
import 'package:mobile/gateway/points_api.dart';

Future<List<PointResponse>> getPoints(String? apiUrl, int z, int x, int y) {
  if (apiUrl == null || apiUrl == "") {
    return Future.value([]);
  }
  return GetIt.I<PointsApi>().getPoints(apiUrl, z, x, y);
}
