import 'package:base_bloc_3/import.dart';

class {{feature.pascalCase()}}Page extends StatefulWidget {
  const {{feature.pascalCase()}}Page({Key? key}) : super(key: key);

  @override
  State<{{feature.pascalCase()}}Page> createState() => _{{feature.pascalCase()}}PageState();
}

class _{{feature.pascalCase()}}PageState
    extends BaseState<{{feature.pascalCase()}}Page, {{feature.pascalCase()}}Event, {{feature.pascalCase()}}State, {{feature.pascalCase()}}Bloc>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    bloc.add(const {{feature.pascalCase()}}Event.onInit());
  }

  /// Uncomment this code if you want to listen to the state
  // @override
  // void listener(BuildContext context, ExampleState state) {
  //   super.listener(context, state);
  //   if (state.status == BaseStateStatus.showPopUp) {
  //     DialogUtils.showDialog();
  //   }
  // }

  @override
  Widget renderUI(BuildContext context) {
    return const BaseScaffold(
      appBar: BaseAppBar(
        title: "{{feature.pascalCase()}} Page",
      ),
      body: Center(
        child: Text("{{feature.pascalCase()}} Page"),

      ),
    );
  }
}
