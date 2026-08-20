import 'package:base_bloc_3/import.dart';

enum EnvFlavor { dev, staging, uat, production }

// extension
extension EnvFlavorExtension on EnvFlavor {
  String get configFile {
    switch (this) {
      case EnvFlavor.dev:
        return "env/.env_dev";
      case EnvFlavor.staging:
        return "env/.env_staging";
      case EnvFlavor.production:
        return "env/.env_production";
      default:
        return "env/.env_dev";
    }
  }
}

class EnvConfig {
  static String flavor =
      const String.fromEnvironment('flavor', defaultValue: 'dev');

  // load env file
  static Future<void> loadEnv() async {
    log("flavor: $flavor");
    await dotenv.load(fileName: getEnvFlavor().configFile);
  }

  static EnvFlavor getEnvFlavor() {
    switch (flavor) {
      case 'dev':
        return EnvFlavor.dev;
      case 'staging':
        return EnvFlavor.staging;
      case 'uat':
        return EnvFlavor.uat;
      case 'production':
        return EnvFlavor.production;
      default:
        return EnvFlavor.dev;
    }
  }

  static bool isDevelopmentEnv() {
    return flavor != 'production';
  }
}
