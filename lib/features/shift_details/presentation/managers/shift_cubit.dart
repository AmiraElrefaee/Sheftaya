import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../data/model/shift_model.dart';
import '../../domain/repo/shift_repo.dart';
import '../widget/enums.dart';

part 'shift_state.dart';

class ShiftCubit extends Cubit<ShiftState> {
  final ShiftRepository repository;
  ShiftCubit(this.repository) : super(ShiftLoading());

  void initShiftDetails(String jobId) async {
    // 1. هاتي بيانات الـ API (Dummy Data حالياً)
    final dummyApiData = {
      'title': 'نادل',
      'companyName': 'Center Perk Cafe',
      'price': 400.0,
      'imageUrl': 'https://link-to-photo.com',
      'startTime': DateTime.now().copyWith(hour: 14, minute: 0),
    };

    // 2. ابدأي اسمعي للـ Firebase لحظياً
    repository.getShiftStatusStream(jobId).listen((snapshot) {
      // ✅ تصحيح: الـ Null Check الصريح للـ snapshot
      if (snapshot.exists) {
        final shift = ShiftModel.fromSnapshot(snapshot, dummyApiData);
        emit(ShiftLoaded(shift));
      } else {
        // لو الـ Document مش موجودة، انشئيها بقيم افتراضية
        _initializeFirebaseDoc(jobId);
      }
    });
  }

  Future<void> _initializeFirebaseDoc(String jobId) async {
    await FirebaseFirestore.instance.collection('shifts').doc(jobId).set({
      'isWorkerArrived': false,
      'isEmployerConfirmed': false,
    });
  }

  void confirmArrival(String jobId, UserRole role) {
    repository.updateStatus(jobId, role);
  }
}
