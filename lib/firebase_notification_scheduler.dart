library firebase_notification_scheduler;

import 'dart:convert';

import 'package:http/http.dart' as http;

///Please get authentication keys by visiting https://fns-registration.magnolabs.in.
class FirebaseNotificationScheduler {
  final String authenticationKey;
  final String rapidApiKey;
  late Map<String, String> header;

  http.Client client = http.Client();

  FirebaseNotificationScheduler(
      {required this.authenticationKey, required this.rapidApiKey}) {
    header = {
      'content-type': 'application/json',
      'Authorization': 'Basic $authenticationKey',
      'X-RapidAPI-Host': 'firebase-notification-scheduler.p.rapidapi.com',
      'X-RapidAPI-Key': rapidApiKey
    };
  }

  final String _endPoint =
      'https://firebase-notification-scheduler.p.rapidapi.com';

  Future<String> scheduleNotification({
      required String payload,required DateTime dateTimeInUtc}) async {
    final String _path = '$_endPoint/messages';

    final Map _formData = {
      "payload": payload,
      "sendAt": dateTimeInUtc.toIso8601String()
    };

    final _response = await client.post(Uri.parse(_path),
        body: jsonEncode(_formData), headers: header);

    final _json = jsonDecode(_response.body);

    if (_response.statusCode != 200) {
      throw Exception('Failed to schedule notification ${_json['message']}');
    }

    return _json['scheduledMessageId'];
  }

  Future cancelNotification({required String messageId}) async {
    final String _path = '$_endPoint/messages/$messageId/abort';
    final _response = await client.put(Uri.parse(_path), headers: header);
    if (_response.statusCode != 200) {
      throw Exception(
          'Failed to cancel scheduled notification $messageId \n ${jsonDecode(_response.body)['message']}');
    }
    return true;
  }

  Future<List<ScheduledNotification>> getAllScheduledNotification() async {
    final String _path = '$_endPoint/messages';

    final _response = await client.get(Uri.parse(_path), headers: header);

    if (_response.statusCode != 200) {
      throw Exception(
          'Failed to get all scheduled notification. Please try again later');
    }

    return scheduledNotificationFromMap(_response.body);
  }
}

List<ScheduledNotification> scheduledNotificationFromMap(String str) =>
    List<ScheduledNotification>.from(
        json.decode(str).map((x) => ScheduledNotification.fromMap(x)));

String scheduledNotificationToMap(List<ScheduledNotification> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ScheduledNotification {
  ScheduledNotification({
    required this.appId,
    required this.messageId,
    required this.sendAt,
    required this.created,
    required this.status,
  });

  String appId;
  String messageId;
  DateTime sendAt;
  DateTime created;
  String status;

  factory ScheduledNotification.fromMap(Map<String, dynamic> json) =>
      ScheduledNotification(
        appId: json["appId"],
        messageId: json["messageId"],
        sendAt: DateTime.parse(json["sendAt"]),
        created: DateTime.parse(json["created"]),
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "appId": appId,
        "messageId": messageId,
        "sendAt": sendAt.toIso8601String(),
        "created": created.toIso8601String(),
        "status": status,
      };
}
