// features/shift_details/presentation/widget/enums.dart

enum ShiftStatus {
  notStarted,
  onTheWay,
  arrived,
  arrivedApproved,
  inProgress,
  completed,
}

enum ShiftStepStatus { pending, inProgress, completed }
enum UserRole { worker, employer }

extension ShiftStatusExtension on ShiftStatus {
  static ShiftStatus fromString(String value) {
    switch (value) {
      case 'on_the_way':       return ShiftStatus.onTheWay;
      case 'arrived':          return ShiftStatus.arrived;
      case 'arrived_approved': return ShiftStatus.arrivedApproved;
      case 'in_progress':      return ShiftStatus.inProgress;
      case 'completed':        return ShiftStatus.completed;
      default:                 return ShiftStatus.notStarted;
    }
  }
}