import 'package:equatable/equatable.dart';

import 'package:base_bloc_3/base/bloc/bloc_status.dart';

abstract class BaseBlocState extends Equatable {
  const BaseBlocState({
    required this.status,
    this.message,
  });

  final BaseStateStatus status;
  final String? message; // Send error for UI

  @override
  List get props => [status, message];
}
