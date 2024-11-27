import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/constants.dart';

class StaffService {
  // Get all staff
  static Future<List<Map<String, dynamic>>> getAllStaff() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/petugas'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      } else {
        throw Exception('Failed to load staff: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting staff: $e');
    }
  }

  // Create new staff
  static Future<Map<String, dynamic>> createStaff(Map<String, dynamic> staffData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/petugas'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(staffData),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create staff: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating staff: $e');
    }
  }

  // Update staff
  static Future<Map<String, dynamic>> updateStaff(int id, Map<String, dynamic> staffData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/petugas/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(staffData),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update staff: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating staff: $e');
    }
  }

  // Delete staff
  static Future<void> deleteStaff(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/petugas/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete staff: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting staff: $e');
    }
  }

  // Get single staff
  static Future<Map<String, dynamic>> getStaffById(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/petugas/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load staff: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error getting staff: $e');
    }
  }
} 