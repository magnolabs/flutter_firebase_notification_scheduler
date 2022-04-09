# Flutter Firebase Notification Scheduler

A simple plugin to schedule your firebase notification with help of this [Rapid api](https://rapidapi.com/magno-labs-magno-labs-default/api/firebase-notification-scheduler)

## Installation

Add *firebase_notification_scheduler* as a dependency in [your pubspec.yaml file](https://flutter.io/platform-plugins/).

```
firebase_notification_scheduler : any
```

## How to
#### Creating API Key's
 1.  Signup for the Firebase Notification Scheduler Rapid API and get API Key [from here](https://rapidapi.com/magno-labs-magno-labs-default/api/firebase-notification-scheduler).
 2.  Create your authentication key [from here](http://fns-registration.magnolabs.in)

#### Initialising Package
```
final FirebaseNotificationScheduler firebaseNotificationScheduler =  
    FirebaseNotificationScheduler(  
        authenticationKey: <YOUR-RAPID-API-KEY> ,
        rapidApiKey:  <YOUR-AUTHENTICATION-KEY>
        );
  ```

#### Scheduling a notification
```
//Schedules a notification to the next minute
firebaseNotificationScheduler.scheduleNotification(  
    {  
      "to":  
          "fYZpGcSSSSKHRbXpqzMXDU:APA91bFrdQmaBe0MikHf-k3821Fq0jQ0U-sDXpbgXcjfdNpg9AMaZLQPos6-j2Ru9tc4bvLXmngxeXvZoINpzkLtVoLXLsJcZlcIlc7O_MCHkU_UOX2lkllTxOiAF2mZyBETA7vgaNl-",  
  "notification": {  
        "title": "Title of Your Notification",  
  "body": "Body of Your Notification"  
  },  
  "data": {"key_1": "Value for key_1", "key_2": "Value for key_2"}  
    }.toString(),  
  DateTime.now().add(const Duration(minutes: 1)).toUtc());
```

#### Getting all Scheduled notifications
```
List<ScheduledNotification> list=await firebaseNotificationScheduler.getAllScheduledNotification();
```

#### Cancelling a notification
```
firebaseNotificationScheduler.cancelNotification('k3821Fq0jQ0U-sDXp');
```