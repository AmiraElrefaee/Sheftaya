import 'package:cloud_firestore/cloud_firestore.dart';

import '../../presentation/widget/enums.dart';

class ShiftRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // مراقبة حالة الوصول لحظياً
  Stream<DocumentSnapshot> getShiftStatusStream(String jobId) {
    return _firestore.collection('shifts').doc(jobId).snapshots();
  }

  // تحديث حالة الوصول
  Future<void> updateStatus(String jobId, UserRole role) async {
    final docRef = _firestore.collection('shifts').doc(jobId);

    if (role == UserRole.worker) {
      await docRef.update({'isWorkerArrived': true});
    } else {
      await docRef.update({'isEmployerConfirmed': true});
    }
  }
}