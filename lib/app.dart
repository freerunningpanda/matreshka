import 'package:flutter/material.dart';

import 'features/exports.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Battle Pass',
      theme: AppTheme.appTheme,
      home: const BattlePassScreen(),
    );
  }
}
