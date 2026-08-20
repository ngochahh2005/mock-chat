import 'package:base_bloc_3/base/bloc/base_bloc_state.dart';
import 'package:base_bloc_3/common/index.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:stream_transform/stream_transform.dart';

abstract class BaseBloc<E, S extends BaseBlocState> extends Bloc<E, S> {
  BaseBloc(super.initialState);

  final localPref = getIt<LocalStorage>();

  // final connectivity = Connectivity().onConnectivityChanged;

  EventTransformer<E> debounce(Duration duration) {
    return (events, mapper) {
      return events.debounce(duration).switchMap(mapper);
    };
  }
}
