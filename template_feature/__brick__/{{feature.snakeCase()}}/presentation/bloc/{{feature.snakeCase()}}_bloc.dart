import 'package:base_bloc_3/import.dart';

part '{{feature.snakeCase()}}_bloc.freezed.dart';
part '{{feature.snakeCase()}}_bloc.g.dart';
part '{{feature.snakeCase()}}_event.dart';
part '{{feature.snakeCase()}}_state.dart';

@injectable
class {{feature.pascalCase()}}Bloc extends BaseBloc<{{feature.pascalCase()}}Event, {{feature.pascalCase()}}State>
    with BaseCommonMethodMixin {
{{feature.pascalCase()}}Bloc(this._repo) : super({{feature.pascalCase()}}State.init()) {
    on<{{feature.pascalCase()}}Event>(({{feature.pascalCase()}}Event event, Emitter<{{feature.pascalCase()}}State> emit) async {
      await event.when(
        onInit: () => onInit(emit),
      );
    });
  }

  final {{feature.pascalCase()}}Repo _repo;

  Future onInit(Emitter<{{feature.pascalCase()}}State> emit) async {

  }
}
