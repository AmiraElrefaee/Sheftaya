// lib/features/publish_job/data/services/company_service.dart

import 'dart:convert';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import '../model/company_model.dart';

class CompanyService {
  static const String _companiesKey = 'saved_companies';

  // ✅ حفظ المؤسسات
  static Future<void> saveCompanies(List<CompanyModel> companies) async {
    try {
      final List<Map<String, dynamic>> jsonList = companies.map((c) => c.toJson()).toList();
      final String jsonString = jsonEncode(jsonList);

      await SharedPrefHelper.setData(_companiesKey, jsonString);

      print('✅ Companies saved: ${companies.length} companies');
    } catch (e) {
      print('❌ Error saving companies: $e');
    }
  }

  // ✅ جلب المؤسسات
  static Future<List<CompanyModel>> getCompanies() async {
    try {
      final String? data = await SharedPrefHelper.getString(_companiesKey);

      print('📂 Raw data from SharedPref: $data');

      if (data == null || data.isEmpty) {
        print('📂 No companies found in SharedPref');
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(data);

      if (jsonList.isEmpty) {
        return [];
      }

      final List<CompanyModel> companies = jsonList
          .map((json) => CompanyModel.fromJson(json))
          .toList();

      print('✅ Companies loaded: ${companies.length} companies');
      return companies;
    } catch (e) {
      print('❌ Error loading companies: $e');
      return [];
    }
  }

  // ✅ إضافة مؤسسة جديدة
  static Future<void> addCompany(CompanyModel company) async {
    try {
      final companies = await getCompanies();
      companies.add(company);
      await saveCompanies(companies);
      print('✅ Company added: ${company.name}');
    } catch (e) {
      print('❌ Error adding company: $e');
    }
  }

  // ✅ حذف مؤسسة
  static Future<void> deleteCompany(String id) async {
    try {
      final companies = await getCompanies();
      companies.removeWhere((c) => c.id == id);
      await saveCompanies(companies);
      print('✅ Company deleted: $id');
    } catch (e) {
      print('❌ Error deleting company: $e');
    }
  }

  // ✅ جلب المؤسسة الافتراضية (آخر مؤسسة تم استخدامها)
  static Future<CompanyModel?> getDefaultCompany() async {
    try {
      final companies = await getCompanies();
      if (companies.isEmpty) return null;
      return companies.last;
    } catch (e) {
      print('❌ Error getting default company: $e');
      return null;
    }
  }

  // ✅ إنشاء ID فريد
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // ✅ التحقق من وجود بيانات (للتأكد)
  static Future<bool> hasCompanies() async {
    final companies = await getCompanies();
    return companies.isNotEmpty;
  }

  // ✅ مسح كل المؤسسات (للاختبار)
  static Future<void> clearAllCompanies() async {
    try {
      await SharedPrefHelper.removeData(_companiesKey);
      print('✅ All companies cleared');
    } catch (e) {
      print('❌ Error clearing companies: $e');
    }
  }
}