import 'package:base_bloc_3/import.dart';

final GetIt getIt = GetIt.instance;
final Talker logger = getIt.get();

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
void configureDependencies({String env = Environment.dev}) =>
    $initGetIt(getIt, environment: env);
