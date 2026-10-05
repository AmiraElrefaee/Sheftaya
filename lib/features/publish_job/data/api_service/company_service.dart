import 'dart:convert';
import 'dart:developer';
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

      log('✅ Companies saved: ${companies.length} companies');
    } catch (e) {
      log('❌ Error saving companies: $e');
    }
  }

  // ✅ جلب المؤسسات
  static Future<List<CompanyModel>> getCompanies() async {
    try {
      final data = await SharedPrefHelper.getString(_companiesKey);

      log('📂 Raw data from SharedPref: $data');

      if (data.isEmpty) {
        log('📂 No companies found in SharedPref');
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(data);

      if (jsonList.isEmpty) {
        return [];
      }

      final List<CompanyModel> companies = jsonList
          .map((json) => CompanyModel.fromJson(json))
          .toList();

      log('✅ Companies loaded: ${companies.length} companies');
      return companies;
    } catch (e) {
      log('❌ Error loading companies: $e');
      return [];
    }
  }

  // ✅ إضافة مؤسسة جديدة
  static Future<void> addCompany(CompanyModel company) async {
    try {
      final companies = await getCompanies();
      companies.add(company);
      await saveCompanies(companies);
      log('✅ Company added: ${company.name}');
    } catch (e) {
      log('❌ Error adding company: $e');
    }
  }

  // ✅ حذف مؤسسة
  static Future<void> deleteCompany(String id) async {
    try {
      final companies = await getCompanies();
      companies.removeWhere((c) => c.id == id);
      await saveCompanies(companies);
      log('✅ Company deleted: $id');
    } catch (e) {
      log('❌ Error deleting company: $e');
    }
  }

  // ✅ جلب المؤسسة الافتراضية (آخر مؤسسة تم استخدامها)
  static Future<CompanyModel?> getDefaultCompany() async {
    try {
      final companies = await getCompanies();
      if (companies.isEmpty) return null;
      return companies.last;
    } catch (e) {
      log('❌ Error getting default company: $e');
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
      log('✅ All companies cleared');
    } catch (e) {
      log('❌ Error clearing companies: $e');
    }
  }
}