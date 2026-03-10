{{#use_firebase}}
import 'package:firebase_core/firebase_core.dart';
{{/use_firebase}}
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config/constants/gen/assets.gen.dart';
{{#use_firebase}}
import 'config/firebase/firebase_options.dart';
{{/use_firebase}}
import 'core/app.dart';
import 'core/bootstrap.dart';
{{#use_notifications}}
import 'core/common/domain/services/notification/notification_service.dart';
{{/use_notifications}}

void main() async {
  bootstrap(
    builder: () => App(),
    initializers: () async {
      await dotenv.load(fileName: Assets.env.example);
{{#use_firebase}}
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
{{/use_firebase}}
{{#use_notifications}}
      await NotificationService.instance.initialize();
{{/use_notifications}}
    },
  );
}
