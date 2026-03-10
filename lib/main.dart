import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config/constants/gen/assets.gen.dart';
import 'config/firebase/firebase_options.dart';
import 'core/app.dart';
import 'core/bootstrap.dart';
import 'core/common/domain/services/notification/notification_service.dart';

void main() async {
  bootstrap(
    builder: () => App(),
    initializers: () async {
      await dotenv.load(fileName: Assets.env.example);
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await NotificationService.instance.initialize();
      // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    },
  );
}
