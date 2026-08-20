import 'package:base_bloc_3/import.dart';

@module
abstract class AppModule {
  @singleton
  Talker get talker => TalkerFlutter.init(
        settings: TalkerSettings(
          enabled: EnvConfig.isDevelopmentEnv(),
        ),
      );

  @singleton
  Dio get dio => DioBuilder().getDio();

  @singleton
  EventBus get eventBus => EventBus();
}
