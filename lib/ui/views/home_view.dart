import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  /// App lifecycle logic
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // print("APP STATE RESUMED");
        break;
      case AppLifecycleState.inactive:
        // print("APP STATE INACTIVE");
        break;
      case AppLifecycleState.paused:
        // print("APP STATE PAUSED");
        break;
      case AppLifecycleState.detached:
        // print("APP STATE DETACHED");
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
    );
  }
}
