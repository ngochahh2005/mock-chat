part of '{{feature.snakeCase()}}_bloc.dart';

@CopyWith()
class {{feature.pascalCase()}}State extends BaseBlocState {
  const {{feature.pascalCase()}}State({
    required super.status,
    super.message,
  });

  factory {{feature.pascalCase()}}State.init() {
    return const {{feature.pascalCase()}}State(status: BaseStateStatus.init);
  }

  @override
  List get props => [
        status,
        message,
      ];
}
