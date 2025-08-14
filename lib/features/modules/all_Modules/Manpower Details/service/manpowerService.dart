import 'package:dio/dio.dart';
import '../../../../../core/api/dio.dart';

class ManpowerAPI {
  static final dio = DioClient.dio;

  /// Fetch manpower list by type
  static Future<Map<String, dynamic>> fetchManpower(String type) async {
    try {
      final res = await dio.get(
        "/manpower",
        queryParameters: {"type": type},
      );
      return {
        "success": true,
        "data": res.data,
      };
    } catch (e) {
      return {
        "success": false,
        "data": null,
        "error": e.toString(),
      };
    }
  }

  /// Create manpower
  static Future<Map<String, dynamic>> postManpower(
      String type, dynamic data) async {
    try {
      final res = await dio.post(
        "/manpower",
        queryParameters: {"type": type},
        data: data,
      );
      return {
        "success": true,
        "data": res.data,
      };
    } catch (e) {
      return {
        "success": false,
        "data": null,
        "error": e.toString(),
      };
    }
  }

  /// Fetch manpower by ID
  static Future<Map<String, dynamic>> fetchManpowerById(String id) async {
    try {
      final res = await dio.get("/manpower/$id");
      return {
        "success": true,
        "data": res.data,
      };
    } catch (e) {
      return {
        "success": false,
        "data": null,
        "error": e.toString(),
      };
    }
  }

  /// Update manpower
  static Future<Map<String, dynamic>> updateManpower(
      String id, dynamic data) async {
    try {
      final res = await dio.put("/manpower/$id", data: data);
      return {
        "success": true,
        "data": res.data,
      };
    } catch (e) {
      return {
        "success": false,
        "data": null,
        "error": e.toString(),
      };
    }
  }

  /// Mark manpower as left
  static Future<Map<String, dynamic>> leftManpower(
      String id, dynamic data) async {
    try {
      final res = await dio.put("/left-manpower/$id", data: data);
      return {
        "success": true,
        "data": res.data,
      };
    } catch (e) {
      return {
        "success": false,
        "data": null,
        "error": e.toString(),
      };
    }
  }

  /// Get all left manpower
  static Future<Map<String, dynamic>> getLeftManpower() async {
    try {
      final res = await dio.put("/left-manpower");
      return {
        "success": true,
        "data": res.data,
      };
    } catch (e) {
      return {
        "success": false,
        "data": null,
        "error": e.toString(),
      };
    }
  }

  /// Fetch manpower view
  static Future<Map<String, dynamic>> fetchManpowerView() async {
    try {
      final res = await dio.get("/manpower/view");
      return {
        "success": true,
        "data": res.data,
      };
    } catch (e) {
      return {
        "success": false,
        "data": null,
        "error": e.toString(),
      };
    }
  }
}
