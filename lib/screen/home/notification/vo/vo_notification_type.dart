enum NotificationType {
  activityApply,
  activityReply,
  requestMatching,
  acceptMatching,
  activity;

  static NotificationType fromString(String type) {
    switch (type) {
      case 'activityApply':
        return NotificationType.activityApply;
      case 'activityReply':
        return NotificationType.activityReply;
      case 'requestMatching':
        return NotificationType.requestMatching;
      case 'acceptMatching':
        return NotificationType.acceptMatching;
      case 'activity':
        return NotificationType.activity;
      default:
        throw ArgumentError('Unknown notification type: $type');
    }
  }

  @override
  String toString() {
    switch (this) {
      case NotificationType.activityApply:
        return 'activityApply';
      case NotificationType.activityReply:
        return 'activityReply';
      case NotificationType.requestMatching:
        return 'requestMatching';
      case NotificationType.acceptMatching:
        return 'acceptMatching';
      case NotificationType.activity:
        return 'activity';
      default:
        return '';
    }
  }
}
