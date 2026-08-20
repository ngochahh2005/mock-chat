import 'package:base_bloc_3/import.dart';

abstract class BaseState<W extends StatefulWidget, E, S extends BaseBlocState,
    B extends BaseBloc<E, S>> extends State<W> with BaseMethodMixin<S> {
  late B bloc;

  B provideBloc(BuildContext context) {
    return getIt.get<B>();
  }

  void initBloc(BuildContext context) {
    bloc = provideBloc(context);
  }

  Widget blocBuilder(
    Widget Function(BuildContext context, S state) builder, {
    bool Function(S previous, S current)? buildWhen,
  }) {
    return BlocBuilder<B, S>(
      bloc: bloc,
      buildWhen: buildWhen,
      builder: builder,
    );
  }

  @override
  void initState() {
    // bloc = getIt.get<B>();
    initBloc(context);
    /*
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      if (!mounted) return;
      context.pushNamed(
        Routes.forgotPasswordDynamicLink,
        params: {
          RouterParamConstants.deepLink: dynamicLinkData.link.toString()
        },
      );
    }).onError((error) {
      //DO NOTHING
      injector<LogUtils>().logD(error.toString());
    });
    */

    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @required
  Widget renderUI(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocListener<B, S>(
        listenWhen: listenWhen,
        listener: listener,
        child: renderUI(context),
      ),
    );
  }
}

abstract class BaseShareState<
    W extends StatefulWidget,
    E,
    S extends BaseBlocState,
    B extends BaseBloc<E, S>> extends State<W> with BaseMethodMixin<S> {
  late B bloc;

  B provideBloc(BuildContext context) {
    return getIt.get<B>();
  }

  void initBloc(BuildContext context) {
    bloc = provideBloc(context);
  }

  @override
  void initState() {
    initBloc(context);
    /*
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      if (!mounted) return;
      context.pushNamed(
        Routes.forgotPasswordDynamicLink,
        params: {
          RouterParamConstants.deepLink: dynamicLinkData.link.toString()
        },
      );
    }).onError((error) {
      //DO NOTHING
      injector<LogUtils>().logD(error.toString());
    });
    */

    super.initState();
  }

  Widget blocBuilder({
    required Widget Function(BuildContext c, S) builder,
    bool Function(S, S)? buildWhen,
  }) {
    return BlocBuilder<B, S>(
      bloc: bloc,
      buildWhen: buildWhen,
      builder: builder,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @required
  Widget renderUI(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocListener<B, S>(
        listenWhen: listenWhen,
        listener: listener,
        child: renderUI(context),
      ),
    );
  }
}

mixin BaseMethodMixin<S extends BaseBlocState> {
  bool listenWhen(S previous, S current) {
    return previous != current ||
        previous.status != current.status ||
        previous.message != current.message;
  }

  void listener(BuildContext context, S state) {
    if (state.status == BaseStateStatus.failed) {
      if (state.message != null && state.message!.isNotEmpty) {
        DialogUtils.showDialog(content: state.message!);
      }
    }
    if (state.status == BaseStateStatus.loading) {
      DialogUtils.showLoading();
    } else {
      DialogUtils.hideLoading();
    }
  }
}
