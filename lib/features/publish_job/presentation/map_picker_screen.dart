import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../../../core/widgets/custom_button.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? _pickedLocation;
  String _address = "جاري تحديد العنوان...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("حدد موقع المكان")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(30.0444, 31.2357), // القاهرة كبداية
              zoom: 15,
            ),
            myLocationEnabled: true, // بيظهر نقطة زرقاء لموقعك الحالي
            myLocationButtonEnabled: true,
            onCameraMove: (position) {
              _pickedLocation = position.target;
            },
            onCameraIdle: () async {
              if (_pickedLocation != null) {
                try {
                  log("🛰️ Fetching address for: ${_pickedLocation!.latitude}");
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                      _pickedLocation!.latitude, _pickedLocation!.longitude);

                  if (placemarks.isNotEmpty) {
                    Placemark place = placemarks.first;
                    setState(() {
                      _address = "${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}";
                    });
                  }
                } catch (e) {
                  log("❌ Geocoding Error: $e");
                  setState(() {
                    _address = "تعذر تحديد العنوان - اختر يدوياً";
                  });
                }
              }
            },
          ),
          // ماركر ثابت في نص الشاشة
          Center(child: Icon(Icons.location_pin, size: 50, color: Colors.red)),
          // زرار التأكيد
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: AppTextButton(
              buttonText: "تأكيد الموقع",
              onPressed: () {
                context.pop({
                  'lat': _pickedLocation?.latitude,
                  'lng': _pickedLocation?.longitude,
                  'address': _address,
                });
              },
            ),
          )
        ],
      ),
    );
  }
}