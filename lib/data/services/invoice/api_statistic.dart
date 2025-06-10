import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend_appflowershop/utils/constants.dart';
import 'package:frontend_appflowershop/utils/preference_service.dart';
import 'package:frontend_appflowershop/data/models/invoice.dart';

class ApiStatisticService {
  Future<List<InvoiceModel>> getInvoices() async {
    try {
      final token = await PreferenceService.getToken();
      if (token == null) throw Exception('Token not found');

      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/invoice'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((item) => InvoiceModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load invoices');
      }
    } catch (e) {
      throw Exception('Error fetching invoices: $e');
    }
  }
}
