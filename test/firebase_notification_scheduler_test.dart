import 'package:firebase_notification_scheduler/firebase_notification_scheduler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String createFcmPayload() {
    Map m = {
      "to": "",
      "notification": {
        "title": "Title of Your Notification",
        "body": "Body of Your Notification"
      },
      "data": {"key_1": "Value for key_1", "key_2": "Value for key_2"}
    };
    return m.toString();
  }

  test('test scheduling', () {
    final firebaseNotificationScheduler =
        FirebaseNotificationScheduler('=', '');
    final String payload = createFcmPayload();
    final DateTime now = DateTime.now().toUtc();
    final DateTime dateTimeInUtc = now.add(const Duration(minutes: 1));
    firebaseNotificationScheduler.scheduleNotification(payload, dateTimeInUtc);
  });
}
