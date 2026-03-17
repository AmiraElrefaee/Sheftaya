import 'package:geolocator/geolocator.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';

import '../constants/shared_pref_keys.dart';

class LocationHelper {
  static Future<void> checkAndRequestLocation() async {
    // 1. هل المستخدم سألناه قبل كدا ورفض نهائياً؟
    // (اختياري لو عايزة تلتزمي بطلب واحد فقط)

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // رفض المرة دي، مش هنعمل حاجة هيفضل يسأل المرة الجاية
        return;
      }
    }

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      // 2. لو وافق، نجيب اللوكيشن ونحفظه (ممكن تحفظي الـ lat/long في prefs لو عايزة)
      Position position = await Geolocator.getCurrentPosition();
      await SharedPrefHelper.setData(SharedPrefKeys.lastLatitude, position.latitude);
      await SharedPrefHelper.setData(SharedPrefKeys.lastLongitude, position.longitude);
    }
  }
}