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
    switch (value.toLowerCase()) {
      case 'on_the_way':
        return ShiftStatus.onTheWay;
      case 'arrived':
        return ShiftStatus.arrived;
      case 'arrived_approved':
      case 'approve-arrival':  // ← أضيفي هذا
        return ShiftStatus.arrivedApproved;
      case 'in_progress':
      case 'start':            // ← أضيفي هذا
        return ShiftStatus.inProgress;
      case 'completed':
      case 'end':              // ← أضيفي هذا
        return ShiftStatus.completed;
      default:
        return ShiftStatus.notStarted;
    }
  }
}