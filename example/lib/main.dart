//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notification_scheduler/firebase_notification_scheduler.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Notification Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Firebase Notification Scheduler'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ///Rapid API Key: visit https://rapidapi.com/magno-labs-magno-labs-default/api/firebase-notification-scheduler and signup for the service to obtain a key.
  ///AUTHENTICATION KEY: visit https://fns-registration.magnolabs.in after getting rapid API KEY.

  final FirebaseNotificationScheduler firebaseNotificationScheduler =
      FirebaseNotificationScheduler(
          authenticationKey:
              ,
          rapidApiKey: );

  late Future<List<ScheduledNotification>> getScheduledNotificationFuture;

  @override
  void initState() {
    super.initState();
    getScheduledNotificationFuture =
        firebaseNotificationScheduler.getAllScheduledNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FNS Example'),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: scheduleNotificationWidget()),
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: getScheduledNotificationsButton()),
              ],
            ),
            const Divider(),
            const Text(
              'Your Scheduled notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            scheduledNotificationList()
          ],
        ),
      ),
    );
  }

  Widget scheduleNotificationWidget() {
    String payload = createFcmPayload();
    DateTime now = DateTime.now().toUtc();
    DateTime dateTimeInUtc = now.add(const Duration(minutes: 1));

    return ElevatedButton.icon(
        onPressed: () async {
          debugPrint('scheduling a new notification');
          await firebaseNotificationScheduler.scheduleNotification(
              payload, dateTimeInUtc);
          getScheduledNotificationFuture =
              firebaseNotificationScheduler.getAllScheduledNotification();
          setState(() {});
        },
        icon: const Icon(Icons.add),
        label: const Text('Schedule for next minute'));
  }

  String createFcmPayload() {
    //todo: remove sensitive token
    Map m = {
      "to":
          "",
      "notification": {
        "title": "Title of Your Notification",
        "body": "Body of Your Notification"
      },
      "data": {"key_1": "Value for key_1", "key_2": "Value for key_2"}
    };
    return m.toString();
  }

  Widget scheduledNotificationList() {
    return FutureBuilder(
        future: getScheduledNotificationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            List<ScheduledNotification> data =
                snapshot.data as List<ScheduledNotification>;

            if (data.isEmpty) {
              return const Center(child: Text('No scheduled notifications'));
            }

            return ListView.separated(
                separatorBuilder: (c, i) => const Divider(),
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: (buildContext, index) {
                  ScheduledNotification item = data[index];
                  bool isQueued = item.status.contains('QUEUED') ||
                      item.status.contains('READY');
                  return ListTile(
                    title: Text('Scheduled to ' +
                        DateFormat.yMMMMd().add_jm().format(item.sendAt)),
                    subtitle: Text('Status ' + item.status),
                    trailing: isQueued
                        ? TextButton(
                            child: const Text('Cancel'),
                            onPressed: () async {
                              await firebaseNotificationScheduler
                                  .cancelNotification(item.messageId);
                              firebaseNotificationScheduler
                                  .getAllScheduledNotification();
                              setState(() {});
                            },
                          )
                        : const SizedBox(
                            width: 0,
                          ),
                  );
                });
          }
          if (snapshot.hasError) {
            return Text(
                "Couldn't fetch your scheduled notifications\n ERROR: ${snapshot.error}");
          }

          return const Text("No data");
        });
  }

  Widget getScheduledNotificationsButton() {
    return ElevatedButton.icon(
      onPressed: () {
        getScheduledNotificationFuture =
            firebaseNotificationScheduler.getAllScheduledNotification();
        setState(() {});
      },
      icon: const Icon(Icons.refresh),
      label: const Text("Refresh notifications list"),
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
    );
  }
}
