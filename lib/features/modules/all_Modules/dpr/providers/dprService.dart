import 'package:dio/dio.dart';
import '../../../../../core/api/dio.dart';
import '../models/dprModel.dart';


class DprApi {
  // Fetch DPR Work List
  static Future<List<DprModel>> fetchDprWork({
    required String siteId,
    required String teamId,
  }) async {
    final response = await DioClient.dio.get(
      "/site/$siteId/team/$teamId/dpr-mechanical",
      options: Options(
        extra: {"withCredentials": true},
      ),
    );

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((e) => DprModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to fetch DPR work");
    }
  }

  // Post DPR Work
  static Future<DprModel> postDprWork({
    required Map<String, dynamic> data,
    required String siteId,
    required String teamId,
  }) async {
    final response = await DioClient.dio.post(
      "/site/$siteId/team/$teamId/dpr-mechanical",
      queryParameters: {"type": "mechanical_work"},
      data: data,
      options: Options(extra: {"withCredentials": true}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return DprModel.fromJson(response.data);
    } else {
      throw Exception("Failed to create DPR work");
    }
  }

  // Fetch DPR Work by ID
  static Future<DprModel> fetchDprWorkById({
    required String siteId,
    required String teamId,
    required String workId,
  }) async {
    final response = await DioClient.dio.get(
      "/site/$siteId/team/$teamId/dpr-mechanical/$workId",
      options: Options(extra: {"withCredentials": true}),
    );

    if (response.statusCode == 200) {
      return DprModel.fromJson(response.data);
    } else {
      throw Exception("Failed to fetch DPR work by ID");
    }
  }

  // Update DPR Material Qty
  static Future<void> updateDprMaterialQty({
    required Map<String, dynamic> data,
    required String siteId,
    required String materialId,
  }) async {
    final response = await DioClient.dio.post(
      "/site/$siteId/team/$materialId/dpr-mechanical/qty",
      data: data,
      options: Options(
        headers: {"Content-Type": "application/json"},
        extra: {"withCredentials": true},
      ),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update DPR material qty");
    }
  }

  // Update DPR Work
  static Future<void> updateDprWork({
    required Map<String, dynamic> data,
    required String mechanicalId,
  }) async {
    final response = await DioClient.dio.put(
      "/mechnical/$mechanicalId/update",
      data: data,
      options: Options(extra: {"withCredentials": true}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update DPR work");
    }
  }

  // Copy DPR Material
  static Future<void> copyDprMaterial({
    required String siteId,
    required String materialId,
  }) async {
    final response = await DioClient.dio.put(
      "/site/$siteId/team/$materialId/dpr-mechanical/copy",
      options: Options(extra: {"withCredentials": true}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to copy DPR material");
    }
  }

  // Post DPR Material
  static Future<void> postDprMaterial({
    required FormData data,
    required String mechanicalId,
  }) async {
    final response = await DioClient.dio.post(
      "/mechnical/$mechanicalId",
      data: data,
      options: Options(extra: {"withCredentials": true}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to post DPR material");
    }
  }

  // Patch DPR Material
  static Future<void> patchDprMaterial({
    required FormData data,
    required String mechanicalId,
  }) async {
    final response = await DioClient.dio.patch(
      "/mechnical/$mechanicalId",
      data: data,
      options: Options(extra: {"withCredentials": true}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update DPR material");
    }
  }

  // Delete DPR Material
  static Future<void> deleteDprMaterial({
    required FormData data,
    required String mechanicalId,
  }) async {
    final response = await DioClient.dio.delete(
      "/mechnical/$mechanicalId",
      data: data,
      options: Options(extra: {"withCredentials": true}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete DPR material");
    }
  }

  // Fetch Measurement Sheet
  static Future<List<dynamic>> fetchMeasurementSheet({
    required String siteId,
    required String fromDate,
    required String toDate,
  }) async {
    final response = await DioClient.dio.get(
      "/site/$siteId/team/123/dpr-mechanical/measurment-sheet-dpr",
      queryParameters: {"fromDate": fromDate, "toDate": toDate},
      options: Options(extra: {"withCredentials": true}),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("Failed to fetch measurement sheet");
    }
  }

  // Fetch Measurement Calculation Sheet
  static Future<List<dynamic>> fetchMeasurementCalculationSheet({
    required String siteId,
    required String fromDate,
    required String toDate,
  }) async {
    final response = await DioClient.dio.get(
      "/site/$siteId/team/123/dpr-mechanical/measurment-calculation-sheet",
      queryParameters: {"fromDate": fromDate, "toDate": toDate},
      options: Options(extra: {"withCredentials": true}),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("Failed to fetch calculation sheet");
    }
  }

  // Fetch Summary Sheet
  static Future<List<dynamic>> fetchSummarySheet({
    required String siteId,
    required String fromDate,
    required String toDate,
  }) async {
    final response = await DioClient.dio.get(
      "/site/$siteId/team/123/dpr-mechanical/summery-sheet",
      queryParameters: {"fromDate": fromDate, "toDate": toDate},
      options: Options(extra: {"withCredentials": true}),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("Failed to fetch summary sheet");
    }
  }

  // Fetch Invoice Sheet
  static Future<List<dynamic>> fetchInvoiceSheet({
    required String siteId,
    required String fromDate,
    required String toDate,
  }) async {
    final response = await DioClient.dio.get(
      "/site/$siteId/team/123/dpr-mechanical/invoice-sheet",
      queryParameters: {"fromDate": fromDate, "toDate": toDate},
      options: Options(extra: {"withCredentials": true}),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("Failed to fetch invoice sheet");
    }
  }
}
