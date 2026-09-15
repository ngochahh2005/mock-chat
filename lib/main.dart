import 'package:base_bloc_3/import.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
      url: 'https://nejmthtbwwwgrldyzfys.supabase.co',
      publishableKey: 'sb_publishable_1EsgC9tV2i2kavasvIryyg_-Xv1Y3G-',
      accessToken: () async {
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          return null;
        }

        return user.getIdToken();
      },
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  await EnvConfig.loadEnv();

  configureDependencies();
  await getIt<PushNotificationHelper>().initialize();
  // await getIt<LocalNotificationHelper>().init();

  // initFirebaseDynamicLink();
  // initUniLinks();
  runApp(
    const MyApp(),
  );
}
