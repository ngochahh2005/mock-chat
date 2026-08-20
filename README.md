
# Base Project Flutter
Requirement:
- Flutter 3.38.4
- Java 17

## Packages 

- [Bloc Pattern: flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [Navigation: auto_route](https://pub.dev/packages/auto_route)
- [DI: get_it](https://pub.dev/packages/get_it)
- [Network: dio](https://pub.dev/packages/dio)
- [Localization: easy_localization](https://pub.dev/packages/easy_localization)
- [Flavors: production, dev, staging](https://docs.flutter.dev/deployment/flavors)
- [Model generator: Freezed](https://pub.dev/packages/freezed)
- [Dio client generator: retrofit](https://pub.dev/packages/retrofit)
-  ...

## First Time Setup after fork
run command in terminal
```bash
sh repo_setup.sh
```


## Installation

Generate code command: 

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```
    
## Run project
```bash
flutter run --flavor dev -t lib/main.dart --dart-define=flavor=dev
```

## Update automatic code generation for multiple languages
```bash
dart run intl_utils:generate
```

## Project structure
```
 
│
└───base // contains base (bloc, state, ...) & network config
│    
└───common // contains app theme, config, extensions, common widgets ...
│   
└───data // data layer
│   
└───di // dependency injection
│   
└───features // domain and presentation layer
│   
└───routes // navigation  
│
└───translations // localization
│   
└───main.dart
```

Feature structure
---
Use CLEAN architecture

![App Screenshot](https://i0.wp.com/resocoder.com/wp-content/uploads/2019/08/Clean-Architecture-Flutter-Diagram.png?ssl=1)
```
│
└───data
│   └─── model 
│   └─── remote
│            └─── service 
│            └─── source
│   └─── repository (impl)
└───domain
│   └─── entity
│   └─── repository (abstract)
└───presentation
│   └─── bloc
│   └─── pages
│   └─── widgets
```

## Generate a Feature code with Mason Brick
- [Mason](https://pub.dev/packages/mason_cli)
- Activate Mason with Dart:
```bash
dart pub global activate mason
```

- Run command to get Mason template
```bash
mason get
```

- Run command to generate feature code
```bash
mason make template_feature -o ./lib/features
```

## How to use pagination
- Using **infinite_scroll_pagination** library (PagingController V5)
- in bloc
**Init the paging controller**, add **PagingCommonMethodMixin** mixin to bloc.

```dart
class ExampleBloc extends BaseBloc<ExampleEvent, ExampleState>
    with PagingCommonMethodMixin {
  final ExampleRepo _repo;
  late final PagingController<int, UserEntity> pagingController;

  ExampleBloc(this._repo) : super(ExampleState.init()) {
    pagingController = createPagingController<UserEntity>(
      fetchData: (pageKey) => _repo.getData(
        request: PagingRequest(page: pageKey, limit: ApiConfig.limit),
      ),
      limit: ApiConfig.limit,
    );
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
```

- in view
Use **CustomListViewSeparated** or **CustomGridView** with RefreshIndicator. See in paging_list_view.dart
```dart
class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState
    extends BaseState<ExamplePage, ExampleEvent, ExampleState, ExampleBloc> {
  @override
  Widget renderUI(BuildContext context) {
    return BaseScaffold(
      appBar: const BaseAppBar(title: "Example Page"),
      body: RefreshIndicator(
        onRefresh: () async {
          bloc.pagingController.refresh();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: CustomListViewSeparated(
          controller: bloc.pagingController,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          builder: (context, user, index) => UserItem(
            user: user,
            onTap: () {
              bloc.add(ExampleEvent.getUserDetail(user));
            },
          ),
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
        ),
      ),
    );
  }
}
```

### Paging Helper Methods
- **pagingControllerRemoveItemBy**: Remove items by predicate, automatically fetches next page if remaining items < 2 * limit
- **pagingUpdateItemBy**: Update items by predicate using transformation function
- **pagingControllerAddItem**: Add item at specified index (requires manual page rebuilding)
## Dialog & bottomsheet
- at common/utils/
## Common widgets (button, textfield)
- at common/widgets/



## Flavor
Using
- [Flutter dotenv](https://pub.dev/packages/flutter_dotenv)
  Config env in
```
│
└───env
│   └─── .env_dev
│   └─── .env_staging
│   └─── .env_production
```
In Android
----------- 
Add google_services.json to
```
│
└───android
│   └─── app
│            └─── dev 
│            └─── staging
│            └─── production
```
Change applicationId & App name in android/app/build.gradle
```
    flavorDimensions "app"

    productFlavors {
        dev {
            dimension "app"
            resValue "string","app_name","Base Bloc Flutter 3 Dev"
            applicationId "com.example.base_bloc_3.dev"
        }
        staging {
            dimension "app"
            resValue "string","app_name","Base Bloc Flutter 3 Stagin"
            applicationId "com.example.base_bloc_3.staging"
        }
        production {
            dimension "app"
            resValue "string", "app_name", "Base Bloc Flutter 3"
        }

    }
```

```
    applicationId "com.example.base_bloc_3"
```
In IOS
------
Add google google_services.plist to
```
│
└───Runner
│   └─── config
│            └─── dev 
│            └─── staging
│            └─── production
```
Change Product Bundle Identifier in Runner/Targets/Runner/Build Setting/Product Bundle Identifier
Change App Display Name in Runner/Targets/Runner/Build Setting/User-Defined/APP_DISPLAY_NAME

## Push Notification
Using
- [Firebase Messing](https://pub.dev/packages/firebase_messaging)

Initial Firebase Message
```dart
    Future<void> initialize({Function(String)? handleNotificationOnTap,})
```

Listen onMessage
```dart
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        
    });
``` 
Listen onBackgroundMessage
```dart
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
```
Listen onMessage when App opened & handle onTap notification
```dart
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          
    });
```

## Local Notification
Using
- [Flutter Local Notification](https://pub.dev/packages/flutter_local_notifications)


Init local Notification
```dart
    Future<void> init()
```


Show Notification
```dart
    Future<void> showNotification({
    required String title,
    required String body,
    String channelId = NotificationConfig.highChannelId,
    String? payload,
    Importance? importance,
    Priority? priority,
  }){}
```

Hanlde onTap Notification
```dart
    Future<dynamic> selectNotification(String? payload) async {
    }
```

